// StrongerKiddos.dart
import 'package:flutter/material.dart';
import 'package:strongerkiddos/AppRouter.dart';
import 'package:strongerkiddos/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:strongerkiddos/features/splash/presentation/views/splash_view.dart';

class StrongerKiddos extends StatelessWidget {
  const StrongerKiddos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Onboardingview(),
      debugShowCheckedModeBanner: false,
      title: 'Stronger Kiddos',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      initialRoute: SplashView.routeName,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
