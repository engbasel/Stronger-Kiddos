import 'package:flutter/material.dart';
import '../../app_constants.dart';
import '../services/shared_preferences_sengleton.dart';

class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _saveCurrentRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _saveCurrentRoute(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _saveCurrentRoute(previousRoute);
    }
  }

  void _saveCurrentRoute(Route<dynamic> route) {
    // Skip saving the splash route
    if (route.settings.name == null ||
        route.settings.name == '/splash' ||
        route.settings.name!.isEmpty) {
      return;
    }

    // Save the current route name to SharedPreferences
    Prefs.setString(AppConstants.kLastVisitedRoute, route.settings.name!);
  }
}
