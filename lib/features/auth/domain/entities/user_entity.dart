class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? photoUrl; // من Google Auth
  final String? phoneNumber;
  final String? role;
  final DateTime? createdAt;
  final String? profileImageUrl; // صورة البروفايل المحملة يدوياً
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

  // طريقة لجلب أفضل صورة متاحة
  String? get bestAvailableImageUrl {
    // أولوية للصورة المحملة يدوياً، ثم صورة Google
    return profileImageUrl?.isNotEmpty == true ? profileImageUrl : photoUrl;
  }

  // نسخة محدثة من المستخدم
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? role,
    DateTime? createdAt,
    String? profileImageUrl,
    bool? isEmailVerified,
    String? userStat,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      userStat: userStat ?? this.userStat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'isEmailVerified': isEmailVerified,
      'userStat': userStat,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      role: map['role'] ?? 'user',
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      profileImageUrl: map['profileImageUrl'],
      isEmailVerified: map['isEmailVerified'] ?? false,
      userStat: map['userStat'] ?? 'active',
    );
  }
}
