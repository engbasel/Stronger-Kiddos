import 'package:get_it/get_it.dart';
import '../../features/auth/data/repos/auth_repo_impl.dart';
import '../../features/auth/domain/repos/auth_repo.dart';
import '../../features/questionnaires/data/repos/baby_questionnaire_repo_impl.dart';
import '../../features/questionnaires/domain/repos/baby_questionnaire_repo.dart';
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

  getIt.registerSingleton<BabyQuestionnaireRepo>(BabyQuestionnaireRepoImpl());
}
