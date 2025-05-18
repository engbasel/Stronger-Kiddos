import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/questionnaire_entity.dart';

abstract class QuestionnaireRepo {
  Future<Either<Failures, void>> saveQuestionnaireData({
    required String userId,
    required QuestionnaireEntity questionnaireData,
  });

  Future<Either<Failures, QuestionnaireEntity>> getQuestionnaireData({
    required String userId,
  });

  Future<Either<Failures, bool>> hasCompletedQuestionnaire({
    required String userId,
  });
}
