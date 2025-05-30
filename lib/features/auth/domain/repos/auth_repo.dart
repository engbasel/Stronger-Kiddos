import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepo {
  // Authentication methods
  Future<Either<Failures, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name, [
    String? phoneNumber,
  ]);

  Future<Either<Failures, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Either<Failures, UserEntity>> signInWithGoogle();
  Future<Either<Failures, void>> sendPasswordResetLink(String email);

  // User data methods
  Future addUserData({required UserEntity user});
  Future<UserEntity> getUserData({required String uid});
  Future<void> updateUserData({required UserEntity user});

  // Profile image methods
  Future<Either<Failures, String>> uploadProfileImage({
    required File imageFile,
    required String userId,
  });

  Future<Either<Failures, void>> deleteProfileImage({required String userId});

  Future<Either<Failures, UserEntity>> updateUserProfileImage({
    required String userId,
    required String? profileImageUrl,
  });

  Future<Either<Failures, String?>> getUserProfileImageUrl({
    required String userId,
  });
}
