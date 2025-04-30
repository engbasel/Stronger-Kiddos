import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_cubit.dart';
import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_state.dart';
import 'package:strongerkiddos/features/home/presentation/views/home_view.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  static const routeName = '/otp-verification';

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6, // Changed from 4 to 6 for standard OTP length
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6, // Changed from 4 to 6
    (index) => FocusNode(),
  );

  int _timerSeconds = 60; // Changed from 23 to 60 seconds
  late Timer _timer;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    // Start phone verification when screen loads
    _startPhoneVerification();
    _startTimer();

    // Set up focus node listeners to move to next field
    for (int i = 0; i < 5; i++) {
      // Changed to < 5 for 6 fields
      _otpFocusNodes[i].addListener(() {
        if (_otpControllers[i].text.isNotEmpty && _otpFocusNodes[i].hasFocus) {
          _otpFocusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  void _startPhoneVerification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call verifyPhoneNumber in auth cubit
      context.read<AuthCubit>().verifyPhoneNumber(widget.phoneNumber);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void _resendOtp() {
    if (_timerSeconds > 0 || _isResending) return;

    setState(() {
      _isResending = true;
    });

    // Clear OTP fields
    for (var controller in _otpControllers) {
      controller.clear();
    }

    // Request new OTP
    context.read<AuthCubit>().verifyPhoneNumber(widget.phoneNumber);

    setState(() {
      _timerSeconds = 60;
      _isResending = false;
    });
    _startTimer();

    _otpFocusNodes[0].requestFocus();
  }

  void _verifyOtp() {
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != 6) {
      // Changed from 4 to 6
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit verification code'),
        ),
      );
      return;
    }

    // Use auth cubit to verify OTP
    context.read<AuthCubit>().verifyOTP(otp);
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Verification failed'),
            ),
          );
        } else if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed(HomeView.routeName);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the verification code we just sent to ${widget.phoneNumber}.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6, // Changed from 4 to 6
                      (index) => SizedBox(
                        width: 48, // Made narrower for 6 digits
                        height: 56,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          enabled:
                              !isLoading &&
                              state.status != AuthStatus.authenticated,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFFF9B356),
                                width: 2,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isEmpty && index > 0) {
                              _otpFocusNodes[index - 1].requestFocus();
                            } else if (value.isNotEmpty && index < 5) {
                              // Changed to < 5
                              _otpFocusNodes[index + 1].requestFocus();
                            } else if (value.isNotEmpty && index == 5) {
                              // Auto-verify when last digit entered
                              _verifyOtp();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLoading || state.status == AuthStatus.authenticated
                              ? null
                              : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9B356),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Verify',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Resend OTP in ${_timerSeconds}s',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed:
                              (_timerSeconds > 0 ||
                                      isLoading ||
                                      state.status == AuthStatus.authenticated)
                                  ? null
                                  : _resendOtp,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              color:
                                  (_timerSeconds > 0 ||
                                          isLoading ||
                                          state.status ==
                                              AuthStatus.authenticated)
                                      ? Colors.grey
                                      : const Color(0xFFF9B356),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (_isResending)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFF9B356),
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
        );
      },
    );
  }
}
