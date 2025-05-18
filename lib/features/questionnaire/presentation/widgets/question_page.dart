import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class QuestionPageScaffold extends StatelessWidget {
  final String questionText;
  final Widget child;
  final VoidCallback onNext;
  final bool showNextButton;
  final bool isLastQuestion;

  const QuestionPageScaffold({
    super.key,
    required this.questionText,
    required this.child,
    required this.onNext,
    this.showNextButton = true,
    this.isLastQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                questionText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: child,
              ),
            ),
            if (showNextButton)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      backgroundColor: AppColors.fabBackgroundColor,
                    ),
                    onPressed: onNext,
                    child: Text(
                      isLastQuestion ? 'Finish' : 'Next',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
