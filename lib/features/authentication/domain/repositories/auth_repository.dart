import 'package:dartz/dartz.dart';
import 'package:strongerkiddos/core/errors/failures.dart';
import 'package:strongerkiddos/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, UserEntity>> signInWithApple();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required Function(UserEntity) onVerificationCompleted,
    required Function(String) onVerificationFailed,
    required Function(String, int?) onCodeSent,
    required Function(String) onCodeAutoRetrievalTimeout,
  });

  Future<Either<Failure, UserEntity>> verifyOTP({
    required String verificationId,
    required String otp,
  });
  Future<Either<Failure, void>> sendEmailVerification();
  Future<Either<Failure, bool>> isEmailVerified();
}
