// في lib/core/guards/auth_guard.dart
import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import '../services/get_it_service.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/email_verification_view.dart';

class AuthGuard {
  static final FirebaseAuthService _authService = getIt<FirebaseAuthService>();

  static Future<bool> canActivate(BuildContext context) async {
    // التحقق من تسجيل الدخول
    if (!_authService.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, LoginView.routeName);
      return false;
    }

    // التحقق من توثيق البريد الإلكتروني
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

    return true;
  }
}
