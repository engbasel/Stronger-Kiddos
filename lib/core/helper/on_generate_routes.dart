import 'package:flutter/material.dart';

import '../../features/onbording/presentation/views/on_boarding_view.dart';
import '../../features/spalsh/presentation/views/splash_view.dart';
import '../utils/page_rout_builder.dart';

Route<dynamic> onGenerateRoute(RouteSettings setting) {
  switch (setting.name) {
    case SplashView.routeName:
      return buildPageRoute(const SplashView());
    case OnBoardingView.routeName:
      return buildPageRoute(const OnBoardingView());
    default:
      return buildPageRoute(const SplashView());
  }
}
