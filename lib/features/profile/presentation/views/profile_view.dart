import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFbad7ac),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF3e5e42),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Child Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _buildProfileItem(Icons.calendar_today, 'Age: 5 years'),
                _buildProfileItem(Icons.height, 'Height: 110 cm'),
                _buildProfileItem(Icons.monitor_weight, 'Weight: 20 kg'),
                _buildProfileItem(Icons.favorite, 'Health Status: Good'),
                _buildProfileItem(Icons.school, 'School: Primary School'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3e5e42)),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
