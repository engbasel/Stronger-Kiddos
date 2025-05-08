import 'package:flutter/material.dart';
import 'core/helper/on_generate_routes.dart';

class StrongerKiddos extends StatelessWidget {
  const StrongerKiddos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stronger Kiddos',
      theme: ThemeData(
        fontFamily: 'ClashGrotesk',
        useMaterial3: true,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF9B356),
          primary: const Color(0xFFF9B356),
        ),
      ),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
