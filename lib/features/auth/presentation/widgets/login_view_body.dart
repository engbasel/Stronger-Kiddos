import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_name.dart';
import 'package:strongerkiddos/core/widgets/custom_text_form_field.dart';
import 'package:strongerkiddos/features/auth/presentation/views/forget_password_view.dart';
import 'package:strongerkiddos/features/home/presentation/Views/home_view.dart';
import '../../../../app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/assets_images.dart';
import '../views/phone_signup_view.dart';
import '../views/signup_view.dart';
import 'or_divider.dart';
import 'social_login_button.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  bool _isEmailSelected = true;
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedCountryCode = '+1';

  @override
  void dispose() {
    _emailController.dispose();
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
              const SizedBox(height: 100),
              const Text('Login', style: TextStyles.semiBold32),
              const SizedBox(height: 8),
              Text(
                'Welcome back to the app',
                style: TextStyles.regular16.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEmailSelected = true;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                _isEmailSelected ? Colors.orange : Colors.grey,
                          ),
                        ),
                        if (_isEmailSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 40,
                            color: Colors.orange,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEmailSelected = false;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                !_isEmailSelected ? Colors.orange : Colors.grey,
                          ),
                        ),
                        if (!_isEmailSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 40,
                            color: Colors.orange,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomName(
                text: _isEmailSelected ? 'Email Address' : 'Phone Number',
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText:
                    _isEmailSelected ? 'johndoe@email.com' : 'Phone number',
                controller: _emailController,
                keyboardType:
                    _isEmailSelected
                        ? TextInputType.emailAddress
                        : TextInputType.number,
                prefixIcon:
                    !_isEmailSelected
                        ? CountryCodePicker(
                          onChanged: (countryCode) {
                            setState(() {
                              selectedCountryCode =
                                  countryCode.dialCode ?? '+1';
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
                        )
                        : null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ${_isEmailSelected ? 'email' : 'phone number'}';
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
                obobscureText:
                    !_isPasswordVisible, // Fixed typo: obobscureText -> obscureText
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ForgetPasswordView.routeName);
                  },
                  child: const Text(
                    'Forget password?',
                    style: TextStyles.medium15,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeView.routeName);
                },
                text: 'Login',
              ),
              const SizedBox(height: 32),
              OrDivider(),
              const SizedBox(height: 32),
              SocialLoginButton(
                backgroundColor: Color(0xffe4e7eb),
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
                child: GestureDetector(
                  onTap: () {
                    // Navigate based on the selected tab
                    if (_isEmailSelected) {
                      Navigator.pushNamed(context, SignupView.routeName);
                    } else {
                      Navigator.pushNamed(context, PhoneSignupView.routeName);
                    }
                  },
                  child: Text(
                    'Create an account',
                    style: TextStyles.medium15.copyWith(
                      color: AppColors.fabBackgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
