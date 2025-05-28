// lib/features/auth/presentation/views/successfully_verified_view.dart
import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/features/questionnaire/presentation/views/questionnaire_controller_view.dart';

class SuccessfullyVerifiedView extends StatelessWidget {
  const SuccessfullyVerifiedView({super.key});
  static const String routeName = '/successfully-verified';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xff00c64f),
              radius: 30,
              child: Icon(Icons.done, color: Colors.white),
            ),
            const Text(
              'Successfully Verified',
              style: TextStyle(
                fontSize: 24,color: AppColors.fabBackgroundColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'Quicksand',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Text(
                '''Let's tell us a bit about your child so we can personalize our recommendations for you.''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w400,
                  color: Color(0xff999DA3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(backgroundColor: AppColors.fabBackgroundColor ,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    QuestionnaireControllerView.routeName,
                  );
                },
                text: 'Get Started',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
