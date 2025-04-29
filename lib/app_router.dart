// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/authentication/presentation/signup/create_account_view.dart';
import 'package:strongerkiddos/features/authentication/presentation/signup/create_account_widget.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/forgot_password_view.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/login_view.dart';
import 'package:strongerkiddos/features/home/presentation/views/home_view.dart';
import 'package:strongerkiddos/features/onboarding/presentation/views/OnboardingQuestionsView.dart';
import 'package:strongerkiddos/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:strongerkiddos/features/splash/presentation/views/splash_view.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Onboardingview.routeName:
        return MaterialPageRoute(builder: (_) => const Onboardingview());
      case SplashView.routeName:
        return MaterialPageRoute(builder: (_) => const Onboardingview());
      case Loginview.routeName:
        return MaterialPageRoute(builder: (_) => const Loginview());
      case HomeView.routeName:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case ForgetPasswordScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case ResetPasswordScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case CreateAccountScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CreateAccountScreen());
      case OnboardingQuestionScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const OnboardingQuestionScreen(),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
