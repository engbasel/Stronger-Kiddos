class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? photoUrl; // صورة المستخدم الوحيدة (من Google أو مرفوعة يدوياً)
  final String? phoneNumber;
  final String? role;
  final DateTime? createdAt;
  final bool isEmailVerified;
  final String userStat;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.createdAt,
    this.photoUrl, // حقل واحد فقط للصورة
    this.phoneNumber,
    this.isEmailVerified = false,
    this.userStat = 'active',
  });

  // نسخة محدثة من المستخدم
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? role,
    DateTime? createdAt,
    bool? isEmailVerified,
    String? userStat,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl, // استخدام حقل واحد
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
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
      'photoUrl': photoUrl, // حقل واحد فقط
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
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
      photoUrl: map['photoUrl'], // حقل واحد فقط
      role: map['role'] ?? 'user',
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      isEmailVerified: map['isEmailVerified'] ?? false,
      userStat: map['userStat'] ?? 'active',
    );
  }
}
