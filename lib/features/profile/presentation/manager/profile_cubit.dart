import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../auth/domain/repos/auth_repo.dart';
import '../../../questionnaires/domain/entities/baby_questionnaire_entity.dart';
import '../../../questionnaires/domain/repos/baby_questionnaire_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepo authRepo;
  final FirebaseAuthService authService;
  final BabyQuestionnaireRepo questionnaireRepo;

  ProfileCubit({
    required this.authRepo,
    required this.authService,
    required this.questionnaireRepo,
  }) : super(ProfileInitial());

  // 🔥 جلب بيانات المستخدم (unified photo location)
  Future<void> loadUserProfile() async {
    emit(ProfileLoading());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      final userEntity = await authRepo.getUserData(uid: currentUser.uid);

      // 🔥 التحقق من وجود صورة في المكان الموحد وتحديث البروفايل إذا لزم الأمر
      if (userEntity.photoUrl == null || userEntity.photoUrl!.isEmpty) {
        await _syncPhotoToProfile(currentUser.uid);

        // إعادة جلب البيانات بعد المزامنة
        emit(ProfileLoaded(user: userEntity));
      } else {
        emit(ProfileLoaded(user: userEntity));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  // 🔥 مزامنة الصورة مع البروفايل (same location for both)
  Future<void> _syncPhotoToProfile(String userId) async {
    try {
      final photoResult = await questionnaireRepo.getBabyPhotoUrl(
        userId: userId,
      );

      photoResult.fold(
        (failure) {
          // لا توجد صورة، لا مشكلة
        },
        (photoUrl) async {
          if (photoUrl != null && photoUrl.isNotEmpty) {
            // تحديث المستخدم ليشير لنفس الصورة (same location)
            await authRepo.updateUserPhoto(userId: userId, photoUrl: photoUrl);
          }
        },
      );
    } catch (e) {
      // فشل في المزامنة، لا مشكلة
    }
  }

  // 🔥 رفع صورة جديدة (ستذهب إلى المكان الموحد babies/photos/)
  Future<void> uploadUserPhoto(File imageFile) async {
    emit(ProfilePhotoUploading());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      // 1. رفع الصورة للمستخدم (ستذهب إلى babies/photos/ - unified location)
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

        updateUserResult.fold((failure) => emit(ProfileError(failure.message)), (
          updatedUser,
        ) async {
          // 3. تحديث صورة الطفل أيضاً إذا كان هناك استبيان (same photo, same location)
          await _updateBabyPhotoIfExists(currentUser.uid, imageUrl);

          emit(ProfilePhotoUploaded(user: updatedUser, photoUrl: imageUrl));
        });
      });
    } catch (e) {
      emit(ProfileError('Failed to upload photo: ${e.toString()}'));
    }
  }

  // 🔥 تحديث صورة الطفل إذا كان الاستبيان موجود (same location)
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
                // تحديث صورة الطفل (same photo URL, same location)
                final updatedQuestionnaire = questionnaire.copyWith(
                  babyPhotoUrl: photoUrl,
                );
                await questionnaireRepo.updateQuestionnaireData(
                  userId: userId,
                  questionnaireData: updatedQuestionnaire,
                );
              },
            );
          } else {
            // إذا لم يكن هناك استبيان كامل، جرب حفظ الصورة جزئياً
            await questionnaireRepo.saveBabyPhotoUrl(
              userId: userId,
              photoUrl: photoUrl,
            );
          }
        },
      );
    } catch (e) {
      // فشل في التحديث، لا مشكلة
    }
  }

  // 🔥 حذف الصورة (من المكان الموحد babies/photos/)
  Future<void> deleteUserPhoto() async {
    emit(ProfilePhotoDeleting());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      // 1. حذف الصورة من المكان الموحد (babies/photos/)
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
            // 3. حذف صورة الطفل أيضاً إذا كان هناك استبيان (same location)
            await _deleteBabyPhotoIfExists(currentUser.uid);

            emit(ProfilePhotoDeleted(user: updatedUser));
          },
        );
      });
    } catch (e) {
      emit(ProfileError('Failed to delete photo: ${e.toString()}'));
    }
  }

  // 🔥 حذف صورة الطفل إذا كان موجود (same location as profile)
  Future<void> _deleteBabyPhotoIfExists(String userId) async {
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
                // تحديث صورة الطفل لتكون فارغة
                final updatedQuestionnaire = questionnaire.copyWith(
                  babyPhotoUrl: null,
                );
                await questionnaireRepo.updateQuestionnaireData(
                  userId: userId,
                  questionnaireData: updatedQuestionnaire,
                );
              },
            );
          } else {
            // إذا لم يكن هناك استبيان كامل، جرب حذف الصورة الجزئية
            await questionnaireRepo.deleteBabyPhoto(userId: userId);
          }
        },
      );
    } catch (e) {
      // فشل في الحذف، لا مشكلة
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
