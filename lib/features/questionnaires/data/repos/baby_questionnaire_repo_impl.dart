import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import '../../../../core/errors/failures.dart';
import '../models/baby_questionnaire_model.dart';
import '../../domain/entities/baby_questionnaire_entity.dart';
import '../../domain/repos/baby_questionnaire_repo.dart';

class BabyQuestionnaireRepoImpl implements BabyQuestionnaireRepo {
  SupabaseClient get supabase => Supabase.instance.client;
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @override
  Future<Either<Failures, String>> uploadBabyPhoto(File imageFile) async {
    try {
      // Check if user is authenticated
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      final fileName =
          'baby_photos/${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from('baby-photos').upload(fileName, imageFile);

      final publicUrl = supabase.storage
          .from('baby-photos')
          .getPublicUrl(fileName);

      return right(publicUrl);
    } catch (e) {
      log('Error uploading baby photo: $e');
      return left(ServerFailure('Failed to upload baby photo'));
    }
  }

  @override
  Future<Either<Failures, void>> saveQuestionnaireData({
    required String userId,
    required BabyQuestionnaireEntity questionnaireData,
  }) async {
    try {
      // Check if user is authenticated
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      // Verify user is trying to save their own data
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
      // Check if user is authenticated
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      // Verify user is trying to access their own data
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
      // Check if user is authenticated
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        log('User not authenticated when checking questionnaire completion');
        return left(ServerFailure('User not authenticated'));
      }

      // Verify user is checking their own data
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
