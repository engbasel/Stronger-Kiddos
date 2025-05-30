import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../auth/domain/repos/auth_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepo authRepo;
  final FirebaseAuthService authService;

  ProfileCubit({required this.authRepo, required this.authService})
    : super(ProfileInitial());

  // جلب بيانات المستخدم الحالي
  Future<void> loadUserProfile() async {
    emit(ProfileLoading());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      final userEntity = await authRepo.getUserData(uid: currentUser.uid);
      emit(ProfileLoaded(user: userEntity));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  // رفع صورة بروفايل جديدة
  Future<void> uploadProfileImage(File imageFile) async {
    emit(ProfileImageUploading());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      // رفع الصورة
      final uploadResult = await authRepo.uploadProfileImage(
        imageFile: imageFile,
        userId: currentUser.uid,
      );

      uploadResult.fold((failure) => emit(ProfileError(failure.message)), (
        imageUrl,
      ) async {
        // تحديث بيانات المستخدم
        final updateResult = await authRepo.updateUserProfileImage(
          userId: currentUser.uid,
          profileImageUrl: imageUrl,
        );

        updateResult.fold(
          (failure) => emit(ProfileError(failure.message)),
          (updatedUser) =>
              emit(ProfileImageUploaded(user: updatedUser, imageUrl: imageUrl)),
        );
      });
    } catch (e) {
      emit(ProfileError('Failed to upload image: ${e.toString()}'));
    }
  }

  // حذف صورة البروفايل
  Future<void> deleteProfileImage() async {
    emit(ProfileImageDeleting());

    try {
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      // حذف الصورة من التخزين
      final deleteResult = await authRepo.deleteProfileImage(
        userId: currentUser.uid,
      );

      deleteResult.fold((failure) => emit(ProfileError(failure.message)), (
        _,
      ) async {
        // تحديث بيانات المستخدم (إزالة رابط الصورة)
        final updateResult = await authRepo.updateUserProfileImage(
          userId: currentUser.uid,
          profileImageUrl: null,
        );

        updateResult.fold(
          (failure) => emit(ProfileError(failure.message)),
          (updatedUser) => emit(ProfileImageDeleted(user: updatedUser)),
        );
      });
    } catch (e) {
      emit(ProfileError('Failed to delete image: ${e.toString()}'));
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
