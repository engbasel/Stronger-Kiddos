import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/core/utils/assets_images.dart';
import 'package:strongerkiddos/core/utils/page_rout_builder.dart';

import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/features/auth/presentation/views/login_view.dart';
import 'package:strongerkiddos/features/auth/presentation/views/signup_view.dart';
import 'package:strongerkiddos/features/onbording/presentation/views/widget/page_view_item.dart';

class ChooesToSignupOrLoginView extends StatelessWidget {
  const ChooesToSignupOrLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PageViewItem(
              titel: 'title_on_boarding_four',
              subtitle: 'subtitle_on_boarding_four',
              image: Assets.imagesSvgGoogle,
            ),
            SizedBox(height: 90),
            CustomButton(
              onPressed: () {
                Navigator.of(context).push(buildPageRoute(SignupView()));
              },
              text: 'sign_up',
            ),
            SizedBox(height: 19),
            CustomButton(
              onPressed: () {
                Navigator.of(context).push(buildPageRoute(LoginView()));
              },
              text: 'login',
              backgroundColor: Colors.transparent,
              color: AppColors.fabBackgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
