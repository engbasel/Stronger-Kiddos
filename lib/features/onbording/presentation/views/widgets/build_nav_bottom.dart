import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';

Widget buildNavigationBar(
  BuildContext context,
  PageController pageController,
  int currentPage,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: (currentPage + 1) / 3),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(70, 70),
                painter: ArcProgressPainter(
                  progress: value,
                  color: AppColors.fabBackgroundColor,
                  strokeWidth: 4,
                ),
              ),

              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.fabBackgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.fabBackgroundColor.withValues(
                          alpha: .3,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        if (currentPage < 2) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                      },
                      child: const Center(
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 20),
      AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.fabBackgroundColor,
                dotColor: Colors.grey,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 5,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class ArcProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  ArcProgressPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) + 5;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    // Create the paint for the arc
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    // Draw the arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(ArcProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
