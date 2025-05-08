import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_name.dart';
import 'package:strongerkiddos/core/widgets/custom_text_form_field.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/signup_cubit/signup_cubit.dart';

import '../../../../app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/assets_images.dart';
import '../../../../core/utils/form_validation.dart';
import '../views/login_view.dart';
import 'or_divider.dart';
import 'social_login_button.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedCountryCode = '+1';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle sign up
  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      final signupCubit = context.read<SignupCubit>();

      signupCubit.signupWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );
    }
  }

  // Handle Google sign up
  void _handleGoogleSignUp() {
    final signupCubit = context.read<SignupCubit>();
    signupCubit.signupWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kHorizintalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              const Text('Create an account', style: TextStyles.semiBold32),
              const SizedBox(height: 24),

              // Name field
              const CustomName(text: 'Name'),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText: 'John Doe',
                controller: _nameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  return FormValidation.validateName(value);
                },
              ),

              const SizedBox(height: 16),

              // Email field
              const CustomName(text: 'Email Address'),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText: 'johndoe@email.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return FormValidation.validateEmail(value);
                },
              ),

              const SizedBox(height: 16),

              // Phone field
              const CustomName(text: 'Phone Number'),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: CountryCodePicker(
                  onChanged: (countryCode) {
                    setState(() {
                      selectedCountryCode = countryCode.dialCode ?? '+1';
                    });
                  },
                  initialSelection: 'US',
                  favorite: const ['+1', 'US'],
                  showCountryOnly: false,
                  showFlag: true,
                  showFlagDialog: true,
                  alignLeft: false,
                  textStyle: const TextStyle(color: Colors.black),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                validator: (value) {
                  return FormValidation.validatePhone(value);
                },
              ),

              const SizedBox(height: 16),

              // Password field
              const CustomName(text: 'Password'),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText: '••••••••',
                controller: _passwordController,
                obobscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                validator: (value) {
                  return FormValidation.validatePassword(value);
                },
                keyboardType: TextInputType.visiblePassword,
              ),

              const SizedBox(height: 16),

              // Terms of service
              RichText(
                text: TextSpan(
                  text: 'By continuing, you agree to our ',
                  style: TextStyles.regular13.copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'terms of service.',
                      style: TextStyles.regular13.copyWith(
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Signup button
              CustomButton(onPressed: _handleSignup, text: 'Sign Up'),

              const SizedBox(height: 32),
              const OrDivider(),
              const SizedBox(height: 32),

              // Social login buttons
              SocialLoginButton(
                backgroundColor: const Color(0xffe4e7eb),
                image: Assets.imagesSvgGoogle,
                title: 'Continue with Google',
                onPressed: _handleGoogleSignUp,
              ),

              const SizedBox(height: 28),

              SocialLoginButton(
                backgroundColor: Colors.black,
                color: Colors.white,
                image: Assets.imagesSvgApple,
                title: 'Continue with Apple',
                onPressed: () {
                  // Apple sign in would be implemented here
                },
              ),

              const SizedBox(height: 24),

              // Login link
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      LoginView.routeName,
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyles.regular13.copyWith(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyles.medium15.copyWith(
                            color: AppColors.fabBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
