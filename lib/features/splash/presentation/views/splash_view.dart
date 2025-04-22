import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/onboarding/presentation/views/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static const String routeName = '/splash';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    navigateToOnboarding();
  }

  void navigateToOnboarding() {
    Future.delayed(const Duration(seconds: 6), () {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, Onboardingview.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4ae59),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Image.asset('assets/png/Logo.png')],
      ),
    );
  }
}
