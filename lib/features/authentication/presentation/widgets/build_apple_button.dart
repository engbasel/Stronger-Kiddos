import 'package:flutter/material.dart';

Widget buildAppleButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      icon: const Icon(Icons.apple, size: 24),
      label: const Text(
        'Continue with Apple',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
