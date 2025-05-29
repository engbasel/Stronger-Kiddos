import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/baby_questionnaire_entity.dart';

abstract class BabyQuestionnaireRepo {
  Future<Either<Failures, String>> uploadBabyPhoto(File imageFile);

  // Add these new methods for private storage management
  Future<Either<Failures, String>> getSignedImageUrl(String filePath);
  Future<Either<Failures, void>> deleteBabyPhoto(String filePath);

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
}
