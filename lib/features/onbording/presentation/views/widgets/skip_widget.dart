import 'package:flutter/material.dart';
import '../../../../../core/utils/app_text_style.dart';

class SkipWidget extends StatelessWidget {
  const SkipWidget({
    super.key,
    required this.pageController,
    required this.currentPage,
  });

  final PageController pageController;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // No back button as per new design
        const Spacer(),
        // Skip button - only appears on first two screens
        if (currentPage < 2)
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: TextButton(
              onPressed: () {
                pageController.animateToPage(
                  2, // Go to last page
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                'Skip',
                style: TextStyles.bold16.copyWith(color: Colors.grey.shade700),
              ),
            ),
          ),
      ],
    );
  }
}
