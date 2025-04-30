// lib/core/helper_functions/onboarding_navigation_function.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/login_view.dart';
import 'package:strongerkiddos/features/onboarding/presentation/views/onboarding_view.dart';

import '../../features/authentication/presentation/manager/cubit/auth_cubit.dart';

class OnboardingNavigationFunction {
  static const String _onboardingSeenKey = 'onboarding_seen';

  // Call this in main() or splash to decide where to go
  static Future<void> handleStartupNavigation(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool(_onboardingSeenKey) ?? false;

    // Let the AuthCubit handle authentication status
    if (!context.mounted) return;
    context.read<AuthCubit>().checkAuth();

    if (seenOnboarding) {
      // User already saw onboarding, navigate to Login
      // The AuthCubit will redirect to Home if already authenticated
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

    // Navigate to login after onboarding
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, Loginview.routeName);
  }

  // For testing or reset purposes (optional)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingSeenKey);
  }
}
