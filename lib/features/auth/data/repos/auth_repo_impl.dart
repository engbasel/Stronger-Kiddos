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
  Future<Either<Failures, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
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
      log(
        'Exception in AuthRepoImpl.createUserWithEmailAndPassword: ${e.toString()}',
      );
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
      final emailExists = await isEmailExists(email);
      if (!emailExists) {
        return left(ServerFailure('Email not found. Please register first.'));
      }

      // إرسال رابط إعادة تعيين كلمة المرور
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure(e.message ?? 'Invalid email address.'));
    } catch (e) {
      log('Error in sendPasswordResetLink: ${e.toString()}');
      return left(ServerFailure('An error occurred. Please try again later.'));
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

  Future<bool> isEmailExists(String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();

      var userEntity = UserModel.fromFirebaseUser(user);
      var isUserExist = await databaseService.checkIfDatatExists(
        path: BackendEndpoint.isUserExists,
        docuementId: user.uid,
      );
      if (isUserExist) {
        await getUserData(uid: user.uid);
        await saveUserData(user: userEntity);
      } else {
        await addUserData(user: userEntity);
      }
      return right(userEntity);
    } catch (e) {
      await deleteUser(user);
      log('Exception in AuthRepoImpl.signInWithGoogle :${e.toString()}');
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
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
