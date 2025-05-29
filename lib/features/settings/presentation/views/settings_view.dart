import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingsSection(
            'Account',
            [
              _buildSettingItem(Icons.person, 'Profile Information'),
              _buildSettingItem(Icons.notifications, 'Notifications'),
              _buildSettingItem(Icons.privacy_tip, 'Privacy'),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingsSection(
            'Preferences',
            [
              _buildSettingItem(Icons.language, 'Language'),
              _buildSettingItem(Icons.dark_mode, 'Theme'),
              _buildSettingItem(Icons.volume_up, 'Sounds'),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingsSection(
            'Support',
            [
              _buildSettingItem(Icons.help, 'Help Center'),
              _buildSettingItem(Icons.feedback, 'Send Feedback'),
              _buildSettingItem(Icons.info, 'About'),
            ],
          ),
          const Spacer(),
          Center(
            child: TextButton(
              onPressed: () {
                // Logout functionality would go here
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3e5e42),
          ),
        ),
        const SizedBox(height: 10),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3e5e42)),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
}
