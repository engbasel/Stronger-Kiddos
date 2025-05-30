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

  // صورة المستخدم - حقل واحد فقط
  Future<Either<Failures, String>> uploadUserPhoto({
    required File imageFile,
    required String userId,
  });

  Future<Either<Failures, void>> deleteUserPhoto({required String userId});

  Future<Either<Failures, UserEntity>> updateUserPhoto({
    required String userId,
    required String? photoUrl,
  });

  Future<Either<Failures, String?>> getUserPhotoUrl({required String userId});
}
