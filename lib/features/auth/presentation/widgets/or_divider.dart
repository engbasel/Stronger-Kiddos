import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('or sign in with'),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
