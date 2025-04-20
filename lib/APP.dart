// StrongerKiddos.dart
import 'package:flutter/material.dart';
import 'package:strongerkiddos/AppRouter.dart';

class StrongerKiddos extends StatelessWidget {
  const StrongerKiddos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stronger Kiddos',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
