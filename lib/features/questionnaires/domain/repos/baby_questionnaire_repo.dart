import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/baby_questionnaire_entity.dart';

abstract class BabyQuestionnaireRepo {
  // Baby photo management methods
  Future<Either<Failures, String>> uploadBabyPhoto({
    required File imageFile,
    required String userId,
  });

  Future<Either<Failures, String?>> getBabyPhotoUrl({required String userId});

  Future<Either<Failures, void>> deleteBabyPhoto({required String userId});

  Future<Either<Failures, bool>> hasBabyPhoto({required String userId});

  // NEW: Save only photo URL immediately after upload
  Future<Either<Failures, void>> saveBabyPhotoUrl({
    required String userId,
    required String photoUrl,
  });

  // NEW: Get partial questionnaire data (for loading during restart)
  Future<Either<Failures, BabyQuestionnaireEntity?>>
  getPartialQuestionnaireData({required String userId});

  // Questionnaire data methods
  Future<Either<Failures, void>> saveQuestionnaireData({
    required String userId,
    required BabyQuestionnaireEntity questionnaireData,
  });

  Future<Either<Failures, BabyQuestionnaireEntity>> getQuestionnaireData({
    required String userId,
  });

  Future<Either<Failures, bool>> hasCompletedQuestionnaire({
    required String userId,
  });

  Future<Either<Failures, void>> updateQuestionnaireData({
    required String userId,
    required BabyQuestionnaireEntity questionnaireData,
  });
}
