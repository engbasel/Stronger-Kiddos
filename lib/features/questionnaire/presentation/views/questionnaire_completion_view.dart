// lib/features/questionnaire/presentation/views/questionnaire_completion_view.dart
import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/home/presentation/views/main_navigation_view.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class QuestionnaireCompletionView extends StatelessWidget {
  const QuestionnaireCompletionView({super.key});

  static const String routeName = '/questionnaire-completed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 40,
                child: Icon(Icons.check, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 24),
              const Text(
                'Thank You!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your answers will help us create a personalized plan for your baby.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              CustomButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MainNavigationView.routeName);
                },
                text: 'Go to Home',
                backgroundColor: AppColors.fabBackgroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
