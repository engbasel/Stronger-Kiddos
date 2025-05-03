import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/home/presentation/Views/home_view.dart';
import '../../features/auth/persentation/views/login_view.dart';
import '../../features/auth/persentation/views/phone_signup_view.dart';
import '../../features/auth/persentation/views/signup_view.dart';
import '../../features/onbording/presentation/views/on_boarding_view.dart';
import '../../features/spalsh/presentation/views/splash_view.dart';
import '../utils/page_rout_builder.dart';

Route<dynamic> onGenerateRoute(RouteSettings setting) {
  switch (setting.name) {
    case SplashView.routeName:
      return buildPageRoute(const SplashView());
    case OnBoardingView.routeName:
      return buildPageRoute(const OnBoardingView());
    case LoginView.routeName:
      return buildPageRoute(const LoginView());
    case SignupView.routeName:
      return buildPageRoute(const SignupView());
    case PhoneSignupView.routeName:
      return buildPageRoute(const PhoneSignupView());
    case HomeView.routeName:
      return buildPageRoute(const HomeView());
    default:
      return buildPageRoute(const SplashView());
  }
}
