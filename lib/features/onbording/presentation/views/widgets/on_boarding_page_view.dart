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
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          titel: "Your Title Goes Here",
          subtitle:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum porta ipsum',
        ),
        PageViewItem(
          image: Assets.imagesPngImage2,
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          titel: 'Your Title Goes Here',
          subtitle:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum porta ipsum',
        ),
        PageViewItem(
          image: Assets.imagesPng3,
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          titel: 'Your Title Goes Here',
          subtitle:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum porta ipsum',
        ),
      ],
    );
  }
}
