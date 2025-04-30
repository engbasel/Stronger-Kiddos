import 'package:flutter/material.dart';

import '../../../../../core/utils/assets_images.dart';
import 'page_view_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          image: Assets.imagesPng1,
          titel: "title_on_boarding_one",
          subtitle: 'subtitle_on_boarding_one',
        ),
        PageViewItem(
          image: Assets.imagesPng1,

          titel: 'title_on_boarding_two',
          subtitle: 'subtitle_on_boarding_two',
        ),
        PageViewItem(
          image: Assets.imagesPng1,

          titel: 'title_on_boarding_four',
          subtitle: 'subtitle_on_boarding_four',
        ),
      ],
    );
  }
}
