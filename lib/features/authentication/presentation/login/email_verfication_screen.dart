import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_cubit.dart';
import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_state.dart';
import 'package:strongerkiddos/features/home/presentation/views/home_view.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  static const routeName = '/email-verification';

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  int _timerSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    // Send verification email when the screen opens
    _sendVerificationEmail();
    // Start timer to check verification status periodically
    _startVerificationCheckTimer();
    // Start timer for resend cooldown
    _startResendCooldownTimer();
  }

  void _sendVerificationEmail() {
    context.read<AuthCubit>().sendEmailVerification();
  }

  void _startVerificationCheckTimer() {
    // Check email verification status every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context.read<AuthCubit>().checkEmailVerification();
    });
  }

  void _startResendCooldownTimer() {
    setState(() {
      _canResend = false;
      _timerSeconds = 60;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // If user is verified, navigate to home
        if (state.user != null && state.user!.isEmailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email verified successfully')),
          );
          Navigator.of(context).pushReplacementNamed(HomeView.routeName);
        }

        // Handle errors
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        final userEmail = state.user?.email ?? 'your email';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Verify Your Email'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 80,
                  color: Color(0xFFF9B356),
                ),
                const SizedBox(height: 24),
                Text(
                  'Verify your email',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'We have sent a verification link to $userEmail',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your email inbox and click the link to verify your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            context.read<AuthCubit>().checkEmailVerification();
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9B356),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'I\'ve verified my email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed:
                      (_canResend && !isLoading)
                          ? () {
                            _sendVerificationEmail();
                            _startResendCooldownTimer();
                          }
                          : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF9B356),
                    minimumSize: const Size(double.infinity, 56),
                    side: const BorderSide(color: Color(0xFFF9B356)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:
                      _canResend
                          ? const Text('Resend verification email')
                          : Text('Resend in $_timerSeconds seconds'),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'I\'ll verify later',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
