import 'package:flutter/material.dart';

class FormError extends StatelessWidget {
  final String? error;
  final double? marginTop;
  final double? marginBottom;

  const FormError({
    super.key,
    required this.error,
    this.marginTop = 4.0,
    this.marginBottom = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    if (error == null || error!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(
        top: marginTop!,
        bottom: marginBottom!,
        left: 4.0, // Left padding to align with the form field
      ),
      child: Text(
        error!,
        style: const TextStyle(color: Colors.red, fontSize: 12.0),
      ),
    );
  }
}
