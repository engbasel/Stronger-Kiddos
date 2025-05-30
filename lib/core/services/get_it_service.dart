import 'package:get_it/get_it.dart';
import 'package:strongerkiddos/core/services/supabase_storage.dart';
import '../../features/auth/data/repos/auth_repo_impl.dart';
import '../../features/auth/domain/repos/auth_repo.dart';
import '../../features/questionnaires/data/repos/baby_questionnaire_repo_impl.dart';
import '../../features/questionnaires/domain/repos/baby_questionnaire_repo.dart';
import '../services/data_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestor_service.dart';
import '../services/storage_service.dart';

final getIt = GetIt.instance;

void setupGetit() {
  // Services
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestorService());
  getIt.registerSingleton<StorageService>(SupabaseStorageService());

  // Repositories
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseService: getIt<DatabaseService>(),
      storageService: getIt<StorageService>(), // إضافة StorageService
    ),
  );

  getIt.registerSingleton<BabyQuestionnaireRepo>(
    BabyQuestionnaireRepoImpl(
      storageService:
          getIt<StorageService>(), // إضافة StorageService dependency
    ),
  );
}
