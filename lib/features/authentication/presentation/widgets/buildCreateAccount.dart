import 'package:flutter/material.dart';

Widget buildCreateAccount() {
  return Center(
    child: TextButton(
      onPressed: () {},
      child: const Text(
        'Create an account',
        style: TextStyle(
          color: Color(0xFFF9B356),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
