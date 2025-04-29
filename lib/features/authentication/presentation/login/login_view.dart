import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildEmailForm.dart';
import 'package:strongerkiddos/features/authentication/presentation/widgets/buildPhoneForm.dart';

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
              buildTabOptions(),
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

  Widget buildTabOptions() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _changeTab(LoginTabOption.email),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        _selectedTab == LoginTabOption.email
                            ? Colors.orange
                            : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Divider(
                  color:
                      _selectedTab == LoginTabOption.email
                          ? Colors.orange
                          : Colors.grey.withOpacity(0.3),
                  thickness: 2,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => _changeTab(LoginTabOption.phone),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        _selectedTab == LoginTabOption.phone
                            ? Colors.orange
                            : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Divider(
                  color:
                      _selectedTab == LoginTabOption.phone
                          ? Colors.orange
                          : Colors.grey.withOpacity(0.3),
                  thickness: 2,
                ),
              ],
            ),
          ),
        ),
      ],
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

  Widget buildForgotPassword() {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot password?',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF9B356),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'or sign in with',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        icon: Image.asset(
          'assets/png/Google.png',
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget buildAppleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.apple, size: 24),
        label: const Text(
          'Continue with Apple',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget buildCreateAccount() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Create an account',
          style: TextStyle(
            color: Color(0xFFF9B356),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
