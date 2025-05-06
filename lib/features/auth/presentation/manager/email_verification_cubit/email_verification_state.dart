part of 'email_verification_cubit.dart';

abstract class EmailVerificationState extends Equatable {
  const EmailVerificationState();

  @override
  List<Object?> get props => [];
}

class EmailVerificationInitial extends EmailVerificationState {}

class CheckingVerification extends EmailVerificationState {}

class EmailVerified extends EmailVerificationState {}

class EmailNotVerified extends EmailVerificationState {}

class VerificationCheckFailed extends EmailVerificationState {
  final String message;

  const VerificationCheckFailed({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResendingVerificationEmail extends EmailVerificationState {}

class VerificationEmailSent extends EmailVerificationState {}

class ResendVerificationFailed extends EmailVerificationState {
  final String message;

  const ResendVerificationFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
