import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class EmailSignupSuccess extends SignupState {
  final UserEntity user;

  const EmailSignupSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class GoogleSignupSuccess extends SignupState {
  final UserEntity user;

  const GoogleSignupSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AppleSignupSuccess extends SignupState {
  final UserEntity user;

  const AppleSignupSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class PhoneVerificationSent extends SignupState {
  final String verificationId;

  const PhoneVerificationSent({required this.verificationId});

  @override
  List<Object?> get props => [verificationId];
}

class PhoneSignupSuccess extends SignupState {
  final UserEntity user;

  const PhoneSignupSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignupFailure extends SignupState {
  final String message;

  const SignupFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
