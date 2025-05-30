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
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure('User not authenticated'));
      }

      if (currentUser.uid != userId) {
        return left(ServerFailure('Unauthorized access'));
      }

      log('Starting baby photo upload for user: $userId');

      // 🔥 رفع الصورة لـ baby-photos/babies/photos/ (same location as profile)
      final imageUrl = await storageService.uploadBabyPhoto(imageFile, userId);
      log('Baby photo uploaded successfully. URL: $imageUrl');

      // 🔥 التأكد من الحصول على آخر صورة (same location for both)
      final latestPhotoUrl = await storageService.getBabyPhotoUrl(userId);
      final finalImageUrl = latestPhotoUrl ?? imageUrl;

      log('Latest photo URL confirmed: $finalImageUrl');

      // حفظ الرابط في baby_questionnaires
      final saveResult = await saveBabyPhotoUrl(
        userId: userId,
        photoUrl: finalImageUrl,
      );
      if (saveResult.isLeft()) {
        log(
          'Warning: Photo uploaded but failed to save URL to baby_questionnaires',
        );
      }

      // 🔥 حفظ الرابط في users collection (same photo for both profile and baby)
      await _updateUserProfilePhoto(userId: userId, photoUrl: finalImageUrl);

      log('Photo process completed successfully for user: $userId');
      return right(finalImageUrl);
    } catch (e) {
      log('Error uploading photo: $e');
      return left(ServerFailure('Failed to upload photo: ${e.toString()}'));
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

      final docRef = firestore.collection('baby_questionnaires').doc(userId);
      final docSnapshot = await docRef.get();

      final updateData = {
        'babyPhotoUrl': photoUrl,
        'photoUpdatedAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (docSnapshot.exists) {
        await docRef.update(updateData);
        log('Photo URL updated in existing document for user: $userId');
      } else {
        updateData['isPartial'] = true;
        await docRef.set(updateData);
        log('Photo URL saved in new partial document for user: $userId');
      }

      return right(null);
    } catch (e) {
      log('Error saving photo URL: $e');
      return left(ServerFailure('Failed to save photo URL: ${e.toString()}'));
    }
  }

  // 🔥 دالة محدثة لتحديث صورة المستخدم (same location as baby photo)
  Future<void> _updateUserProfilePhoto({
    required String userId,
    required String? photoUrl,
  }) async {
    try {
      final userDocRef = firestore.collection('users').doc(userId);

      if (photoUrl != null) {
        // 🔥 التحقق مرة أخرى من آخر صورة (same location)
        final latestPhotoUrl = await storageService.getBabyPhotoUrl(userId);
        final finalPhotoUrl = latestPhotoUrl ?? photoUrl;

        await userDocRef.update({
          'photoUrl': finalPhotoUrl,
          'photoUpdatedAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        log('User profile photo updated successfully: $finalPhotoUrl');
      } else {
        await userDocRef.update({
          'photoUrl': FieldValue.delete(),
          'photoUpdatedAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        log('User profile photo deleted successfully');
      }
    } catch (e) {
      log('Error updating user profile photo: $e');
      // مانعملش throw عشان ماتأثرش على عملية الطفل
    }
  }

  // 🔥 دالة للحصول على آخر صورة (same location for both)
  Future<String?> _getLatestPhotoFromStorage(String userId) async {
    try {
      return await storageService.getBabyPhotoUrl(userId);
    } catch (e) {
      log('Error getting latest photo from storage: $e');
      return null;
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

      // 🔥 التأكد من الحصول على آخر صورة (same location)
      final latestPhotoUrl = await _getLatestPhotoFromStorage(userId);
      final finalPhotoUrl = latestPhotoUrl ?? data['babyPhotoUrl'];

      if (data['isPartial'] == true) {
        return right(
          BabyQuestionnaireEntity(
            babyPhotoUrl: finalPhotoUrl,
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
        final model = BabyQuestionnaireModel.fromJson(data);
        final entity = model.toEntity();
        // 🔥 تحديث الصورة بآخر نسخة
        final updatedEntity = entity.copyWith(babyPhotoUrl: finalPhotoUrl);
        return right(updatedEntity);
      }
    } catch (e) {
      log('Error getting partial questionnaire data: $e');
      return right(null);
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

      // 🔥 الحصول على آخر صورة (same location as profile)
      final latestPhotoUrl = await _getLatestPhotoFromStorage(userId);
      if (latestPhotoUrl != null) {
        log('Latest photo URL from storage: $latestPhotoUrl');
        return right(latestPhotoUrl);
      }

      // fallback: جرب من questionnaire data
      final partialResult = await getPartialQuestionnaireData(userId: userId);
      return partialResult.fold(
        (failure) => right(null),
        (questionnaire) => right(questionnaire?.babyPhotoUrl),
      );
    } catch (e) {
      log('Error getting photo URL: $e');
      return left(ServerFailure('Failed to get photo URL: ${e.toString()}'));
    }
  }

  bool _isDocumentEmptyOfUsefulData(Map<String, dynamic> data) {
    List<String> importantFields = [
      'babyName',
      'dateOfBirth',
      'relationship',
      'gender',
      'wasPremature',
      'weeksPremature',
      'diagnosedConditions',
      'careProviders',
      'hasMedicalContraindications',
      'contraindicationsDescription',
      'floorTimeDaily',
      'containerTimeDaily',
    ];

    for (String field in importantFields) {
      if (data.containsKey(field) && data[field] != null) {
        if (data[field] is List) {
          if ((data[field] as List).isNotEmpty) {
            return false;
          }
        } else if (data[field] is String) {
          if ((data[field] as String).trim().isNotEmpty) {
            return false;
          }
        } else if (data[field] is int) {
          if (data[field] != 0) {
            return false;
          }
        } else if (data[field] is bool) {
          return false;
        } else {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> _cleanupDocumentAfterPhotoDelete({
    required String userId,
    required DocumentReference docRef,
    required Map<String, dynamic> data,
  }) async {
    if (data['isPartial'] == true && _isDocumentEmptyOfUsefulData(data)) {
      await docRef.delete();
      log('Empty partial document deleted completely for user: $userId');
    } else {
      await docRef.update({
        'babyPhotoUrl': FieldValue.delete(),
        'photoUpdatedAt': FieldValue.serverTimestamp(),
      });
      log('Photo URL deleted from document for user: $userId');
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

      log('Starting photo deletion for user: $userId');

      // 🔥 حذف الصورة (same location for both profile and baby)
      try {
        await storageService.deleteBabyPhoto(userId);
        log('Photo deleted from storage for user: $userId');
      } catch (e) {
        log('Warning: Failed to delete photo from storage: $e');
      }

      // حذف من baby_questionnaires
      final docRef = firestore.collection('baby_questionnaires').doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        await _cleanupDocumentAfterPhotoDelete(
          userId: userId,
          docRef: docRef,
          data: data,
        );
      }

      // 🔥 حذف من users collection
      await _updateUserProfilePhoto(userId: userId, photoUrl: null);

      log('Photo deletion completed for user: $userId');
      return right(null);
    } catch (e) {
      log('Error deleting photo: $e');
      return left(ServerFailure('Failed to delete photo: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failures, bool>> hasBabyPhoto({required String userId}) async {
    try {
      // 🔥 التحقق من نفس المكان (unified location)
      final hasPhotoInStorage = await storageService.hasBabyPhoto(userId);
      if (hasPhotoInStorage) {
        return right(true);
      }

      // fallback: التحقق من Firestore
      final photoUrlResult = await getBabyPhotoUrl(userId: userId);
      return photoUrlResult.fold(
        (failure) => right(false),
        (photoUrl) => right(photoUrl != null && photoUrl.isNotEmpty),
      );
    } catch (e) {
      log('Error checking if photo exists: $e');
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

      // 🔥 التأكد من الحصول على آخر صورة قبل الحفظ
      final latestPhotoUrl = await _getLatestPhotoFromStorage(userId);
      final finalQuestionnaireData = questionnaireData.copyWith(
        babyPhotoUrl: latestPhotoUrl ?? questionnaireData.babyPhotoUrl,
      );

      final model = BabyQuestionnaireModel.fromEntity(finalQuestionnaireData);
      final data = model.toJson();

      data.remove('isPartial');
      data['completedAt'] = DateTime.now().toIso8601String();
      data['photoUpdatedAt'] = FieldValue.serverTimestamp();

      await firestore.collection('baby_questionnaires').doc(userId).set(data);

      // تحديث users collection
      if (finalQuestionnaireData.babyPhotoUrl != null) {
        await _updateUserProfilePhoto(
          userId: userId,
          photoUrl: finalQuestionnaireData.babyPhotoUrl,
        );
      }

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

      final data = docSnapshot.data()!;
      if (data['isPartial'] == true) {
        return left(ServerFailure('Questionnaire not completed yet'));
      }

      // 🔥 التأكد من آخر صورة
      final latestPhotoUrl = await _getLatestPhotoFromStorage(userId);
      if (latestPhotoUrl != null && latestPhotoUrl != data['babyPhotoUrl']) {
        data['babyPhotoUrl'] = latestPhotoUrl;
        log('Updated questionnaire data with latest photo URL');
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

      // 🔥 التأكد من آخر صورة
      final latestPhotoUrl = await _getLatestPhotoFromStorage(userId);
      final finalQuestionnaireData = questionnaireData.copyWith(
        babyPhotoUrl: latestPhotoUrl ?? questionnaireData.babyPhotoUrl,
      );

      final model = BabyQuestionnaireModel.fromEntity(finalQuestionnaireData);
      final data = model.toJson();

      data.remove('isPartial');
      data['photoUpdatedAt'] = FieldValue.serverTimestamp();

      await firestore
          .collection('baby_questionnaires')
          .doc(userId)
          .update(data);

      // تحديث users collection
      if (finalQuestionnaireData.babyPhotoUrl != null) {
        await _updateUserProfilePhoto(
          userId: userId,
          photoUrl: finalQuestionnaireData.babyPhotoUrl,
        );
      }

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
