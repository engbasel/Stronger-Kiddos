import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_name.dart';
import 'package:strongerkiddos/core/widgets/custom_text_form_field.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/views/forget_password_view.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _isEmailSelected = true;
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String selectedCountryCode = '+1';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Handle login
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final loginCubit = context.read<LoginCubit>();

      if (_isEmailSelected) {
        // Email login
        loginCubit.loginWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        // Phone login - redirect to phone signup/verification
        Navigator.pushNamed(
          context,
          PhoneSignupView.routeName,
          arguments: {
            'phoneNumber': '$selectedCountryCode${_phoneController.text}',
          },
        );
      }
    }
  }

  // Handle Google sign in
  void _handleGoogleSignIn() {
    final loginCubit = context.read<LoginCubit>();
    loginCubit.signInWithGoogle();
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

              // Email/Phone Input Field
              _isEmailSelected
                  ? CustomTextFormField(
                    hintText: 'johndoe@email.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!_isValidEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  )
                  : CustomTextFormField(
                    hintText: 'Phone number',
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
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

              // Password Section - Only shown for email login
              if (_isEmailSelected) ...[
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
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
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
                      Navigator.pushNamed(
                        context,
                        ForgetPasswordView.routeName,
                      );
                    },
                    child: const Text(
                      'Forget password?',
                      style: TextStyles.medium15,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              CustomButton(onPressed: _handleLogin, text: 'Login'),
              const SizedBox(height: 32),
              const OrDivider(),
              const SizedBox(height: 32),
              SocialLoginButton(
                backgroundColor: const Color(0xffe4e7eb),
                image: Assets.imagesSvgGoogle,
                title: 'Continue with Google',
                onPressed: _handleGoogleSignIn,
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
