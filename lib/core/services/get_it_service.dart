import 'package:get_it/get_it.dart';
import '../../features/auth/data/repos/auth_repo_impl.dart';
import '../../features/auth/domain/repos/auth_repo.dart';
import '../../features/auth/persentation/manager/login_cubit/login_cubit.dart';
import '../../features/auth/persentation/manager/signup_cubit/signup_cubit.dart';
import '../services/data_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestor_service.dart';
import '../services/storage_service.dart';
import 'fire_storage.dart';

final getIt = GetIt.instance;

void setupGetit() {
  // Services
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestorService());
  getIt.registerSingleton<StorageService>(FireStorage());

  // Repositories
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseService: getIt<DatabaseService>(),
    ),
  );

  // Cubits
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(authRepo: getIt<AuthRepo>()),
  );

  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(authRepo: getIt<AuthRepo>()),
  );

  // إضافة المستودعات الأخرى إذا لزم الأمر
  // getIt.registerSingleton<DonerRepo>(DonerRepoImpl(getIt.get<DatabaseService>()));
  // getIt.registerSingleton<NeederRepo>(NeederRepoImpl(getIt.get<DatabaseService>()));
}
