import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'dart:developer';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/data_service.dart';
import '../../domain/entities/questionnaire_entity.dart';
import '../../domain/repos/questionnaire_repo.dart';

class QuestionnaireRepoImpl implements QuestionnaireRepo {
  final DatabaseService databaseService;

  QuestionnaireRepoImpl({required this.databaseService});

  @override
  Future<Either<Failures, void>> saveQuestionnaireData({
    required String userId,
    required QuestionnaireEntity questionnaireData,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('questionnaires')
          .doc(userId)
          .set(questionnaireData.toMap());

      return right(null);
    } catch (e) {
      log('Error saving questionnaire data: $e');
      return left(ServerFailure('Failed to save questionnaire data'));
    }
  }

  @override
  Future<Either<Failures, QuestionnaireEntity>> getQuestionnaireData({
    required String userId,
  }) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('questionnaires')
              .doc(userId)
              .get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return left(ServerFailure('No questionnaire data found'));
      }

      return right(QuestionnaireEntity.fromMap(docSnapshot.data()!));
    } catch (e) {
      log('Error getting questionnaire data: $e');
      return left(ServerFailure('Failed to get questionnaire data'));
    }
  }

  @override
  Future<Either<Failures, bool>> hasCompletedQuestionnaire({
    required String userId,
  }) async {
    try {
      // Use a direct document reference instead of a query
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('questionnaires')
              .doc(userId)
              .get();

      return right(docSnapshot.exists);
    } catch (e) {
      log('Error checking questionnaire completion: $e');
      return left(ServerFailure('Failed to check questionnaire completion'));
    }
  }
}
