import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_style.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    this.subtitle,
    required this.image,
    required this.titel,
  });

  final String image;
  final String titel;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                Text(
                  titel,
                  style: TextStyles.bold23.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle ?? '',
                  style: TextStyles.regular17,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
