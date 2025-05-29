import 'package:flutter/material.dart';
import 'package:strongerkiddos/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/get_it_service.dart';
import 'core/services/shared_preferences_sengleton.dart';
import 'firebase_options.dart';
import 'stronger_siddos_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize SharedPreferences
  await Prefs.init();

  // Initialize Supabase BEFORE setupGetit
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.anonKey,
  );

  // Setup GetIt AFTER Supabase initialization
  setupGetit();

  runApp(const StrongerKiddos());
}
