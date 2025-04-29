import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔧 إعداد Firebase (لو بتستخدمه)

  // 💡 إعدادات النظام - زي إخفاء الـ Status Bar
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();

  // Enable Crashlytics for error reporting
  // 🏁 تشغيل التطبيق
  runApp(const StrongerKiddos());
}
