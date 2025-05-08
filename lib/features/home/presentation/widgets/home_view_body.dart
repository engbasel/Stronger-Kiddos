import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/services/firebase_auth_service.dart';
import 'package:strongerkiddos/core/services/get_it_service.dart';
import 'package:strongerkiddos/core/utils/app_text_style.dart';
import 'package:strongerkiddos/features/auth/presentation/views/login_view.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/new_to_app_card_section.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/search_bar_section.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/welcome_section.dart';

class HomeviewBody extends StatelessWidget {
  const HomeviewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          const WelcomeSection(),
          // Search Bar Section
          const SearchBarSection(),

          const SizedBox(height: 16),

          // New to App Card Section
          const NewToAppCardSection(),

          // // Recommended Section
          // const RecommendedSection(),

          // const Spacer(),

          // Bottom Navigation Bar Section
          // const BottomNavBarSection(),

          // Logout Button
          const Spacer(),
          _buildLogoutButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final FirebaseAuthService authService = getIt<FirebaseAuthService>();

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(color: Colors.red.shade300, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          await authService.signOut();
          if (!context.mounted) return;
          Navigator.pushReplacementNamed(context, LoginView.routeName);
        },
        child: Text(
          'Logout',
          style: TextStyles.bold16.copyWith(color: Colors.red.shade700),
        ),
      ),
    );
  }
}
