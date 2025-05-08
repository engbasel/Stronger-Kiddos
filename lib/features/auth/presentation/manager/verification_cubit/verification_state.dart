// في lib/features/auth/presentation/manager/verification_cubit/verification_state.dart
import 'package:equatable/equatable.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object?> get props => [];
}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationPending extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class ResendVerificationEmailSuccess extends VerificationState {}

class VerificationFailure extends VerificationState {
  final String message;

  const VerificationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
