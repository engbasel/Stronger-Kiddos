import 'package:flutter/material.dart';

import '../../features/spalsh/presentation/views/splash_view.dart';
import '../utils/page_rout_builder.dart';

Route<dynamic> onGenerateRoute(RouteSettings setting) {
  switch (setting.name) {
    case '/splash':
      return buildPageRoute(const SplashView());
    default:
      return buildPageRoute(const SplashView());
  }
}
