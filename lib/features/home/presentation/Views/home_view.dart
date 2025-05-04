import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/bottom_nav_bar_section.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();

  static const String routeName = '/homeview';
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBarSection(),
      body: SafeArea(
        child: HomeviewBody(),
        bottom: false, // خلي الودجت تنزل لآخر الشاشة
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }
}
