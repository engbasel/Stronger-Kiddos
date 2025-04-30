import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/features/authentication/domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState());

  Future<void> checkAuth() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final isSignedInResult = await _authRepository.isSignedIn();

    isSignedInResult.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (isSignedIn) async {
        if (isSignedIn) {
          final userResult = await _authRepository.getCurrentUser();

          userResult.fold(
            (failure) => emit(
              state.copyWith(
                status: AuthStatus.error,
                errorMessage: failure.message,
              ),
            ),
            (user) {
              if (user != null) {
                emit(
                  state.copyWith(status: AuthStatus.authenticated, user: user),
                );
              } else {
                emit(state.copyWith(status: AuthStatus.unauthenticated));
              }
            },
          );
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signInWithEmailAndPassword(
      email,
      password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signUpWithEmailAndPassword(
      name,
      email,
      password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signInWithGoogle();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> signInWithApple() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signInWithApple();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
    );
  }

  Future<void> resetPassword(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.resetPassword(email);

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(
        state.copyWith(status: state.status),
      ), // Keep current auth status
    );
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
