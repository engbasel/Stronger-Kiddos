import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/onboarding/presentation/views/onboarding_questions_view.dart';

Widget buildLoginButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, OnboardingQuestionScreen.routeName);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF9B356),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
