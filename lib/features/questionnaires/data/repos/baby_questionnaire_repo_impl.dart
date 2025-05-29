import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/supabase_storage.dart';
import '../models/baby_questionnaire_model.dart';
import '../../domain/entities/baby_questionnaire_entity.dart';
import '../../domain/repos/baby_questionnaire_repo.dart';

class BabyQuestionnaireRepoImpl implements BabyQuestionnaireRepo {
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  final SupabaseStorageService _storageService = SupabaseStorageService();

  @override
  Future<Either<Failures, String>> uploadBabyPhoto(File imageFile) async {
    try {
      // Check if user is authenticated
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      final userId = currentUser.uid;
      log('Uploading photo for user: $userId');

      // Use the updated upload method
      final photoUrl = await _storageService.uploadFile(
        imageFile,
        'user_$userId',
      );

      log('Photo uploaded successfully: $photoUrl');
      return right(photoUrl);
    } catch (e) {
      log('Error uploading baby photo: $e');
      return left(
        ServerFailure('Failed to upload baby photo: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, String>> getSignedImageUrl(String filePath) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      // If it's already a public URL, return it as is
      if (filePath.startsWith('http')) {
        return right(filePath);
      }

      // For private files, create signed URL
      final signedUrl = await _storageService.getSignedUrl(filePath);
      return right(signedUrl);
    } catch (e) {
      log('Error creating signed URL: $e');
      return left(ServerFailure('Failed to get image URL'));
    }
  }

  @override
  Future<Either<Failures, void>> deleteBabyPhoto(String filePath) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      // Extract file path from URL if needed
      String pathToDelete = filePath;
      if (filePath.startsWith('http')) {
        // Extract path from URL if it's a full URL
        final uri = Uri.parse(filePath);
        final pathSegments = uri.pathSegments;
        if (pathSegments.length > 2) {
          pathToDelete = pathSegments.sublist(2).join('/');
        }
      }

      // Verify user owns this file (security check)
      if (!pathToDelete.startsWith('user_${currentUser.uid}/')) {
        return left(ServerFailure('Unauthorized: Cannot delete file'));
      }

      await _storageService.deleteFile(pathToDelete);
      return right(null);
    } catch (e) {
      log('Error deleting photo: $e');
      return left(ServerFailure('Failed to delete photo'));
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
}
