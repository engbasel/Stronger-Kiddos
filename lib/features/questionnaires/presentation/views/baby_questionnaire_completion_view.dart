import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../home/presentation/Views/main_navigation_view.dart';

class BabyQuestionnaireCompletionView extends StatelessWidget {
  const BabyQuestionnaireCompletionView({super.key});

  static const String routeName = '/baby-questionnaire-completed';

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
              const CircleAvatar(
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
                  Navigator.pushReplacementNamed(
                    context,
                    MainNavigationView.routeName,
                  );
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
