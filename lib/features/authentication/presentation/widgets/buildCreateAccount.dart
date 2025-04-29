import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/CreateAccountScreen.dart';

Widget buildCreateAccount(BuildContext context) {
  return Center(
    child: TextButton(
      onPressed: () {
        // Add your navigation logic here
        Navigator.pushNamed(context, CreateAccountScreen.routeName);
      },
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
