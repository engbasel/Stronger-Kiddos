import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/core/helper/failuer_top_snak_bar.dart';
import 'package:strongerkiddos/core/helper/scccess_top_snak_bar.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_progrss_hud.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/login_cubit/login_state.dart';
import 'package:strongerkiddos/features/auth/presentation/views/login_view.dart';
import 'package:strongerkiddos/features/auth/presentation/views/signup_view.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});
  static const routeName = '/reset-password';

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late String email;
  late String resetCode;

  @override
  void initState() {
    super.initState();
    // Delay to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getRouteArguments();
    });
  }

  void _getRouteArguments() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      email = args['email'] ?? '';
      resetCode = args['resetCode'] ?? '';
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Toggle confirm password visibility
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  // Handle password reset confirmation
  void confirmPasswordReset() {
    if (_formKey.currentState!.validate()) {
      // In a real implementation, you would call an API to reset the password
      // using the reset code and new password

      // For now, just simulate success
      succesTopSnackBar(context, 'Password has been reset successfully');

      // Navigate to login screen
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, LoginView.routeName);
      });
    }
  }

  // Navigate to create account screen
  void _navigateToCreateAccount() {
    Navigator.pushReplacementNamed(context, SignupView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Title
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description
                      const Text(
                        'Your passcode has been validated. Enter a new password.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      // New Password Label
                      const Text(
                        'Enter new password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // New Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFF9B56E),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Confirm Password Label
                      const Text(
                        'Confirm new password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm new password',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFF9B56E),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: _toggleConfirmPasswordVisibility,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      CustomButton(
                        onPressed: confirmPasswordReset,
                        text: 'Confirm',
                      ),
                      // Spacer to push "Create an account" to bottom
                      const Spacer(),
                      // Create Account Text
                      Center(
                        child: GestureDetector(
                          onTap: _navigateToCreateAccount,
                          child: const Text(
                            'Create an account',
                            style: TextStyle(
                              color: Color(0xFFF9B56E), // Orange color
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
