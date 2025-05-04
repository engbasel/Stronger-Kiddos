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
    // Get the bottom padding to account for the safe area
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      // Add height + bottom padding to account for safe area
      height: 60 + bottomPadding,
      width: double.infinity, // Ensure full width
      decoration: const BoxDecoration(
        color: Color(0xFF2D3953),
        borderRadius: BorderRadius.zero, // Remove any border radius
      ),
      child: Column(
        children: [
          // This is your actual navigation content
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomNavItem(Icons.home, true),
                _buildBottomNavItem(Icons.search, false),
                _buildBottomNavItem(Icons.message, false),
                _buildBottomNavItem(Icons.person, false),
              ],
            ),
          ),
          // This empty container fills the safe area with your background color
          Container(height: bottomPadding, color: Color(0xFF2D3953)),
        ],
      ),
    );
  }
}
