import 'package:dartz/dartz.dart';
import 'package:strongerkiddos/core/errors/exceptions.dart';
import 'package:strongerkiddos/core/errors/failures.dart';
import 'package:strongerkiddos/core/network/network_info.dart';
import 'package:strongerkiddos/features/authentication/domain/entities/user_entity.dart';
import 'package:strongerkiddos/features/authentication/domain/repositories/auth_repository.dart';
import '../../data/data_sources/auth_local_data_source.dart';
import '../../data/data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final user = await remoteDataSource.signInWithEmailAndPassword(
          email,
          password,
        );
        // Cache user data for offline access
        await localDataSource.cacheUser(user);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(AuthFailure(message: e.toString()));
      }
    } else {
      // Try to get cached user if we have one
      try {
        final cachedUser = await localDataSource.getLastLoggedInUser();
        return Right(cachedUser);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(
          NetworkFailure(message: 'No internet connection and no cached user'),
        );
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final user = await remoteDataSource.signUpWithEmailAndPassword(
          name,
          email,
          password,
        );
        // Cache user data for offline access
        await localDataSource.cacheUser(user);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(AuthFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    if (await networkInfo.isConnected()) {
      try {
        final user = await remoteDataSource.signInWithGoogle();
        // Cache user data for offline access
        await localDataSource.cacheUser(user);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(AuthFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    if (await networkInfo.isConnected()) {
      try {
        final user = await remoteDataSource.signInWithApple();
        // Cache user data for offline access
        await localDataSource.cacheUser(user);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(AuthFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearUser();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (await networkInfo.isConnected()) {
      try {
        await remoteDataSource.resetPassword(email);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(AuthFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      if (await networkInfo.isConnected()) {
        final isSignedIn = await remoteDataSource.isSignedIn();
        return Right(isSignedIn);
      } else {
        // Check if we have a cached user when offline
        final hasLoggedInUser = await localDataSource.hasLoggedInUser();
        return Right(hasLoggedInUser);
      }
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      if (await networkInfo.isConnected()) {
        final user = await remoteDataSource.getCurrentUser();
        if (user != null) {
          // Update cached user
          await localDataSource.cacheUser(user);
          return Right(user);
        } else {
          // Try to get cached user if no remote user
          try {
            final cachedUser = await localDataSource.getLastLoggedInUser();
            return Right(cachedUser);
          } on CacheException {
            return const Right(null);
          }
        }
      } else {
        // Try to get cached user when offline
        try {
          final cachedUser = await localDataSource.getLastLoggedInUser();
          return Right(cachedUser);
        } on CacheException {
          return const Right(null);
        }
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
