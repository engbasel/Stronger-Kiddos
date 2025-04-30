class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phoneNumber;
  final bool isEmailVerified;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phoneNumber,
    this.isEmailVerified = false,
  });
}
