// import 'package:get_it/get_it.dart';

// final getIt = GetIt.instance;

// void setupGetit() {
//   getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
//   getIt.registerSingleton<DatabaseService>(FirestorService());
//   getIt.registerSingleton<StorageService>(FireStorage());

//   getIt.registerSingleton<AuthRepo>(
//     AuthRepoImpl(
//       firebaseAuthService: getIt<FirebaseAuthService>(),
//       databaseService: getIt<DatabaseService>(),
//     ),
//   );
//   getIt.registerSingleton<DonerRepo>(
//     DonerRepoImpl(getIt.get<DatabaseService>()),
//   );
//   getIt.registerSingleton<NeederRepo>(
//     NeederRepoImpl(getIt.get<DatabaseService>()),
//   );
// }
