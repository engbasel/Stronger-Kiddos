import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/features/home/presentation/views/main_navigation_view.dart';
import '../../../../../app_constants.dart';
import '../../../../../core/services/firebase_auth_service.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/services/shared_preferences_sengleton.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../auth/presentation/views/login_view.dart';
import '../../../../onbording/presentation/views/on_boarding_view.dart';
import '../../../../questionnaires/domain/repos/baby_questionnaire_repo.dart';
import '../../../../questionnaires/presentation/views/baby_questionnaire_controller_view.dart';
import 'smiling_face_painter.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _smileAnimation;
  late Animation<double> _eyesAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _linesAnimation;
  final FirebaseAuthService _authService = getIt<FirebaseAuthService>();
  final BabyQuestionnaireRepo _questionnaireRepo =
      getIt<BabyQuestionnaireRepo>();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToNextScreen();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _eyesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
      ),
    );

    _smileAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    _linesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  // Updated navigation logic in _navigateToNextScreen method in SplashViewBody
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(
      const Duration(seconds: AppConstants.navigationDelaySeconds),
    );

    if (!mounted) return;

    // Check if onboarding has been shown before
    final bool onboardingShown = Prefs.getBool(AppConstants.kOnboardingShown);

    if (!onboardingShown) {
      // First time opening the app - show onboarding
      Prefs.setBool(AppConstants.kOnboardingShown, true);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
      return;
    }

    // Check if user is logged in
    final bool isLoggedIn = _authService.isLoggedIn();
    if (!isLoggedIn) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, LoginView.routeName);
      return;
    }

    // User is logged in - check email verification first
    bool isEmailVerified = await _authService.checkEmailVerification();
    if (!mounted) return;

    if (!isEmailVerified) {
      // User is logged in but email not verified
      String? email = _authService.currentUser?.email;
      Navigator.pushReplacementNamed(
        context,
        '/email-verification',
        arguments: {'email': email ?? ''},
      );
      return;
    }

    // Email is verified - check questionnaire completion
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, LoginView.routeName);
      return;
    }

    final result = await _questionnaireRepo.hasCompletedQuestionnaire(
      userId: userId,
    );

    final hasCompletedQuestionnaire = result.fold(
      (failure) => false,
      (completed) => completed,
    );

    if (!context.mounted) return;

    // Navigate based on questionnaire completion status
    if (hasCompletedQuestionnaire) {
      // User has completed questionnaire - get the last route or go to home
      final lastRoute = Prefs.getString(AppConstants.kLastVisitedRoute);

      if (lastRoute.isNotEmpty && lastRoute != '/splash') {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, lastRoute);
      } else {
        if (!mounted) return;

        Navigator.pushReplacementNamed(context, MainNavigationView.routeName);
      }
    } else {
      // User needs to complete questionnaire - direct to questionnaire without showing home
      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        BabyQuestionnaireControllerView.routeName,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 1.0],
          colors: [AppColors.fabBackgroundColor, Colors.black87],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: buildSmilingFaceLogo(),
                ),
                const SizedBox(height: 20),
                Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: Text(
                    'stronger kiddos',
                    style: TextStyles.bold36.copyWith(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildSmilingFaceLogo() {
    return SizedBox(
      width: 300,
      height: 150,
      child: CustomPaint(
        painter: SmilingFacePainter(
          smileProgress: _smileAnimation.value,
          eyesProgress: _eyesAnimation.value,
          linesProgress: _linesAnimation.value,
        ),
      ),
    );
  }
}
