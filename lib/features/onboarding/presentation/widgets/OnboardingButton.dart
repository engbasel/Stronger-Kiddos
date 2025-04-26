import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnboardingButton extends StatelessWidget {
  final int currentPage;
  final Animation<double> animation;
  final VoidCallback onPressed;

  const OnboardingButton({
    Key? key,
    required this.currentPage,
    required this.animation,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Final page has "Get Started" text button
    if (currentPage == 2) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.2, 0),
            end: Offset.zero,
          ).animate(animation),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9E45),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18),
                // Animated arc for the button
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(50, 50),
                      painter: ArcPainter(
                        color: Colors.amber[100]!,
                        progress: animation.value,
                        startAngle: -math.pi / 1.5,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    // First two pages have circular buttons with arrow
    return Stack(
      alignment: Alignment.center,
      children: [
        // Blue square border for first page
        if (currentPage == 0)
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.scale(
                scale: animation.value,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),

        // Circular button with animated arc
        GestureDetector(
          onTap: onPressed,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Animated arc around the button for second page
                  if (currentPage == 1)
                    CustomPaint(
                      size: const Size(70, 70),
                      painter: ArcPainter(
                        color: const Color(0xFFFF9E45),
                        progress: animation.value,
                        startAngle: math.pi / 2,
                      ),
                    ),

                  // The orange circle button
                  Container(
                    width: currentPage == 0 ? 64 : 50,
                    height: currentPage == 0 ? 64 : 50,
                    // height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF9E45),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// Custom painter for the arc animations
class ArcPainter extends CustomPainter {
  final Color color;
  final double progress;
  final double startAngle;

  ArcPainter({
    required this.color,
    required this.progress,
    required this.startAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 + 5,
    );

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    // Draw an arc that animates from 0 to 3/4 of a circle
    canvas.drawArc(rect, startAngle, progress * 1.5 * math.pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
