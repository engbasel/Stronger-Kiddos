import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/services/shared_preferences_sengleton.dart';
import '../../../../core/utils/backend_endpoint.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repos/auth_repo.dart';
import '../models/user_model.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;

  AuthRepoImpl({
    required this.databaseService,
    required this.firebaseAuthService,
  });

  @override
  @override
  Future<Either<Failures, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name, [
    String? phoneNumber, // Add optional parameter
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
        phoneNumber: phoneNumber, // Include phone number
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
  @override
  Future<Either<Failures, void>> sendPasswordResetLink(String email) async {
    try {
      // Directly use Firebase Auth - no need to check Firestore
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Return success (email will only be sent if the account exists)
      return right(null);
    } on FirebaseAuthException catch (e) {
      // These handle only technical errors (invalid email format, etc.),
      // not whether the user exists or not
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

  // Helper method to check if an email exists in the user database
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
    var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(AppConstants.kUserData, jsonData);
    log('User data saved successfully. UserData: $jsonData');
  }

  @override
  // In AuthRepoImpl.signInWithGoogle method
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
        // If user exists, fetch existing data and update phone number if needed
        var existingUser = await getUserData(uid: user.uid);
        if (phoneNumber != null &&
            (existingUser.phoneNumber == null ||
                existingUser.phoneNumber!.isEmpty)) {
          // Update user data with new phone number
          var updatedUserEntity = UserEntity(
            id: existingUser.id,
            name: existingUser.name,
            email: existingUser.email,
            phoneNumber: phoneNumber, // Update phone number
            role: existingUser.role,
            createdAt: existingUser.createdAt,
            photoUrl: existingUser.photoUrl,
            profileImageUrl: existingUser.profileImageUrl,
            isEmailVerified: existingUser.isEmailVerified,
            userStat: existingUser.userStat,
          );
          await updateUserData(user: updatedUserEntity);
          await saveUserData(user: updatedUserEntity);
          return right(updatedUserEntity);
        }
        await saveUserData(user: existingUser);
        return right(existingUser);
      } else {
        // For new users, include the phone number
        userEntity = UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL,
          phoneNumber: phoneNumber, // Include the phone number
          isEmailVerified: user.emailVerified,
          userStat: 'active',
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

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }
}
