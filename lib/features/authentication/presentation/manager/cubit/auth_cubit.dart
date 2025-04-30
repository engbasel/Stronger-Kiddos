import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/features/authentication/domain/repositories/auth_repository.dart';
import '../../../domain/entities/user_entity.dart';
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

    try {
      final result = await _authRepository.signInWithGoogle();

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (user) =>
            emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Google sign-in error: ${e.toString()}',
        ),
      );
    }
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

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onVerificationCompleted: (user) {
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      },
      onVerificationFailed: (error) {
        emit(state.copyWith(status: AuthStatus.error, errorMessage: error));
      },
      onCodeSent: (verificationId, resendToken) {
        emit(
          state.copyWith(
            status: AuthStatus.otpSent,
            verificationId: verificationId,
            resendToken: resendToken,
          ),
        );
      },
      onCodeAutoRetrievalTimeout: (verificationId) {
        // Only update verification ID if still in OTP sent state
        if (state.status == AuthStatus.otpSent) {
          emit(state.copyWith(verificationId: verificationId));
        }
      },
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) {}, // do nothing as state is already updated in callbacks
    );
  }

  Future<void> verifyOTP(String otp) async {
    if (state.verificationId == null) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Verification ID not found. Please try again.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.verifyOTP(
      verificationId: state.verificationId!,
      otp: otp,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> sendEmailVerification() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.sendEmailVerification();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          status:
              state.user != null
                  ? AuthStatus.authenticated
                  : AuthStatus.unauthenticated,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> checkEmailVerification() async {
    if (state.user == null) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.isEmailVerified();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (isVerified) {
        // Update the user entity with new verification status
        // This is just a simple approach - ideally you would have a proper way to update user properties
        final updatedUser = UserEntity(
          id: state.user!.id,
          name: state.user!.name,
          email: state.user!.email,
          photoUrl: state.user!.photoUrl,
          phoneNumber: state.user!.phoneNumber,
          isEmailVerified: isVerified,
        );

        emit(
          state.copyWith(status: AuthStatus.authenticated, user: updatedUser),
        );
      },
    );
  }
}
