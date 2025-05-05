import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:strongerkiddos/core/utils/app_text_style.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.image,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.color,
  });

  final String image;
  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            SvgPicture.asset(
              image,
              width: 24, // Adjust SVG size for better proportionality
              height: 24,
            ),
            const SizedBox(width: 16), // Reduced space between icon and text
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.semiBold14.copyWith(
                color: color ?? Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
