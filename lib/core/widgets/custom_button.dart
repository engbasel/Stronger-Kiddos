import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = AppColors.fabBackgroundColor,
    this.color = Colors.white,
  });
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          backgroundColor: backgroundColor,
          side: const BorderSide(
            color: AppColors.fabBackgroundColor,
            width: 1.5,
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyles.bold16.copyWith(color: color)),
      ),
    );
  }
}
