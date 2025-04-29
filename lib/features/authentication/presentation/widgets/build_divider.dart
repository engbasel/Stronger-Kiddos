import 'package:flutter/material.dart';

Widget buildDivider() {
  return Row(
    children: [
      Expanded(child: Divider(color: Colors.grey.shade300)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'or sign in with',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ),
      Expanded(child: Divider(color: Colors.grey.shade300)),
    ],
  );
}
