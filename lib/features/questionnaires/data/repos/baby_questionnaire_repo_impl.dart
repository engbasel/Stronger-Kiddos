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
import 'package:path/path.dart' as path;

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

      // Sanitize file name and construct a clean path
      final fileName = path.basenameWithoutExtension(imageFile.path) + '.jpg';
      final storagePath = 'babies/photos/$userId/$fileName';

      // Use the storage service to upload baby photo
      final imageUrl = await storageService.uploadFile(imageFile, storagePath);

      log('Baby photo uploaded successfully. URL: $imageUrl');

      // Save the photo URL to Firebase
      final saveResult = await saveBabyPhotoUrl(
        userId: userId,
        photoUrl: imageUrl,
      );
      if (saveResult.isLeft()) {
        log('Warning: Photo uploaded but failed to save URL to Firebase');
      }

      return right(imageUrl);
    } catch (e) {
      log('Error uploading baby photo: $e');
      return left(
        ServerFailure('Failed to upload baby photo: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, void>> saveBabyPhotoUrl({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        return left(ServerFailure('Unauthorized access'));
      }

      // Check if questionnaire document exists
      final docRef = firestore.collection('baby_questionnaires').doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update existing document
        await docRef.update({
          'babyPhotoUrl': photoUrl,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Create partial document with just the photo URL
        await docRef.set({
          'babyPhotoUrl': photoUrl,
          'isPartial': true,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      log('Baby photo URL saved successfully for user: $userId');
      return right(null);
    } catch (e) {
      log('Error saving baby photo URL: $e');
      return left(
        ServerFailure('Failed to save baby photo URL: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, BabyQuestionnaireEntity?>>
  getPartialQuestionnaireData({required String userId}) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        return left(ServerFailure('Unauthorized access'));
      }

      log('Fetching partial questionnaire data for user: $userId');
      final docSnapshot =
          await firestore.collection('baby_questionnaires').doc(userId).get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        log('No partial questionnaire data found for user: $userId');
        return right(null);
      }

      final data = docSnapshot.data()!;

      // Check if it's a complete questionnaire or partial
      if (data['isPartial'] == true) {
        // Return minimal entity with just available data
        return right(
          BabyQuestionnaireEntity(
            babyPhotoUrl: data['babyPhotoUrl'],
            babyName: data['babyName'] ?? '',
            dateOfBirth:
                data['dateOfBirth'] != null
                    ? DateTime.parse(data['dateOfBirth'])
                    : DateTime.now(),
            relationship: data['relationship'] ?? '',
            gender: data['gender'] ?? '',
            wasPremature: data['wasPremature'] ?? false,
            weeksPremature: data['weeksPremature'],
            diagnosedConditions: List<String>.from(
              data['diagnosedConditions'] ?? [],
            ),
            careProviders: List<String>.from(data['careProviders'] ?? []),
            hasMedicalContraindications:
                data['hasMedicalContraindications'] ?? false,
            contraindicationsDescription: data['contraindicationsDescription'],
            floorTimeDaily: data['floorTimeDaily'] ?? '',
            containerTimeDaily: data['containerTimeDaily'] ?? '',
            completedAt:
                data['completedAt'] != null
                    ? DateTime.parse(data['completedAt'])
                    : DateTime.now(),
          ),
        );
      } else {
        // Return complete questionnaire
        final model = BabyQuestionnaireModel.fromJson(data);
        return right(model.toEntity());
      }
    } catch (e) {
      log('Error getting partial questionnaire data: $e');
      return right(null); // Return null instead of error for partial data
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
      final partialResult = await getPartialQuestionnaireData(userId: userId);

      return partialResult.fold(
        (failure) => right(null), // Return null if no data found
        (questionnaire) => right(questionnaire?.babyPhotoUrl),
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

      // Update the document to remove photo URL
      final docRef = firestore.collection('baby_questionnaires').doc(userId);
      await docRef.update({'babyPhotoUrl': FieldValue.delete()});

      log('Baby photo URL deleted for user: $userId');
      return right(null);
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
      final data = model.toJson();

      // Remove the partial flag and add completion timestamp
      data.remove('isPartial');
      data['completedAt'] = DateTime.now().toIso8601String();

      await firestore.collection('baby_questionnaires').doc(userId).set(data);

      log('Complete questionnaire data saved successfully for user: $userId');
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

      // Only return complete questionnaires (not partial)
      final data = docSnapshot.data()!;
      if (data['isPartial'] == true) {
        return left(ServerFailure('Questionnaire not completed yet'));
      }

      final model = BabyQuestionnaireModel.fromJson(data);
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

      if (!docSnapshot.exists) {
        return right(false);
      }

      // Check if it's a completed questionnaire (not partial)
      final data = docSnapshot.data();
      final isCompleted = data != null && data['isPartial'] != true;

      log('Questionnaire completion check for user $userId: $isCompleted');
      return right(isCompleted);
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
      final data = model.toJson();

      // Keep it as complete questionnaire
      data.remove('isPartial');

      await firestore
          .collection('baby_questionnaires')
          .doc(userId)
          .update(data);

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
