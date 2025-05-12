import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/core/utils/app_text_style.dart';

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
        Visibility(
          visible: currentPage == 0 ? false : true,
          child: GestureDetector(
            onTap: () {
              if (currentPage > 0) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.fabBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        currentPage == 2
            ? const SizedBox()
            : GestureDetector(
              onTap: () {
                pageController.animateToPage(
                  3,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Opacity(
                opacity: 0.3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
