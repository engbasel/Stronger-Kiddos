import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:strongerkiddos/core/helper/failuer_top_snak_bar.dart';
import 'package:strongerkiddos/core/helper/scccess_top_snak_bar.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_progrss_hud.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/signup_cubit/signup_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/signup_cubit/signup_state.dart';
import 'package:strongerkiddos/features/auth/presentation/views/successfully_verified_view.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  static const routeName = '/otp-verification';

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  // Controllers for each OTP digit
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  // Focus nodes for each OTP field
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // Timer for resend OTP countdown
  Timer? _timer;
  int _countdownSeconds = 30;
  bool _isResendEnabled = false;

  // Store verification ID and phone number
  late String _verificationId;
  late String _phoneNumber;
  late String _userName;

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
      _verificationId = args['verificationId'] ?? '';
      _phoneNumber = args['phoneNumber'] ?? '';
      _userName = args['name'] ?? '';

      log('Verification ID: $_verificationId');
      log('Phone Number: $_phoneNumber');
    } else {
      log('No arguments passed to OTP verification screen');
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

  // Start the countdown timer for resend OTP
  void startCountdown() {
    setState(() {
      _countdownSeconds = 30;
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

  // Handle OTP verification
  void verifyOtp() {
    // Get the complete OTP code
    String otp = _controllers.map((controller) => controller.text).join();

    log('Verifying OTP: $otp');

    if (otp.length == 4) {
      // Get SignupCubit instance and verify OTP
      final signupCubit = context.read<SignupCubit>();
      signupCubit.verifyOTP(
        verificationId: _verificationId,
        smsCode: otp,
        name: _userName,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter all digits')));
    }
  }

  // Handle resend OTP
  void resendOtp() {
    if (_isResendEnabled) {
      log('Resending OTP to $_phoneNumber');

      // Clear the fields
      for (var controller in _controllers) {
        controller.clear();
      }

      // Reset focus to first field
      FocusScope.of(context).requestFocus(_focusNodes[0]);

      // Restart countdown
      startCountdown();

      // Get SignupCubit instance and resend OTP
      final signupCubit = context.read<SignupCubit>();
      signupCubit.verifyPhoneNumber(phoneNumber: _phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is PhoneSignupSuccess) {
          succesTopSnackBar(context, 'Phone verification successful');
          Navigator.pushReplacementNamed(
            context,
            SuccessfullyVerifiedView.routeName,
          );
        } else if (state is PhoneVerificationSent) {
          succesTopSnackBar(context, 'OTP sent successfully');
          _verificationId = state.verificationId;
        } else if (state is SignupFailure) {
          failuerTopSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
          isLoading: state is SignupLoading,
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
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter the verification code we just sent\non your phone number.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    // OTP input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => buildOtpTextField(index),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Verify button
                    CustomButton(onPressed: verifyOtp, text: 'Verify'),

                    const SizedBox(height: 24),

                    // Resend OTP section
                    Center(
                      child: Column(
                        children: [
                          // Countdown text
                          _isResendEnabled
                              ? const SizedBox.shrink()
                              : Text(
                                'Resend OTP in ${_countdownSeconds}s',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                          const SizedBox(height: 8),
                          // Resend button
                          TextButton(
                            onPressed: _isResendEnabled ? resendOtp : null,
                            child: Text(
                              'Resend OTP',
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildOtpTextField(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              _controllers[index].text.isNotEmpty
                  ? const Color(0xFF7c9471)
                  : Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
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
