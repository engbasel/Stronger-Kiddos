import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;

  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoginRequiresVerification extends LoginState {
  final String email;

  const LoginRequiresVerification({required this.email});

  @override
  List<Object?> get props => [email];
}

class GoogleLoginSuccess extends LoginState {
  final UserEntity user;

  const GoogleLoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AppleLoginSuccess extends LoginState {
  final UserEntity user;

  const AppleLoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoginOffline extends LoginState {
  final UserEntity? cachedUser;

  const LoginOffline({this.cachedUser});

  @override
  List<Object?> get props => [cachedUser];
}

class PasswordResetEmailSent extends LoginState {}
