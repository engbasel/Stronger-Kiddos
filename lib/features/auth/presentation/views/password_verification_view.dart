import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'dart:async';

import 'package:strongerkiddos/features/auth/presentation/views/reset_password_view.dart';

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

  @override
  void initState() {
    super.initState();
    startCountdown();
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

    // For demo purposes only - would normally call an API
    if (code.length == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing password reset...')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter all digits')));
    }
  }

  // Handle resend code
  void resendCode() {
    if (_isResendEnabled) {
      log('Resending code');

      // Clear the fields
      for (var controller in _controllers) {
        controller.clear();
      }

      // Reset focus to first field
      FocusScope.of(context).requestFocus(_focusNodes[0]);

      // Restart countdown
      startCountdown();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verification code resent')));
    }
  }

  // Navigate to create account screen
  void navigateToCreateAccount() {
    // Example: Navigator.pushNamed(context, CreateAccountView.routeName);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to create account')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Enter your email address to get the\npassword reset link.',
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
                    // ignore: unnecessary_brace_in_string_interps
                    'Resend Code in ${_countdownSeconds} sec',
                    style: TextStyle(
                      color:
                          _isResendEnabled
                              ? const Color(0xFFF9B56E) // Orange when enabled
                              : Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Reset Password button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // onPressed: resetPassword,
                  onPressed: () {
                    Navigator.pushNamed(context, ResetPasswordView.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFF9B56E,
                    ), // Orange button color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Spacer to push "Create an account" to bottom
              const Spacer(),

              // Create Account text
              // Center(
              //   child: GestureDetector(
              //     onTap: navigateToCreateAccount,
              //     child: const Text(
              //       'Create an account',
              //       style: TextStyle(
              //         color: Color(0xFFF9B56E), // Orange color
              //         fontSize: 14,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
              CustomButton(onPressed: () {}, text: 'Create an account'),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
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
