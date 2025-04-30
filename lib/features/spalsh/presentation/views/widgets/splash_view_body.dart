import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../onbording/presentation/views/on_boarding_view.dart';
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

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToHome();
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

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushNamed(context, OnBoardingView.routeName);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fabBackgroundColor,
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: _buildSmilingFaceLogo(),
                ),
                const SizedBox(height: 20),
                Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: Text(
                    'Stronger Kiddos',
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

  Widget _buildSmilingFaceLogo() {
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
