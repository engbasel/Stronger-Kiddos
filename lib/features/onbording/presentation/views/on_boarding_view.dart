import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/onbording/presentation/views/widget/build_nav_bottom.dart';
import 'package:strongerkiddos/features/onbording/presentation/views/widget/on_boarding_page_view.dart';
import 'package:strongerkiddos/features/onbording/presentation/views/widget/skip_widget.dart';

class OnBoardingView extends StatefulWidget {
  static const String routeName = 'onboardingview';

  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late PageController pageController;
  var currentPage = 0;

  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              const SizedBox(height: 25),
              SkipWidget(
                currentPage: currentPage,
                pageController: pageController,
              ),
              Expanded(
                child: OnBoardingPageView(pageController: pageController),
              ),
              const SizedBox(height: 20),
              buildNavigationBar(context, pageController, currentPage),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
