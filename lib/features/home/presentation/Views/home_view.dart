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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthGuard.canActivate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBarSection(),
      body: SafeArea(
        bottom: false,
        child: HomeviewBody(), // خلي الودجت تنزل لآخر الشاشة
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }
}
