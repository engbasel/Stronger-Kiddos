// lib/core/services/auth_guard.dart
import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import '../services/get_it_service.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/email_verification_view.dart';
import '../../features/questionnaire/domain/repos/questionnaire_repo.dart';
import '../../features/questionnaire/presentation/views/questionnaire_controller_view.dart';

class AuthGuard {
  static final FirebaseAuthService _authService = getIt<FirebaseAuthService>();
  static final QuestionnaireRepo _questionnaireRepo =
      getIt<QuestionnaireRepo>();

  static Future<bool> canActivate(BuildContext context) async {
    // Check if logged in
    if (!_authService.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, LoginView.routeName);
      return false;
    }

    // Check email verification
    bool isEmailVerified = await _authService.checkEmailVerification();
    if (!isEmailVerified) {
      String? email = _authService.currentUser?.email;
      if (!context.mounted) return false;
      Navigator.pushReplacementNamed(
        context,
        EmailVerificationView.routeName,
        arguments: {'email': email ?? ''},
      );
      return false;
    }

    // Check if questionnaire is completed
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      final result = await _questionnaireRepo.hasCompletedQuestionnaire(
        userId: userId,
      );

      final hasCompletedQuestionnaire = result.fold(
        (failure) => false,
        (completed) => completed,
      );

      if (!hasCompletedQuestionnaire && context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          QuestionnaireControllerView.routeName,
        );
        return false;
      }
    }

    return true;
  }
}
