import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strongerkiddos/app.dart'; // الكلاس الأساسي للتطبيق
import 'package:firebase_core/firebase_core.dart'; // لو بتستخدم Firebase
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔧 إعداد Firebase (لو بتستخدمه)
  await Firebase.initializeApp();

  // 💡 إعدادات النظام - زي إخفاء الـ Status Bar
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();

  // Enable Crashlytics for error reporting
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // 🏁 تشغيل التطبيق
  runApp(const StrongerKiddos());
}
