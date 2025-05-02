import 'package:flutter/material.dart';
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),

          Positioned(
            left: 20,
            right: 20,
            bottom: 145, // يمكنك ضبط المسافة حسب الحاجة
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titel,
                  style: TextStyles.bold23.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 12),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyles.regular17.copyWith(color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
