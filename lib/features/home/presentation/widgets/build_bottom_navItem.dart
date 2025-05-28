import 'package:flutter/material.dart';

class BuildBottomNavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const BuildBottomNavItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    // Using the original colors from the code sample
    final selectedBgColor = const Color(0xFF3e5e42);
    final selectedTextColor = const Color(0xFFbad7ac);
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              color: isSelected ? selectedTextColor : Colors.grey,
              width: 24,
              height: 24,
            ),
            // Only show label if selected
            if (isSelected) ...[  
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selectedTextColor,
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
}