// lib/features/auth/presentation/widgets/login_view_body_bloc_consumer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/services/get_it_service.dart';
import '../../../../core/widgets/custom_progrss_hud.dart';
import '../../../../features/questionnaire/domain/repos/questionnaire_repo.dart';
import '../../../../features/questionnaire/presentation/views/questionnaire_controller_view.dart';
import '../../../home/presentation/Views/home_view.dart';
import '../manager/login_cubit/login_cubit.dart';
import '../manager/login_cubit/login_state.dart';
import '../views/email_verification_view.dart';
import 'login_view_body.dart';

class LoginViewBodyBlocConsumer extends StatelessWidget {
  const LoginViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccess ||
              state is GoogleLoginSuccess ||
              state is LoginOffline) {
            // Check if user has completed questionnaire
            final authService = getIt<FirebaseAuthService>();
            final questionnaireRepo = getIt<QuestionnaireRepo>();
            final userId = authService.currentUser?.uid;

            if (userId != null) {
              final result = await questionnaireRepo.hasCompletedQuestionnaire(
                userId: userId,
              );

              final hasCompletedQuestionnaire = result.fold(
                (failure) => false,
                (completed) => completed,
              );

              if (!context.mounted) return;

              if (hasCompletedQuestionnaire) {
                Navigator.pushReplacementNamed(context, HomeView.routeName);
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  QuestionnaireControllerView.routeName,
                );
              }
            }
          } else if (state is LoginRequiresVerification) {
            Navigator.pushReplacementNamed(
              context,
              EmailVerificationView.routeName,
              arguments: {'email': state.email},
            );
          } else if (state is PasswordResetEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Password reset email sent. Please check your inbox.',
                ),
              ),
            );
          } else if (state is LoginFailure) {
            failuerTopSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return CustomProgrssHud(
            isLoading: state is LoginLoading,
            child: const LoginViewBody(),
          );
        },
      ),
    );
  }
}
