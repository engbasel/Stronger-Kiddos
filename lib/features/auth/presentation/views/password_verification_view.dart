import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:strongerkiddos/core/helper/failuer_top_snak_bar.dart';
import 'package:strongerkiddos/core/helper/scccess_top_snak_bar.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_progrss_hud.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/login_cubit/login_state.dart';
import 'package:strongerkiddos/features/auth/presentation/views/reset_password_view.dart';
import 'package:strongerkiddos/features/auth/presentation/views/signup_view.dart';

class PasswordVerificationView extends StatefulWidget {
  const PasswordVerificationView({super.key});
  static const routeName = '/password-verification';

  @override
  State<PasswordVerificationView> createState() =>
      _PasswordVerificationViewState();
}

class _PasswordVerificationViewState extends State<PasswordVerificationView> {
  // Controllers for each digit
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  // Focus nodes for each field
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // Timer for resend code countdown
  Timer? _timer;
  int _countdownSeconds = 60;
  bool _isResendEnabled = false;

  // Store email for password reset
  late String _email;

  @override
  void initState() {
    super.initState();
    startCountdown();
    // Delay to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getRouteArguments();
    });
  }

  void _getRouteArguments() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _email = args['email'] ?? '';
      log('Email for password reset: $_email');
    } else {
      log('No arguments passed to password verification screen');
    }
  }

  @override
  void dispose() {
    // Dispose all controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  // Start the countdown timer for resend code
  void startCountdown() {
    setState(() {
      _countdownSeconds = 60;
      _isResendEnabled = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _timer?.cancel();
          _isResendEnabled = true;
        }
      });
    });
  }

  // Handle code verification and password reset
  void resetPassword() {
    // Get the complete code
    String code = _controllers.map((controller) => controller.text).join();

    log('Verifying code: $code');

    // For demo purposes only - would normally validate the code
    if (code.length == 4) {
      // Navigate to reset password screen
      Navigator.pushNamed(
        context,
        ResetPasswordView.routeName,
        arguments: {'email': _email, 'resetCode': code},
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter all digits')));
    }
  }

  // Handle resend code
  void resendCode() {
    if (_isResendEnabled && _email.isNotEmpty) {
      log('Resending code to $_email');

      // Clear the fields
      for (var controller in _controllers) {
        controller.clear();
      }

      // Reset focus to first field
      FocusScope.of(context).requestFocus(_focusNodes[0]);

      // Restart countdown
      startCountdown();

      // Get LoginCubit instance and resend password reset link
      final loginCubit = context.read<LoginCubit>();
      loginCubit.sendPasswordResetLink(email: _email);
    } else {
      failuerTopSnackBar(
        context,
        'Email address is missing, please go back and try again',
      );
    }
  }

  // Navigate to create account screen
  void navigateToCreateAccount() {
    Navigator.pushReplacementNamed(context, SignupView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is PasswordResetEmailSent) {
          succesTopSnackBar(context, 'Password reset email sent successfully');
        } else if (state is LoginFailure) {
          failuerTopSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
          isLoading: state is LoginLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Title
                    const Text(
                      'Enter your 4-digit code',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    const Text(
                      'Enter the code we sent to your email to reset your password',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    // Code input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => _buildDigitTextField(index),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Resend code text with timer
                    Center(
                      child: GestureDetector(
                        onTap: _isResendEnabled ? resendCode : null,
                        child: Text(
                          'Resend Code in $_countdownSeconds sec',
                          style: TextStyle(
                            color:
                                _isResendEnabled
                                    ? const Color(
                                      0xFFF9B56E,
                                    ) // Orange when enabled
                                    : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Reset Password button
                    CustomButton(
                      onPressed: resetPassword,
                      text: 'Reset Password',
                    ),
                    // Spacer to push "Create an account" to bottom
                    const Spacer(),
                    // Create an account button
                    CustomButton(
                      onPressed: navigateToCreateAccount,
                      text: 'Create an account',
                    ),
                    const SizedBox(height: 20), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDigitTextField(int index) {
    return Container(
      width: 70,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              _controllers[index].text.isNotEmpty
                  ? const Color(0xFFF9B56E) // Orange border when filled
                  : Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          // Auto-focus to next field
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
        },
      ),
    );
  }
}
