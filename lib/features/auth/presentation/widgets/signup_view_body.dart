import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_name.dart';
import 'package:strongerkiddos/core/widgets/custom_text_form_field.dart';

import '../../../../app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/assets_images.dart';
import 'or_divider.dart';
import 'social_login_button.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
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

  @override
  Widget build(BuildContext context) {
    return Form(
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
              CustomName(text: 'Name'),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText: 'John Doe',
                controller: _nameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomName(text: 'Email Address'),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText: 'johndoe@email.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomName(text: 'Phone Number'),
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomName(text: 'Password'),
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 16),
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
              CustomButton(onPressed: () {}, text: 'Sign Up'),
              const SizedBox(height: 32),
              OrDivider(),
              const SizedBox(height: 32),
              SocialLoginButton(
                backgroundColor: const Color(0xffe4e7eb),
                image: Assets.imagesSvgGoogle,
                title: 'Continue with Google',
                onPressed: () {},
              ),
              const SizedBox(height: 28),
              SocialLoginButton(
                backgroundColor: Colors.black,
                color: Colors.white,
                image: Assets.imagesSvgApple,
                title: 'Continue with Apple',
                onPressed: () {},
              ),
              const SizedBox(height: 24),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
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
