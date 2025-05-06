// ignore_for_file: file_names

class UserEntity {
  final String id;
  final String name;
  final String role;
  final DateTime createdAt;
  final String? email;
  final String? phoneNumber;
  final String? profileImageUrl;

  UserEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.createdAt,
    this.email,
    this.phoneNumber,
    this.profileImageUrl,
  });
}
