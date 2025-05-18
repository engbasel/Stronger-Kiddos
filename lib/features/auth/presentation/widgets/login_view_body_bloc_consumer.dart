// lib/features/auth/presentation/widgets/login_view_body_bloc_consumer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../core/services/auth_guard.dart';
import '../../../../core/widgets/custom_progrss_hud.dart';
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
            // Use the new AuthGuard method to determine where to navigate
            final nextRoute = await AuthGuard.getInitialRoute();

            if (context.mounted) {
              // Navigate directly to the appropriate screen
              if (nextRoute == EmailVerificationView.routeName) {
                final email =
                    state is LoginSuccess
                        ? state.user.email
                        : state is GoogleLoginSuccess
                        ? state.user.email
                        : '';

                Navigator.pushReplacementNamed(
                  context,
                  EmailVerificationView.routeName,
                  arguments: {'email': email},
                );
              } else {
                Navigator.pushReplacementNamed(context, nextRoute);
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
