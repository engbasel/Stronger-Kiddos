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
}
