// lib/features/home/presentation/Views/home_view.dart
import 'package:flutter/material.dart';
import '../../../../core/services/auth_guard.dart';
import 'main_navigation_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();

  static const String routeName = '/homeview';
}

class _HomeViewState extends State<HomeView> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRedirect();
    });
  }

  Future<void> _checkAndRedirect() async {
    if (_isInitialized) return;

    final canActivate = await AuthGuard.canActivate(context);
    if (canActivate) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Navigate to the main navigation view which handles the bottom navigation
    return const MainNavigationView();
  }
}