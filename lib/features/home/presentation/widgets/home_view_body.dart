import 'package:flutter/material.dart';
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
        ],
      ),
    );
  }
}
