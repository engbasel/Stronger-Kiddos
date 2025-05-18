import 'package:flutter/material.dart';
import '../utils/app_text_style.dart';

class CustomName extends StatelessWidget {
  const CustomName({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: TextStyles.regular16.copyWith(color: Colors.black)),
      ],
    );
  }
}
