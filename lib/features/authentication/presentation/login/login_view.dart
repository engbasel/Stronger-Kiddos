import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildAppleButton.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildCreateAccount.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildDivider.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildEmailForm.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildForgotPassword.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildGoogleButton.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildLoginButton.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildPhoneForm.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildTabOptions.dart';

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
  void _changeTab(LoginTabOption tab) {
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

              // buildTabOptions(),
              TabSelector(
                selectedTab: _selectedTab,
                tabs: [
                  TabOption(label: 'Email', value: LoginTabOption.email),
                  TabOption(label: 'Phone Number', value: LoginTabOption.phone),
                ],
                onTabSelected: (tab) {
                  setState(() {
                    _selectedTab = tab;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Swipeable content area
              Expanded(
                child: PageView(
                  controller: _pageController,
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
                          buildPasswordField(),
                          buildForgotPassword(),
                          const SizedBox(height: 10),
                          buildLoginButton(),
                          const SizedBox(height: 15),
                          buildDivider(),
                          const SizedBox(height: 15),
                          buildGoogleButton(),
                          const SizedBox(height: 10),
                          buildAppleButton(),
                          const SizedBox(height: 20),
                          buildCreateAccount(),
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
                          buildPasswordField(),
                          buildForgotPassword(),
                          const SizedBox(height: 10),
                          buildLoginButton(),
                          const SizedBox(height: 15),
                          buildDivider(),
                          const SizedBox(height: 15),
                          buildGoogleButton(),
                          const SizedBox(height: 10),
                          buildAppleButton(),
                          const SizedBox(height: 20),
                          buildCreateAccount(),
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

  Widget buildPasswordField() {
    final FocusNode _focusNode = FocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscureText,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '••••••••••••',
            hintStyle: TextStyle(color: Colors.grey.shade400),
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
              borderSide: const BorderSide(color: Color(0xFF4B5768)),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
