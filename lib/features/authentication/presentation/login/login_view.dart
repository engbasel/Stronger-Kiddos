import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_apple_button.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_create_account.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_divider.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/email_form_widget.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_forgot_password.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_google_button.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_password_field.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/phone_form_widget.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/tab_selector_widget.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/login_with_phone_and_otp_view.dart';

import '../manager/cubit/auth_cubit.dart';
import '../manager/cubit/auth_state.dart';

// Login tab options
enum LoginTabOption { email, phone }

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  static const routeName = 'login';

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  LoginTabOption _selectedTab = LoginTabOption.email;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String selectedCountryCode = '+1';

  // Add page controller for swipe functionality
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTab.index);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Change tab and update page controller
  void changeTab(LoginTabOption tab) {
    setState(() {
      _selectedTab = tab;
      _pageController.animateToPage(
        tab.index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _handleLogin() {
    if (_selectedTab == LoginTabOption.email) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
        return;
      }

      context.read<AuthCubit>().signInWithEmailAndPassword(email, password);
    } else {
      // Navigate to the phone OTP login screen
      final phone = _phoneController.text.trim();

      if (phone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your phone number')),
        );
        return;
      }

      // Navigate to the phone login screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreenWithPhoneAndOtp(),
        ),
      );
    }
  }

  void _onCountryCodeChanged(value) {
    setState(() {
      selectedCountryCode = value.dialCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome back to the app',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Tab selector
                TabSelector(
                  selectedTab: _selectedTab,
                  tabs: [
                    TabOption(label: 'Email', value: LoginTabOption.email),
                    TabOption(
                      label: 'Phone Number',
                      value: LoginTabOption.phone,
                    ),
                  ],
                  onTabSelected: (tab) {
                    changeTab(tab);
                  },
                ),
                const SizedBox(height: 20),

                // Swipeable content area
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const PageScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _selectedTab = LoginTabOption.values[index];
                      });
                    },
                    children: [
                      // Email login form
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: _emailController,
                              label: 'Email',
                              hintText: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                            ),
                            const SizedBox(height: 16),

                            PasswordField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              onToggleVisibility: (isVisible) {
                                setState(() {
                                  _obscureText = isVisible;
                                });
                              },
                            ),
                            buildForgotPassword(context),
                            const SizedBox(height: 10),

                            // Updated login button with BlocBuilder
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final isLoading =
                                    state.status == AuthStatus.loading;

                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF9B356),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
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
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),
                            buildDivider(),
                            const SizedBox(height: 15),

                            // Google login button
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap:
                                      state.status == AuthStatus.loading
                                          ? null
                                          : () =>
                                              context
                                                  .read<AuthCubit>()
                                                  .signInWithGoogle(),
                                  child: buildGoogleButton(),
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            // Apple login button
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap:
                                      state.status == AuthStatus.loading
                                          ? null
                                          : () =>
                                              context
                                                  .read<AuthCubit>()
                                                  .signInWithApple(),
                                  child: buildAppleButton(),
                                );
                              },
                            ),

                            const SizedBox(height: 20),
                            buildCreateAccount(context),
                          ],
                        ),
                      ),

                      // Phone login form
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PhoneNumberField(
                              onCountryCodeChanged: _onCountryCodeChanged,
                              phoneController: _phoneController,
                            ),
                            const SizedBox(height: 16),
                            // Phone number login doesn't need password - we'll use OTP instead
                            const SizedBox(height: 10),

                            // Updated login button for phone tab (Go to OTP screen)
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final isLoading =
                                    state.status == AuthStatus.loading;

                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF9B356),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
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
                                              'Continue with Phone',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),
                            buildDivider(),
                            const SizedBox(height: 15),

                            // Google login button
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap:
                                      state.status == AuthStatus.loading
                                          ? null
                                          : () =>
                                              context
                                                  .read<AuthCubit>()
                                                  .signInWithGoogle(),
                                  child: buildGoogleButton(),
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            // Apple login button
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap:
                                      state.status == AuthStatus.loading
                                          ? null
                                          : () =>
                                              context
                                                  .read<AuthCubit>()
                                                  .signInWithApple(),
                                  child: buildAppleButton(),
                                );
                              },
                            ),

                            const SizedBox(height: 20),
                            buildCreateAccount(context),
                          ],
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
  }
}
