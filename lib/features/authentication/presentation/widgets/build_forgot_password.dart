import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/forgot_password_view.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/login_with_phone_and_otp_view.dart';

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
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreenWithPhoneAndOtp(),
              ),
            );
          },
          child: const Text(
            'Login With OTP',
            style: TextStyle(color: Color(0xFFF9B356), fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
