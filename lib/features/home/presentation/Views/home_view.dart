// lib/features/home/presentation/Views/home_view.dart
import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/home_view_body.dart';
import '../../../../core/services/auth_guard.dart';
import '../widgets/bottom_nav_bar_section.dart';

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

    return Scaffold(
      bottomNavigationBar: BottomNavBarSection(),
      body: SafeArea(bottom: false, child: HomeviewBody()),
      backgroundColor: AppColors.backgroundColor,
    );
  }
}
