import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../models/baby_questionnaire_model.dart';
import '../../domain/entities/baby_questionnaire_entity.dart';
import '../../domain/repos/baby_questionnaire_repo.dart';

class BabyQuestionnaireRepoImpl implements BabyQuestionnaireRepo {
  final StorageService storageService;

  BabyQuestionnaireRepoImpl({required this.storageService});

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @override
  Future<Either<Failures, String>> uploadBabyPhoto({
    required File imageFile,
    required String userId,
  }) async {
    try {
      // Check if user is authenticated
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        return left(ServerFailure('Unauthorized access'));
      }

      log('Uploading baby photo for user: $userId');

      // Use the storage service to upload baby photo
      final imageUrl = await storageService.uploadFile(
        imageFile,
        'babies/photos/$userId',
      );

      log('Baby photo uploaded successfully. URL: $imageUrl');
      return right(imageUrl);
    } catch (e) {
      log('Error uploading baby photo: $e');
      return left(
        ServerFailure('Failed to upload baby photo: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, String?>> getBabyPhotoUrl({
    required String userId,
  }) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        return left(ServerFailure('Unauthorized access'));
      }

      // Try to get the photo URL from questionnaire data first
      final questionnaireResult = await getQuestionnaireData(userId: userId);

      return questionnaireResult.fold(
        (failure) => right(null), // Return null if no questionnaire found
        (questionnaire) => right(questionnaire.babyPhotoUrl),
      );
    } catch (e) {
      log('Error getting baby photo URL: $e');
      return left(
        ServerFailure('Failed to get baby photo URL: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, void>> deleteBabyPhoto({
    required String userId,
  }) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        return left(ServerFailure('Unauthorized access'));
      }

      // Note: For now, we'll just remove the photo URL from questionnaire data
      // The actual file deletion can be implemented if needed

      // Get current questionnaire data
      final questionnaireResult = await getQuestionnaireData(userId: userId);

      return questionnaireResult.fold((failure) => left(failure), (
        questionnaire,
      ) async {
        // Update questionnaire with null photo URL
        final updatedQuestionnaire = BabyQuestionnaireEntity(
          babyPhotoUrl: null, // Remove photo URL
          babyName: questionnaire.babyName,
          dateOfBirth: questionnaire.dateOfBirth,
          relationship: questionnaire.relationship,
          gender: questionnaire.gender,
          wasPremature: questionnaire.wasPremature,
          weeksPremature: questionnaire.weeksPremature,
          diagnosedConditions: questionnaire.diagnosedConditions,
          careProviders: questionnaire.careProviders,
          hasMedicalContraindications:
              questionnaire.hasMedicalContraindications,
          contraindicationsDescription:
              questionnaire.contraindicationsDescription,
          floorTimeDaily: questionnaire.floorTimeDaily,
          containerTimeDaily: questionnaire.containerTimeDaily,
          completedAt: questionnaire.completedAt,
        );

        final updateResult = await updateQuestionnaireData(
          userId: userId,
          questionnaireData: updatedQuestionnaire,
        );

        return updateResult;
      });
    } catch (e) {
      log('Error deleting baby photo: $e');
      return left(
        ServerFailure('Failed to delete baby photo: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, bool>> hasBabyPhoto({required String userId}) async {
    try {
      final photoUrlResult = await getBabyPhotoUrl(userId: userId);

      return photoUrlResult.fold(
        (failure) => right(false),
        (photoUrl) => right(photoUrl != null && photoUrl.isNotEmpty),
      );
    } catch (e) {
      log('Error checking if baby photo exists: $e');
      return right(false);
    }
  }

  @override
  Future<Either<Failures, void>> saveQuestionnaireData({
    required String userId,
    required BabyQuestionnaireEntity questionnaireData,
  }) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        return left(ServerFailure('Unauthorized access'));
      }

      final model = BabyQuestionnaireModel.fromEntity(questionnaireData);
      await firestore
          .collection('baby_questionnaires')
          .doc(userId)
          .set(model.toJson());

      log('Questionnaire data saved successfully for user: $userId');
      return right(null);
    } catch (e) {
      log('Error saving questionnaire data: $e');
      return left(
        ServerFailure('Failed to save questionnaire data: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, BabyQuestionnaireEntity>> getQuestionnaireData({
    required String userId,
  }) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        return left(ServerFailure('Unauthorized access'));
      }

      log('Fetching questionnaire data for user: $userId');
      final docSnapshot =
          await firestore.collection('baby_questionnaires').doc(userId).get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        log('No questionnaire data found for user: $userId');
        return left(ServerFailure('No questionnaire data found'));
      }

      final model = BabyQuestionnaireModel.fromJson(docSnapshot.data()!);
      log('Questionnaire data fetched successfully for user: $userId');
      return right(model.toEntity());
    } catch (e) {
      log('Error getting questionnaire data: $e');
      return left(
        ServerFailure('Failed to get questionnaire data: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, bool>> hasCompletedQuestionnaire({
    required String userId,
  }) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        log('User not authenticated when checking questionnaire completion');
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        log(
          'Unauthorized access attempt for user: $userId by ${currentUser.uid}',
        );
        return left(ServerFailure('Unauthorized access'));
      }

      log('Checking questionnaire completion for user: $userId');
      final docSnapshot =
          await firestore.collection('baby_questionnaires').doc(userId).get();

      final exists = docSnapshot.exists;
      log('Questionnaire completion check for user $userId: $exists');

      return right(exists);
    } catch (e) {
      log('Error checking questionnaire completion: $e');
      return left(
        ServerFailure(
          'Failed to check questionnaire completion: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failures, void>> updateQuestionnaireData({
    required String userId,
    required BabyQuestionnaireEntity questionnaireData,
  }) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        return left(ServerFailure('Unauthorized access'));
      }

      final model = BabyQuestionnaireModel.fromEntity(questionnaireData);
      await firestore
          .collection('baby_questionnaires')
          .doc(userId)
          .update(model.toJson());

      log('Questionnaire data updated successfully for user: $userId');
      return right(null);
    } catch (e) {
      log('Error updating questionnaire data: $e');
      return left(
        ServerFailure('Failed to update questionnaire data: ${e.toString()}'),
      );
    }
  }
}
