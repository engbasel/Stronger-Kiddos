import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../../app_constants.dart';

class SmilingFacePainter extends CustomPainter {
  final double smileProgress;
  final double eyesProgress;
  final double linesProgress;

  SmilingFacePainter({
    required this.smileProgress,
    required this.eyesProgress,
    required this.linesProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = AppConstants.mainStrokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    _drawEyes(canvas, center, paint);
    _drawSmile(canvas, center, paint);
    _drawWeightLines(canvas, center, paint);
  }

  void _drawEyes(Canvas canvas, Offset center, Paint paint) {
    if (eyesProgress <= 0) return;

    final leftEyeCenter = Offset(center.dx - 65, center.dy - 30);
    final rightEyeCenter = Offset(center.dx + 65, center.dy - 30);
    final eyeRadius = 25.0 * eyesProgress;

    // Left eye arc
    final leftEyeRect = Rect.fromCircle(
      center: leftEyeCenter,
      radius: eyeRadius,
    );
    canvas.drawArc(leftEyeRect, pi, pi, false, paint);

    // Right eye arc
    final rightEyeRect = Rect.fromCircle(
      center: rightEyeCenter,
      radius: eyeRadius,
    );
    canvas.drawArc(rightEyeRect, pi, pi, false, paint);
  }

  void _drawSmile(Canvas canvas, Offset center, Paint paint) {
    if (smileProgress <= 0) return;

    final smileWidth = 130.0;
    final smileStart = Offset(
      center.dx - smileWidth * smileProgress,
      center.dy + 20,
    );
    final smileEnd = Offset(
      center.dx + smileWidth * smileProgress,
      center.dy + 20,
    );
    final smileControl = Offset(center.dx, center.dy + 70 * smileProgress);

    final smilePath = Path();
    smilePath.moveTo(smileStart.dx, smileStart.dy);
    smilePath.quadraticBezierTo(
      smileControl.dx,
      smileControl.dy,
      smileEnd.dx,
      smileEnd.dy,
    );

    // Save original stroke width
    final originalStrokeWidth = paint.strokeWidth;
    paint.strokeWidth = AppConstants.smileStrokeWidth;
    canvas.drawPath(smilePath, paint);

    // Restore original stroke width
    paint.strokeWidth = originalStrokeWidth;
  }

  void _drawWeightLines(Canvas canvas, Offset center, Paint paint) {
    if (linesProgress <= 0) return;

    // Define angles for the lines
    const baseAngle = pi / 6; // 30 degrees base angle
    final angles = [
      baseAngle - 0.1,
      baseAngle,
      baseAngle + 0.1,
    ]; // Slightly different angles

    // Draw lines on both sides
    _drawAngledLines(canvas, center, true, angles, paint); // Left side
    _drawAngledLines(canvas, center, false, angles, paint); // Right side
  }

  void _drawAngledLines(
    Canvas canvas,
    Offset center,
    bool isLeft,
    List<double> angles,
    Paint paint,
  ) {
    final direction = isLeft ? -1.0 : 1.0;
    final baseX = center.dx + (140 * direction);
    final baseY = center.dy + 35;

    // Lines configuration
    final spacing = 15.0;
    final lineLengths = [40.0, 60.0, 60.0];
    final reduceFromTop = [0.0, 20.0, 25.0];
    final reduceFromBottom = [0.0, 10.0, 25.0];
    final lineAngles = List.filled(3, 2 * pi / 3); // ~60 degrees for all lines

    // Save original stroke width
    final originalStrokeWidth = paint.strokeWidth;
    paint.strokeWidth = AppConstants.lineStrokeWidth;

    // Draw the three lines
    for (int i = 0; i < 3; i++) {
      final startX = baseX + (spacing * i * direction);

      // Calculate adjusted length
      final adjustedLength =
          lineLengths[i] - (reduceFromTop[i] + reduceFromBottom[i]);

      // Adjust start point
      final startOffsetX = cos(lineAngles[i]) * reduceFromBottom[i] * direction;
      final startOffsetY = sin(lineAngles[i]) * reduceFromBottom[i];
      final adjustedStartX = startX + startOffsetX;
      final startY = baseY - startOffsetY;

      // Calculate end point
      final endX =
          adjustedStartX +
          (cos(lineAngles[i]) * adjustedLength * direction * linesProgress);
      final endY =
          startY - (sin(lineAngles[i]) * adjustedLength * linesProgress);

      // Draw the line
      canvas.drawLine(
        Offset(adjustedStartX, startY),
        Offset(endX, endY),
        paint,
      );
    }

    // Restore original stroke width
    paint.strokeWidth = originalStrokeWidth;
  }

  @override
  bool shouldRepaint(covariant SmilingFacePainter oldDelegate) {
    return oldDelegate.smileProgress != smileProgress ||
        oldDelegate.eyesProgress != eyesProgress ||
        oldDelegate.linesProgress != linesProgress;
  }
}
