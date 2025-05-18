import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/core/helper/failuer_top_snak_bar.dart';
import 'package:strongerkiddos/core/helper/scccess_top_snak_bar.dart';
import 'package:strongerkiddos/core/services/get_it_service.dart';
import 'package:strongerkiddos/core/utils/form_validation.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_name.dart';
import 'package:strongerkiddos/core/widgets/custom_progrss_hud.dart';
import 'package:strongerkiddos/core/widgets/custom_text_form_field.dart';
import 'package:strongerkiddos/features/auth/domain/repos/auth_repo.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/login_cubit/login_state.dart';
import 'package:strongerkiddos/features/auth/presentation/views/signup_view.dart';

// Make this a StatelessWidget that provides its own LoginCubit
class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});
  static const routeName = '/forget-password';

  @override
  Widget build(BuildContext context) {
    // Provide a LoginCubit for this screen
    return BlocProvider(
      create: (context) => LoginCubit(getIt<AuthRepo>()),
      child: _ForgetPasswordViewContent(),
    );
  }
}

// Move the stateful logic to a private widget
class _ForgetPasswordViewContent extends StatefulWidget {
  @override
  State<_ForgetPasswordViewContent> createState() =>
      _ForgetPasswordViewContentState();
}

class _ForgetPasswordViewContentState
    extends State<_ForgetPasswordViewContent> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Handle sending password reset code
  void sendResetCode() {
    if (_formKey.currentState!.validate()) {
      // Get the email
      final email = _emailController.text.trim();

      // Call the cubit method to send password reset link
      final loginCubit = context.read<LoginCubit>();
      loginCubit.sendPasswordResetLink(email: email);
    }
  }

  // Navigate to registration/signup page
  void _navigateToSignup() {
    Navigator.pushReplacementNamed(context, SignupView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is PasswordResetEmailSent) {
          // Show success message
          succesTopSnackBar(
            context,
            'A password reset link has been sent to your email. '
            'Please check your inbox and follow the link to reset your password.',
          );

          // Optional: Navigate back to login after a delay
          Future.delayed(const Duration(seconds: 3), () {
            if (!context.mounted) return;
            Navigator.pop(context); // Go back to login
          });
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Title
                      const Text(
                        'Forget Password?',
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
                      // Email Label
                      const CustomName(text: 'Email Address'),
                      const SizedBox(height: 8),
                      // Email Input Field
                      CustomTextFormField(
                        hintText: 'johndoe@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return FormValidation.validateEmail(value);
                        },
                      ),
                      const SizedBox(height: 32),
                      // Send Code Button
                      CustomButton(onPressed: sendResetCode, text: 'Send Code'),
                      // Spacer to push "Create an account" to bottom
                      const Spacer(),
                      // Create Account Text Button
                      Center(
                        child: TextButton(
                          onPressed: _navigateToSignup,
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
