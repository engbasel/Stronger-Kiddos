import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? verificationId; // Add this for phone verification
  final int? resendToken; // Add this for phone verification

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.verificationId,
    this.resendToken,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? verificationId,
    int? resendToken,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId,
      resendToken: resendToken ?? this.resendToken,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    verificationId,
    resendToken,
  ];
}
