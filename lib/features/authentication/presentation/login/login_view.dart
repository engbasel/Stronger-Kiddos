import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_apple_button.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_create_account.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_divider.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/email_form_widget.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_forgot_password.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_google_button.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_login_button.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/build_password_field.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/phone_form_widget.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/tab_selector_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              // Fix: Use the changeTab function when tabs are selected
              TabSelector(
                selectedTab: _selectedTab,
                tabs: [
                  TabOption(label: 'Email', value: LoginTabOption.email),
                  TabOption(label: 'Phone Number', value: LoginTabOption.phone),
                ],
                onTabSelected: (tab) {
                  changeTab(
                    tab,
                  ); // Use the changeTab function to ensure both tab and page change
                },
              ),
              const SizedBox(height: 20),

              // Swipeable content area
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics:
                      const PageScrollPhysics(), // Enable smooth physics for swiping
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

                          // buildPasswordField(),
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
                          buildLoginButton(context),
                          const SizedBox(height: 15),
                          buildDivider(),
                          const SizedBox(height: 15),
                          buildGoogleButton(),
                          const SizedBox(height: 10),
                          buildAppleButton(),
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
                            onCountryCodeChanged: (value) {
                              setState(() {});
                            },
                            phoneController: _phoneController,
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
                          buildLoginButton(context),
                          const SizedBox(height: 15),
                          buildDivider(),
                          const SizedBox(height: 15),
                          buildGoogleButton(),
                          const SizedBox(height: 10),
                          buildAppleButton(),
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
    );
  }
}
