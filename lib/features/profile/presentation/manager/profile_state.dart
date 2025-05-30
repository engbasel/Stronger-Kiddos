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

// حالات الصورة - محدثة
class ProfilePhotoUploading extends ProfileState {}

class ProfilePhotoUploaded extends ProfileState {
  final UserEntity user;
  final String photoUrl;

  const ProfilePhotoUploaded({required this.user, required this.photoUrl});

  @override
  List<Object?> get props => [user, photoUrl];
}

class ProfilePhotoDeleting extends ProfileState {}

class ProfilePhotoDeleted extends ProfileState {
  final UserEntity user;

  const ProfilePhotoDeleted({required this.user});

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
