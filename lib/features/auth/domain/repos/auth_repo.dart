import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failures, UserEntity>> createUserWithEmailAndPassword(
    // ignore: non_constant_identifier_names
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
  Future addUserData({required UserEntity user});
  Future<UserEntity> getUserData({required String uid});
  Future<void> updateUserData({required UserEntity user});
  Future<Either<Failures, void>> resendVerificationEmail();
  Future<Either<Failures, bool>> checkEmailVerified();
}
