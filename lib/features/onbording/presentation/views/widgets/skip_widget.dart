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
    return Visibility(
      visible: currentPage != 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Opacity(
              opacity: 0.3,
              child: Text(
                'skip',
                style: TextStyles.bold19.copyWith(color: Colors.grey.shade900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
