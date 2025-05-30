import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../auth/domain/repos/auth_repo.dart';
import '../../../questionnaires/domain/entities/baby_questionnaire_entity.dart';
import '../../../questionnaires/domain/repos/baby_questionnaire_repo.dart'; // إضافة
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepo authRepo;
  final FirebaseAuthService authService;
  final BabyQuestionnaireRepo questionnaireRepo; // إضافة

  ProfileCubit({
    required this.authRepo,
    required this.authService,
    required this.questionnaireRepo, // إضافة
  }) : super(ProfileInitial());

  // جلب بيانات المستخدم مع التحقق من صورة الطفل
  Future<void> loadUserProfile() async {
    emit(ProfileLoading());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      final userEntity = await authRepo.getUserData(uid: currentUser.uid);

      // إذا لم تكن هناك صورة في البروفايل، جرب جلب صورة الطفل
      if (userEntity.photoUrl == null || userEntity.photoUrl!.isEmpty) {
        await _syncBabyPhotoToProfile(currentUser.uid);

        // إعادة جلب البيانات بعد المزامنة
        final updatedUserEntity = await authRepo.getUserData(
          uid: currentUser.uid,
        );
        emit(ProfileLoaded(user: updatedUserEntity));
      } else {
        emit(ProfileLoaded(user: userEntity));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  // مزامنة صورة الطفل مع البروفايل
  Future<void> _syncBabyPhotoToProfile(String userId) async {
    try {
      final babyPhotoResult = await questionnaireRepo.getBabyPhotoUrl(
        userId: userId,
      );

      babyPhotoResult.fold(
        (failure) {
          // لا توجد صورة طفل، لا مشكلة
        },
        (babyPhotoUrl) async {
          if (babyPhotoUrl != null && babyPhotoUrl.isNotEmpty) {
            // نسخ صورة الطفل إلى البروفايل
            await authRepo.updateUserPhoto(
              userId: userId,
              photoUrl: babyPhotoUrl,
            );
          }
        },
      );
    } catch (e) {
      // فشل في المزامنة، لا مشكلة
    }
  }

  // رفع صورة جديدة للمستخدم وتحديث صورة الطفل أيضاً
  Future<void> uploadUserPhoto(File imageFile) async {
    emit(ProfilePhotoUploading());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      // 1. رفع الصورة للمستخدم
      final uploadResult = await authRepo.uploadUserPhoto(
        imageFile: imageFile,
        userId: currentUser.uid,
      );

      uploadResult.fold((failure) => emit(ProfileError(failure.message)), (
        imageUrl,
      ) async {
        // 2. تحديث بيانات المستخدم
        final updateUserResult = await authRepo.updateUserPhoto(
          userId: currentUser.uid,
          photoUrl: imageUrl,
        );

        updateUserResult.fold(
          (failure) => emit(ProfileError(failure.message)),
          (updatedUser) async {
            // 3. تحديث صورة الطفل أيضاً إذا كان هناك استبيان
            await _updateBabyPhotoIfExists(currentUser.uid, imageUrl);

            emit(ProfilePhotoUploaded(user: updatedUser, photoUrl: imageUrl));
          },
        );
      });
    } catch (e) {
      emit(ProfileError('Failed to upload photo: ${e.toString()}'));
    }
  }

  // تحديث صورة الطفل إذا كان الاستبيان موجود
  Future<void> _updateBabyPhotoIfExists(String userId, String photoUrl) async {
    try {
      final hasQuestionnaireResult = await questionnaireRepo
          .hasCompletedQuestionnaire(userId: userId);

      hasQuestionnaireResult.fold(
        (failure) {
          // فشل في التحقق، لا مشكلة
        },
        (hasQuestionnaire) async {
          if (hasQuestionnaire) {
            // الحصول على بيانات الاستبيان الحالية
            final questionnaireResult = await questionnaireRepo
                .getQuestionnaireData(userId: userId);

            questionnaireResult.fold(
              (failure) {
                // فشل في جلب الاستبيان، لا مشكلة
              },
              (questionnaire) async {
                // تحديث صورة الطفل
                final updatedQuestionnaire = questionnaire.copyWith(
                  babyPhotoUrl: photoUrl,
                );
                await questionnaireRepo.updateQuestionnaireData(
                  userId: userId,
                  questionnaireData: updatedQuestionnaire,
                );
              },
            );
          }
        },
      );
    } catch (e) {
      // فشل في التحديث، لا مشكلة
    }
  }

  // حذف صورة المستخدم وصورة الطفل
  Future<void> deleteUserPhoto() async {
    emit(ProfilePhotoDeleting());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      // 1. حذف الصورة من التخزين
      final deleteResult = await authRepo.deleteUserPhoto(
        userId: currentUser.uid,
      );

      deleteResult.fold((failure) => emit(ProfileError(failure.message)), (
        _,
      ) async {
        // 2. تحديث بيانات المستخدم (إزالة رابط الصورة)
        final updateUserResult = await authRepo.updateUserPhoto(
          userId: currentUser.uid,
          photoUrl: null,
        );

        updateUserResult.fold(
          (failure) => emit(ProfileError(failure.message)),
          (updatedUser) async {
            // 3. حذف صورة الطفل أيضاً إذا كان هناك استبيان
            await _updateBabyPhotoIfExists(currentUser.uid, '');

            emit(ProfilePhotoDeleted(user: updatedUser));
          },
        );
      });
    } catch (e) {
      emit(ProfileError('Failed to delete photo: ${e.toString()}'));
    }
  }

  // تحديث بيانات المستخدم الأساسية
  Future<void> updateUserInfo({String? name, String? phoneNumber}) async {
    emit(ProfileUpdating());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      // جلب البيانات الحالية
      final currentUserEntity = await authRepo.getUserData(
        uid: currentUser.uid,
      );

      // تحديث البيانات
      final updatedUser = currentUserEntity.copyWith(
        name: name ?? currentUserEntity.name,
        phoneNumber: phoneNumber ?? currentUserEntity.phoneNumber,
      );

      // حفظ التحديث
      await authRepo.updateUserData(user: updatedUser);

      emit(ProfileUpdated(user: updatedUser));
    } catch (e) {
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }

  // إعادة تحميل البيانات بعد التحديث
  Future<void> refreshProfile() async {
    await loadUserProfile();
  }
}

// إضافة copyWith إلى BabyQuestionnaireEntity إذا لم تكن موجودة
extension BabyQuestionnaireEntityExtension on BabyQuestionnaireEntity {
  BabyQuestionnaireEntity copyWith({
    String? babyPhotoUrl,
    String? babyName,
    DateTime? dateOfBirth,
    String? relationship,
    String? gender,
    bool? wasPremature,
    int? weeksPremature,
    List<String>? diagnosedConditions,
    List<String>? careProviders,
    bool? hasMedicalContraindications,
    String? contraindicationsDescription,
    String? floorTimeDaily,
    String? containerTimeDaily,
    DateTime? completedAt,
  }) {
    return BabyQuestionnaireEntity(
      babyPhotoUrl: babyPhotoUrl ?? this.babyPhotoUrl,
      babyName: babyName ?? this.babyName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      relationship: relationship ?? this.relationship,
      gender: gender ?? this.gender,
      wasPremature: wasPremature ?? this.wasPremature,
      weeksPremature: weeksPremature ?? this.weeksPremature,
      diagnosedConditions: diagnosedConditions ?? this.diagnosedConditions,
      careProviders: careProviders ?? this.careProviders,
      hasMedicalContraindications:
          hasMedicalContraindications ?? this.hasMedicalContraindications,
      contraindicationsDescription:
          contraindicationsDescription ?? this.contraindicationsDescription,
      floorTimeDaily: floorTimeDaily ?? this.floorTimeDaily,
      containerTimeDaily: containerTimeDaily ?? this.containerTimeDaily,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
