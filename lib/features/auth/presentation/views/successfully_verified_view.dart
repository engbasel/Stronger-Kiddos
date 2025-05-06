import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/features/home/presentation/Views/home_view.dart';

class SuccessfullyVerifiedView extends StatelessWidget {
  const SuccessfullyVerifiedView({super.key});
  static const String routeName = '/successfully-verified';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xff00c64f),
              radius: 30,

              child: Icon(Icons.done, color: Colors.white),
            ),
            const Text(
              'Successfully Verified',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'Quicksand',
              ),
            ),
            const Text(
              'Let’s start creating your account so you can  start using the app',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w400,
                color: Color(0xff999DA3),
              ),
            ),
            const SizedBox(height: 16),

            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, HomeView.routeName);
            //   },
            //   child: const Text('Start'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeView.routeName);
                },
                text: 'Start',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
