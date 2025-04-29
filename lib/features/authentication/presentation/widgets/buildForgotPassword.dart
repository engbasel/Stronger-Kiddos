import 'package:flutter/material.dart';

Widget buildForgotPassword() {
  return Align(
    alignment: Alignment.center,
    child: TextButton(
      onPressed: () {},
      child: const Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
    ),
  );
}
