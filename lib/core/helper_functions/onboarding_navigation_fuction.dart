// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/login_view.dart';
import 'package:strongerkiddos/features/onboarding/presentation/views/onboarding_view.dart';

class OnboardingNavigationFunction {
  static const String _onboardingSeenKey = 'onboarding_seen';

  // Call this in main() or splash to decide where to go
  static Future<void> handleStartupNavigation(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool(_onboardingSeenKey) ?? false;

    if (seenOnboarding) {
      // User already saw onboarding, navigate to Home/Loginw
      Navigator.pushReplacementNamed(context, Loginview.routeName);
    } else {
      // First time opening app, show onboarding
      Navigator.pushReplacementNamed(context, Onboardingview.routeName);
    }
  }

  // Call this when onboarding is complete
  static Future<void> completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);

    Navigator.pushReplacementNamed(context, '/home');
  }

  // For testing or reset purposes (optional)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingSeenKey);
  }
}
