// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';

class BottomNavBarSection extends StatefulWidget {
  const BottomNavBarSection({Key? key}) : super(key: key);

  @override
  State<BottomNavBarSection> createState() => _BottomNavBarSectionState();
}

class _BottomNavBarSectionState extends State<BottomNavBarSection> {
  int _selectedIndex = 0;
  
  // Define the image paths and labels
  final List<Map<String, String>> _navItems = [
    {'icon': 'assets/images/png/buttom_nav_bar/baby.png', 'label': 'Home'},
    {'icon': 'assets/images/png/buttom_nav_bar/person.png', 'label': 'Profile'},
    {'icon': 'assets/images/png/buttom_nav_bar/calender.png', 'label': 'Calendar'},
    {'icon': 'assets/images/png/buttom_nav_bar/person.png', 'label': 'Settings'},
  ];

  Widget buildBottomNavItem(String iconPath, String label, int index) {
    final isSelected = index == _selectedIndex;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3e5e42) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
                  iconPath,
              color: isSelected ? Color(0xFFbad7ac) : Colors.grey,
              width: 24,
              height: 24,
            ),
            // Only show label if selected
            if (isSelected) ...[  
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color:  Color(    0xffbad7ac),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

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
                return buildBottomNavItem(
                  _navItems[index]['icon']!,
                  _navItems[index]['label']!,
                  index,
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
