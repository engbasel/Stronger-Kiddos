import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';

import '../../../../../core/utils/app_text_style.dart';

Widget buildNavigationBar(
  BuildContext context,
  PageController pageController,
  var currentPage,
) {
  return Row(
    children: [
      // Prev Button
      Expanded(
        flex: 2,
        child: Visibility(
          visible: currentPage > 0,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: TextButton(
            onPressed:
                currentPage > 0
                    ? () {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                    : null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              "prev",
              style: TextStyles.bold16.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ),
      ),
      // Spacer for balanced alignment
      const Spacer(flex: 1),
      // Smooth Page Indicator
      Expanded(
        flex: 4,
        child: Center(
          child: SmoothPageIndicator(
            controller: pageController,
            count: 3, // Number of pages
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.primaryColor,
              dotColor: Colors.grey,
              dotHeight: 10,
              dotWidth: 10,
              spacing: 5,
            ),
          ),
        ),
      ),
      // Spacer for balanced alignment
      const Spacer(flex: 1),
      // Next/Start Button
      Expanded(
        flex: 2,
        child:
            currentPage == 2
                ? ElevatedButton(
                  onPressed: () {
                    // Prefs.setBool(kIsOnBoardingViewSeen, true);
                    // Navigator.of(
                    //   context,
                    // ).pushReplacement(buildPageRoute(ChooseYourLanguage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("start", style: TextStyle(color: Colors.white)),
                )
                : TextButton(
                  onPressed: () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "next",
                    style: TextStyles.bold16.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
      ),
    ],
  );
}
