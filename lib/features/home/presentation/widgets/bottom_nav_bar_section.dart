// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'build_bottom_navItem.dart';

class BottomNavBarSection extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBarSection({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });
  
  // Define the image paths and labels
  static const List<Map<String, String>> _navItems = [
    {'icon': 'assets/images/png/buttom_nav_bar/baby.png', 'label': 'Home'},
    {'icon': 'assets/images/png/buttom_nav_bar/person.png', 'label': 'Profile'},
    {'icon': 'assets/images/png/buttom_nav_bar/calender.png', 'label': 'Calendar'},
    {'icon': 'assets/images/png/buttom_nav_bar/person.png', 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    // Get the bottom padding to account for the safe area
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      // Add height + bottom padding to account for safe area
      height: 60 + bottomPadding,
      width: double.infinity, // Ensure full width
      decoration: const BoxDecoration(
        color: AppColors.bottomNavColor,
        borderRadius: BorderRadius.zero, // Remove any border radius
      ),
      child: Column(
        children: [
          // This is your actual navigation content
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_navItems.length, (index) {
                return BuildBottomNavItem(
                  iconPath: _navItems[index]['icon']!,
                  label: _navItems[index]['label']!,
                  index: index,
                  selectedIndex: selectedIndex,
                  onTap: onItemTapped,
                );
              }),
            ),
          ),
          // This empty container fills the safe area with your background color
          Container(height: bottomPadding, color: AppColors.bottomNavColor),
        ],
      ),
    );
  }
}
