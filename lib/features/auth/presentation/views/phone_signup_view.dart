import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import '../widgets/phone_signup_view_body.dart';

class PhoneSignupView extends StatelessWidget {
  const PhoneSignupView({super.key});
  static const String routeName = '/phone-signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const PhoneSignupViewBody(),
    );
  }
}
