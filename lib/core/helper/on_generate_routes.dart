import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/auth/presentation/views/forget_password_view.dart';
import 'package:strongerkiddos/features/auth/presentation/views/otp_vericifaction.dart';
import 'package:strongerkiddos/features/auth/presentation/views/password_verification_view.dart';
import 'package:strongerkiddos/features/auth/presentation/views/reset_password_view.dart';
import 'package:strongerkiddos/features/auth/presentation/views/successfully_verified_view.dart';
import 'package:strongerkiddos/features/home/presentation/Views/home_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/phone_signup_view.dart';
import '../../features/auth/presentation/views/signup_view.dart';
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
    case OtpVerificationView.routeName:
      return buildPageRoute(const OtpVerificationView());
    case ForgetPasswordView.routeName:
      return buildPageRoute(const ForgetPasswordView());
    case PasswordVerificationView.routeName:
      return buildPageRoute(const PasswordVerificationView());
    case ResetPasswordView.routeName:
      return buildPageRoute(const ResetPasswordView());
    case SuccessfullyVerifiedView.routeName:
      return buildPageRoute(const SuccessfullyVerifiedView());
    default:
      return buildPageRoute(const SplashView());
  }
}
