// lib/features/home/presentation/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentation/manager/cubit/auth_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    // Get current user info from AuthState
    final authState = context.watch<AuthCubit>().state;
    final userName = authState.user?.name ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $userName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'You are now logged in',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            if (authState.user?.email != null) ...[
              const SizedBox(height: 8),
              Text(
                'Email: ${authState.user!.email}',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to user profile or any other screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9B356),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'View Profile',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthCubit>().signOut();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}
