import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../core/widgets/custom_progrss_hud.dart';
import '../../../home/presentation/Views/home_view.dart';
import '../manager/login_cubit/login_cubit.dart';
import '../manager/login_cubit/login_state.dart';
import '../views/email_verification_view.dart';
import '../views/password_verification_view.dart';
import 'login_view_body.dart';

class LoginViewBodyBlocConsumer extends StatelessWidget {
  const LoginViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Check if email is verified
            if (state.user.isEmailVerified) {
              Navigator.pushReplacementNamed(context, HomeView.routeName);
            } else {
              Navigator.pushReplacementNamed(
                context,
                EmailVerificationView.routeName,
                arguments: state.user.email,
              );
            }
          } else if (state is GoogleLoginSuccess) {
            // Check if email is verified for Google login
            if (state.user.isEmailVerified) {
              Navigator.pushReplacementNamed(context, HomeView.routeName);
            } else {
              Navigator.pushReplacementNamed(
                context,
                EmailVerificationView.routeName,
                arguments: state.user.email,
              );
            }
          } else if (state is LoginOffline) {
            // For offline login, allow access even if email not verified
            Navigator.pushReplacementNamed(context, HomeView.routeName);
          } else if (state is PasswordResetEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Password reset email sent. Please check your inbox.',
                ),
              ),
            );
            Navigator.pushNamed(context, PasswordVerificationView.routeName);
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
