import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;

  const ProfileLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileImageUploading extends ProfileState {}

class ProfileImageUploaded extends ProfileState {
  final UserEntity user;
  final String imageUrl;

  const ProfileImageUploaded({required this.user, required this.imageUrl});

  @override
  List<Object?> get props => [user, imageUrl];
}

class ProfileImageDeleting extends ProfileState {}

class ProfileImageDeleted extends ProfileState {
  final UserEntity user;

  const ProfileImageDeleted({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final UserEntity user;

  const ProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}
