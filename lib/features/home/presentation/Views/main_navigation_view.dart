import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/features/calendar/presentation/views/calendar_view.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/home_view_body.dart';
import 'package:strongerkiddos/features/profile/presentation/views/profile_view.dart';
import 'package:strongerkiddos/features/settings/presentation/views/settings_view.dart';
import '../widgets/bottom_nav_bar_section.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  static const String routeName = '/mainnavigation';

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _selectedIndex = 0;
  
  // List of screens to display
  final List<Widget> _screens = const [
    HomeviewBody(),
    ProfileView(),
    CalendarView(),
    SettingsView(),
  ];

  // Method to handle item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBarSection(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: SafeArea(
        bottom: false, 
        child: _screens[_selectedIndex],
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }
}
