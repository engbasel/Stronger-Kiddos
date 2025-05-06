import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/email_verification_cubit/email_verification_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/views/login_view.dart';

class EmailVerificationViewBody extends StatefulWidget {
  final String email;

  const EmailVerificationViewBody({super.key, required this.email});

  @override
  State<EmailVerificationViewBody> createState() =>
      _EmailVerificationViewBodyState();
}

class _EmailVerificationViewBodyState extends State<EmailVerificationViewBody> {
  int _countdownSeconds = 60;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    context.read<EmailVerificationCubit>().stopVerificationCheck();
    super.dispose();
  }

  void startCountdown() {
    setState(() {
      _countdownSeconds = 60;
      _isResendEnabled = false;
    });

    // Start countdown timer
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _isResendEnabled = true;
        }
      });

      return _countdownSeconds > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) {
        // Restart countdown when verification email is sent
        if (state is VerificationEmailSent) {
          startCountdown();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed:
                () => Navigator.pushReplacementNamed(
                  context,
                  LoginView.routeName,
                ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Email verification icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: .1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.email_outlined,
                      color: Colors.orange,
                      size: 50,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Title
                const Center(
                  child: Text(
                    'Verify your email',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Center(
                  child: Text(
                    'We sent a verification link to ${widget.email}.\nPlease check your inbox and verify your email.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),

                const SizedBox(height: 40),

                // Refresh button
                CustomButton(
                  onPressed: () {
                    context
                        .read<EmailVerificationCubit>()
                        .checkVerificationStatus();
                  },
                  text: "I've verified my email",
                ),

                const SizedBox(height: 20),

                // Resend email button
                Center(
                  child: Column(
                    children: [
                      // Countdown text
                      _isResendEnabled
                          ? const SizedBox.shrink()
                          : Text(
                            'Resend email in $_countdownSeconds seconds',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                      const SizedBox(height: 8),
                      // Resend button
                      TextButton(
                        onPressed:
                            _isResendEnabled
                                ? () {
                                  context
                                      .read<EmailVerificationCubit>()
                                      .resendVerificationEmail();
                                }
                                : null,
                        child: Text(
                          'Resend verification email',
                          style: TextStyle(
                            color:
                                _isResendEnabled
                                    ? const Color(0xFFF9B56E)
                                    : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Login button
                CustomButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      LoginView.routeName,
                    );
                  },
                  text: 'Back to Login',
                  backgroundColor: Colors.transparent,
                  color: const Color(0xFFF9B56E),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
