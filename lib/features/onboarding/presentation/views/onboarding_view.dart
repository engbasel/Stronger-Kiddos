import 'package:flutter/material.dart';
import 'package:strongerkiddos/features/onboarding/presentation/widgets/onboarding_widget.dart';

class Onboardingview extends StatelessWidget {
  const Onboardingview({super.key});
  static const routeName = 'onboarding';

  @override
  Widget build(BuildContext context) {
    return OnboardingBody();
  }
}
