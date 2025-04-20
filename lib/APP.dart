// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:strongerkiddos/AppRouter.dart';

class StrongerKiddos extends StatelessWidget {
  const StrongerKiddos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
