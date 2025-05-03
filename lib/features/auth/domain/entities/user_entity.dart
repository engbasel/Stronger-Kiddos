class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phoneNumber;
  final String? role;
  final DateTime? createdAt;
  final String? profileImageUrl;
  final bool isEmailVerified;
  final String userStat;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.createdAt,
    this.photoUrl,
    this.phoneNumber,
    this.profileImageUrl,
    this.isEmailVerified = false,
    this.userStat = 'active',
  });

  toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role,
      'createdAt': createdAt,
      'profileImageUrl': profileImageUrl,
      'isEmailVerified': isEmailVerified,
      'userStat': userStat,
    };
  }
}
