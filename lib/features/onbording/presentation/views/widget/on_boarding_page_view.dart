import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/assets_images.dart';
import 'package:strongerkiddos/features/onbording/presentation/views/widget/page_view_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          image: Assets.onboarding_step_one,
          titel: "Expert Care, Happy Movement ",
          subtitle:
              'Helping your child move, grow, and thrive with expert pediatric physiotherapy',
        ),
        PageViewItem(
          image: Assets.onboarding_step_three,
          titel: 'Tailored Exercises',
          subtitle:
              'Therapist-designed programs tailored to your baby needs fun and effective',
        ),
        PageViewItem(
          image: Assets.onboarding_step_two,
          titel: 'See Every Step Forward',
          subtitle:
              'Monitor your baby’s progress, receive reminders all in one simple app',
        ),
      ],
    );
  }
}
