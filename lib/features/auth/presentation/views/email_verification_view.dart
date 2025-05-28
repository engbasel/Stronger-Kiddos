// في lib/features/auth/presentation/views/email_verification_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/core/helper/failuer_top_snak_bar.dart';
import 'package:strongerkiddos/core/helper/scccess_top_snak_bar.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_progrss_hud.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/verification_cubit/verification_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/verification_cubit/verification_state.dart';
import 'package:strongerkiddos/features/auth/presentation/views/login_view.dart';
import 'package:strongerkiddos/features/home/presentation/views/main_navigation_view.dart';

class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key, required this.email});
  final String email;

  static const String routeName = '/email-verification';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationCubit()..startEmailVerificationCheck(),
      child: BlocConsumer<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            succesTopSnackBar(context, 'Email verified successfully');
            Navigator.pushReplacementNamed(context, MainNavigationView.routeName);
          } else if (state is VerificationFailure) {
            failuerTopSnackBar(context, state.message);
          } else if (state is ResendVerificationEmailSuccess) {
            succesTopSnackBar(
              context,
              'Verification email sent. Please check your inbox.',
            );
          }
        },
        builder: (context, state) {
          return CustomProgrssHud(
            isLoading: state is VerificationLoading,
            child: Scaffold(
              appBar: AppBar(title: const Text('Email Verification')),
              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange,
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Verify your email address',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'We have sent a verification link to $email',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please check your inbox and verify your email to continue.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'I have verified my email',
                      onPressed: () {
                        context
                            .read<VerificationCubit>()
                            .checkEmailVerification();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        context
                            .read<VerificationCubit>()
                            .resendVerificationEmail();
                      },
                      child: const Text('Resend verification email'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          LoginView.routeName,
                        );
                      },
                      child: const Text('Back to login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
