import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/ForgetPasswordScreen.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/LoginScreenWith_phone_and_OTP.dart';

Widget buildForgotPassword(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Row(
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, ForgetPasswordScreen.routeName);
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreenWith_phone_and_OTP(),
              ),
            );
          },
          child: const Text(
            'Login With OTP',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
