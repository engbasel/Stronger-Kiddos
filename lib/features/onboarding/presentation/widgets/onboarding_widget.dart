// import 'package:flutter/material.dart';
// import 'package:strongerkiddos/core/utils/app_colors.dart';
// import 'package:strongerkiddos/features/onboarding/presentation/widgets/OnboardingPage.dart';
// import 'dart:math';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/login_view.dart';
import 'package:strongerkiddos/features/onboarding/presentation/widgets/OnboardingPage.dart';

// // Constants

// class OnboardingBody extends StatefulWidget {
//   const OnboardingBody({Key? key}) : super(key: key);

//   @override
//   State<OnboardingBody> createState() => _OnboardingBodyState();
// }

// class _OnboardingBodyState extends State<OnboardingBody> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   bool _isLastPage = false;

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> onboardingData = [
//       {
//         'image': 'assets/png/1.png',
//         'title': 'Your Title Goes Here',
//         'subtitle': 'Lorem ipsum dolor sit amet,vestibulum .',
//         'subtitletwo': 'consectetur adipiscing elit, ',
//         'subtitleThree': 'Lorem ipsum dolor sit amet,.',
//       },
//       {
//         'image': 'assets/png/3.png',
//         'title': 'Your Title Goes Here',
//         'subtitle': 'Lorem ipsum dolor sit amet,vestibulum .',
//         'subtitletwo': 'consectetur adipiscing elit, ',
//         'subtitleThree': 'Lorem ipsum dolor sit amet,.',
//       },
//       {
//         'image': 'assets/png/5.png',
//         'title': 'Your Title Goes Here',
//         'subtitle': 'Lorem ipsum dolor sit amet,vestibulum .',
//         'subtitletwo': 'consectetur adipiscing elit, ',
//         'subtitleThree': 'Lorem ipsum dolor sit amet,.',
//       },
//       {
//         'image': 'assets/png/1.png',
//         'title': 'Your Title Goes Here',
//         'subtitle': 'Lorem ipsum dolor sit amet,vestibulum .',
//         'subtitletwo': 'consectetur adipiscing elit, ',
//         'subtitleThree': 'Lorem ipsum dolor sit amet,.',
//       },
//     ];

//     return Scaffold(
//       floatingActionButton: CustomFAB(
//         onPressed: () {
//           if (_isLastPage) {
//             Navigator.of(context).pushReplacementNamed('home');
//           } else {
//             _pageController.nextPage(
//               duration: AppColors.pageTransitionDuration,
//               curve: Curves.easeInOut,
//             );
//           }
//         },
//         isLastPage: _isLastPage,
//         currentPage: _currentPage,
//         totalPages: onboardingData.length,
//       ),
//       body: PageView.builder(
//         controller: _pageController,
//         onPageChanged: (index) {
//           setState(() {
//             _currentPage = index;
//             _isLastPage = index == onboardingData.length - 1;
//           });
//         },
//         itemCount: onboardingData.length,
//         itemBuilder: (context, index) {
//           final data = onboardingData[index];
//           return OnboardingPage(
//             image: data['image']!,
//             subtitletwo: data['subtitle']!,
//             title: data['title']!,
//             subtitleThree: data['subtitleThree']!,
//             subtitle: data['subtitle']!,
//             pageNumber: index + 1,
//           );
//         },
//       ),
//     );
//   }
// }

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLastPage;
  final int currentPage;
  final int totalPages;

  const CustomFAB({
    Key? key,
    required this.onPressed,
    required this.isLastPage,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Custom Painted Arc
        SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: ArcPainter(
              currentPage: currentPage,
              totalPages: totalPages,
            ),
          ),
        ),
        // Circle Button
        FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          elevation: 0,

          onPressed: onPressed,
          backgroundColor: AppColors.fabBackgroundColor,
          child: Icon(
            isLastPage ? Icons.check : Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class ArcPainter extends CustomPainter {
  final int currentPage;
  final int totalPages;

  ArcPainter({required this.currentPage, required this.totalPages});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = AppColors.arcColor
          ..strokeWidth = AppColors.arcStrokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromLTWH(
      AppColors.arcStrokeWidth / 2,
      AppColors.arcStrokeWidth / 2,
      size.width - AppColors.arcStrokeWidth,
      size.height - AppColors.arcStrokeWidth,
    );

    // Divide the circle into equal segments
    final double segmentAngle = 2 * pi / totalPages;
    const double startAngle = -pi / 2; // Start from the top

    // Draw completed segments
    for (int i = 0; i < currentPage + 1; i++) {
      final double segmentStartAngle = startAngle + (i * segmentAngle);
      // For the current page, animate the segment filling
      double sweepAngle = segmentAngle;

      canvas.drawArc(rect, segmentStartAngle, sweepAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return oldDelegate.currentPage != currentPage ||
        oldDelegate.totalPages != totalPages;
  }
}

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({Key? key}) : super(key: key);

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> onboardingData = [
      {
        'image': 'assets/png/1.png',
        'title': 'Your Title Goes Here',
        'subtitle': 'Lorem ipsum dolor sit amet,vestibulum .',
        'subtitletwo': 'consectetur adipiscing elit, ',
        'subtitleThree': 'Lorem ipsum dolor sit amet,.',
      },
      {
        'image': 'assets/png/3.png',
        'title': 'Your Title Goes Here',
        'subtitle': 'Lorem ipsum dolor sit amet,vestibulum .',
        'subtitletwo': 'consectetur adipiscing elit, ',
        'subtitleThree': 'Lorem ipsum dolor sit amet,.',
      },
      {
        'image': 'assets/png/5.png',
        'title': 'Your Title Goes Here',
        'subtitle': 'Lorem ipsum dolor sit amet,vestibulum .',
        'subtitletwo': 'consectetur adipiscing elit, ',
        'subtitleThree': 'Lorem ipsum dolor sit amet,.',
      },
      {
        'image': 'assets/png/1.png',
        'title': 'Your Title Goes Here',
        'subtitle': 'Lorem ipsum dolor sit amet,vestibulum .',
        'subtitletwo': 'consectetur adipiscing elit, ',
        'subtitleThree': 'Lorem ipsum dolor sit amet,.',
      },
    ];

    // return Scaffold(
    //   floatingActionButton: CustomFAB(
    //     onPressed: () {
    //       if (_isLastPage) {
    //         Navigator.of(context).pushReplacementNamed('home');
    //       } else {
    //         _pageController.nextPage(
    //           duration: AppColors.pageTransitionDuration,
    //           curve: Curves.easeInOut,
    //         );
    //       }
    //     },
    //     isLastPage: _isLastPage,
    //     currentPage: _currentPage,
    //     totalPages: onboardingData.length,
    //   ),
    //   body: Column(
    //     children: [
    //       Expanded(
    //         child: PageView.builder(
    //           controller: _pageController,
    //           onPageChanged: (index) {
    //             setState(() {
    //               _currentPage = index;
    //               _isLastPage = index == onboardingData.length - 1;
    //             });
    //           },
    //           itemCount: onboardingData.length,
    //           itemBuilder: (context, index) {
    //             final data = onboardingData[index];
    //             return OnboardingPage(
    //               image: data['image']!,
    //               subtitletwo: data['subtitle']!,
    //               title: data['title']!,
    //               subtitleThree: data['subtitleThree']!,
    //               subtitle: data['subtitle']!,
    //               pageNumber: index + 1,
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      floatingActionButton: CustomFAB(
        onPressed: () {
          if (_isLastPage) {
            Navigator.of(context).pushReplacementNamed(Loginview.routeName);
          } else {
            _pageController.nextPage(
              duration: AppColors.pageTransitionDuration,
              curve: Curves.easeInOut,
            );
          }
        },
        isLastPage: _isLastPage,
        currentPage: _currentPage,
        totalPages: onboardingData.length,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                      _isLastPage = index == onboardingData.length - 1;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return OnboardingPage(
                      image: data['image']!,
                      title: data['title']!,
                      subtitle: data['subtitle']!,
                      subtitletwo: data['subtitletwo']!,
                      subtitleThree: data['subtitleThree']!,
                      pageNumber: index + 1,
                      totalPages: onboardingData.length,
                      currentPage: _currentPage,
                    );
                  },
                ),
              ),

              // Dots Indicator
            ],
          ),
        ],
      ),
    );
  }
}
