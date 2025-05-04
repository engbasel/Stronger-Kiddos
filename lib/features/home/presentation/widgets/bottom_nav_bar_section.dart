// Bottom Navigation Bar Section
import 'package:flutter/material.dart';

class BottomNavBarSection extends StatelessWidget {
  const BottomNavBarSection({Key? key}) : super(key: key);

  Widget _buildBottomNavItem(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF2D3953),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavItem(Icons.home, true),
          _buildBottomNavItem(Icons.search, false),
          _buildBottomNavItem(Icons.message, false),
          _buildBottomNavItem(Icons.person, false),
        ],
      ),
    );
  }
}
