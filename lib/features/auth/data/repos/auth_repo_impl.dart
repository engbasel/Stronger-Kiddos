import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/services/shared_preferences_sengleton.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/backend_endpoint.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repos/auth_repo.dart';
import '../models/user_model.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;
  final StorageService storageService;

  AuthRepoImpl({
    required this.databaseService,
    required this.firebaseAuthService,
    required this.storageService,
  });

  @override
  Future<Either<Failures, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name, [
    String? phoneNumber,
  ]) async {
    User? user;

    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userEntity = UserEntity(
        name: name,
        email: email,
        id: user.uid,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        role: 'user',
      );
      await addUserData(user: userEntity);
      await saveUserData(user: userEntity);

      return right(userEntity);
    } on CustomExceptions catch (e) {
      await deleteUser(user);
      return left(ServerFailure(e.message));
    } catch (e) {
      await deleteUser(user);
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
  }

  @override
  Future addUserData({required UserEntity user}) {
    return databaseService.addData(
      path: BackendEndpoint.addUserData,
      data: user.toMap(),
      docuementId: user.id,
    );
  }

  @override
  Future<Either<Failures, void>> sendPasswordResetLink(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return left(ServerFailure('Invalid email format.'));
      } else if (e.code == 'too-many-requests') {
        return left(
          ServerFailure('Too many requests. Please try again later.'),
        );
      }
      return left(ServerFailure(e.message ?? 'Invalid email address.'));
    } catch (e) {
      log('Error in sendPasswordResetLink: ${e.toString()}');
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
  }

  Future<bool> isEmailExists(String email) async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final querySnapshot =
          await usersCollection.where('email', isEqualTo: email).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log('Error checking if email exists: ${e.toString()}');
      return false;
    }
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    var userData = await databaseService.getData(
      path: BackendEndpoint.getUserData,
      docuementId: uid,
    );

    return UserModel.fromJson(userData);
  }

  Future<void> saveUserData({required UserEntity user}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(user).toJson());
    await Prefs.setString(AppConstants.kUserData, jsonData);
    log('User data saved successfully. UserData: $jsonData');
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithGoogle([
    String? phoneNumber,
  ]) async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();

      var userEntity = UserModel.fromFirebaseUser(
        user,
        phoneNumber: phoneNumber,
      );
      var isUserExist = await databaseService.checkIfDatatExists(
        path: BackendEndpoint.isUserExists,
        docuementId: user.uid,
      );

      if (isUserExist) {
        var existingUser = await getUserData(uid: user.uid);
        if (phoneNumber != null &&
            (existingUser.phoneNumber == null ||
                existingUser.phoneNumber!.isEmpty)) {
          var updatedUserEntity = existingUser.copyWith(
            phoneNumber: phoneNumber,
          );
          await updateUserData(user: updatedUserEntity);
          await saveUserData(user: updatedUserEntity);
          return right(updatedUserEntity);
        }
        await saveUserData(user: existingUser);
        return right(existingUser);
      } else {
        userEntity = UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL,
          phoneNumber: phoneNumber,
          isEmailVerified: user.emailVerified,
          userStat: 'active',
          createdAt: DateTime.now(),
          role: 'user',
        );
        await addUserData(user: userEntity);
        await saveUserData(user: userEntity);
      }
      return right(userEntity);
    } catch (e) {
      await deleteUser(user);
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
  }

  @override
  Future<void> updateUserData({required UserEntity user}) {
    return databaseService.updateData(
      path: BackendEndpoint.addUserData,
      docuementId: user.id,
      data: user.toMap(),
    );
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userEntity = await getUserData(uid: user.uid);
      await saveUserData(user: userEntity);
      return right(userEntity);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signInWithEmailAndPassword :${e.toString()}',
      );
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
  }

  // Profile image methods implementation
  @override
  Future<Either<Failures, String>> uploadProfileImage({
    required File imageFile,
    required String userId,
  }) async {
    try {
      log('Starting profile image upload for user: $userId');

      final imageUrl = await storageService.uploadUserProfileImage(
        imageFile,
        userId,
      );

      log('Profile image uploaded successfully. URL: $imageUrl');
      return right(imageUrl);
    } catch (e) {
      log('Error uploading profile image: $e');
      return left(
        ServerFailure('Failed to upload profile image: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, void>> deleteProfileImage({
    required String userId,
  }) async {
    try {
      await storageService.deleteUserProfileImage(userId);
      return right(null);
    } catch (e) {
      log('Error deleting profile image: $e');
      return left(
        ServerFailure('Failed to delete profile image: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, UserEntity>> updateUserProfileImage({
    required String userId,
    required String? profileImageUrl,
  }) async {
    try {
      // جلب بيانات المستخدم الحالية
      final currentUser = await getUserData(uid: userId);

      // تحديث صورة البروفايل
      final updatedUser = currentUser.copyWith(
        profileImageUrl: profileImageUrl,
      );

      // حفظ التحديث في قاعدة البيانات
      await updateUserData(user: updatedUser);

      // تحديث البيانات المحفوظة محلياً
      await saveUserData(user: updatedUser);

      log('User profile image updated successfully');
      return right(updatedUser);
    } catch (e) {
      log('Error updating user profile image: $e');
      return left(
        ServerFailure('Failed to update profile image: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failures, String?>> getUserProfileImageUrl({
    required String userId,
  }) async {
    try {
      final imageUrl = await storageService.getUserProfileImageUrl(userId);
      return right(imageUrl);
    } catch (e) {
      log('Error getting user profile image URL: $e');
      return left(
        ServerFailure('Failed to get profile image URL: ${e.toString()}'),
      );
    }
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }
}
