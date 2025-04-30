import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/otp_verification_screen.dart';
import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_cubit.dart';
import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_state.dart';

class LoginScreenWithPhoneAndOtp extends StatefulWidget {
  const LoginScreenWithPhoneAndOtp({super.key});

  static const routeName = '/login-phone';

  @override
  State<LoginScreenWithPhoneAndOtp> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenWithPhoneAndOtp> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+1';
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    setState(() {
      // Basic validation - at least 10 digits
      _isValid = _phoneController.text.trim().length >= 10;
    });
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhone);
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    final fullPhoneNumber = _selectedCountryCode + _phoneController.text.trim();

    // Navigate to OTP screen - it will handle verification
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => OtpVerificationScreen(phoneNumber: fullPhoneNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        }
      },
      child: Scaffold(
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
                  'Login with Phone',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We\'ll send a verification code to your phone',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: CountryCodePicker(
                          onChanged: (CountryCode countryCode) {
                            setState(() {
                              _selectedCountryCode = countryCode.dialCode!;
                            });
                          },
                          initialSelection: 'US',
                          favorite: const [
                            'US',
                            'CA',
                            'GB',
                            'EG',
                          ], // Added Egypt
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: true,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Phone number',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.status == AuthStatus.loading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF9B356),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: const Color(
                            0xFFF9B356,
                          ).withValues(alpha: .5),
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
                                  'Get OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 50,
                      color: Colors.grey.shade300,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or sign in with',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: 50,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Login with email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // These elements complete the UI at the bottom
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to create account screen
                      Navigator.pushNamed(context, '/create-account');
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: Color(0xFFF9B356),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
