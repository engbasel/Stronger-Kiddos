import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  static BoxDecoration buttonDecoration = BoxDecoration(
    color: AppColors.primaryColor,
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration containerDecoration = BoxDecoration(
    color: AppColors.backgroundColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, spreadRadius: 2)
    ],
  );
}