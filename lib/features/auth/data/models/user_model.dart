import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
    super.phoneNumber,
    super.role,
    super.createdAt,
    super.profileImageUrl,
    super.isEmailVerified,
    super.userStat,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      phoneNumber: json['phoneNumber'],
      role: json['role'] ?? 'user',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      profileImageUrl: json['profileImageUrl'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      userStat: json['userStat'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'isEmailVerified': isEmailVerified,
      'userStat': userStat,
    };
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
      phoneNumber: user.phoneNumber,
      role: user.role,
      createdAt: user.createdAt,
      profileImageUrl: user.profileImageUrl,
      isEmailVerified: user.isEmailVerified,
      userStat: user.userStat,
    );
  }

  factory UserModel.fromFirebaseUser(User user, {String? phoneNumber}) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      phoneNumber: phoneNumber ?? user.phoneNumber,
      role: 'user',
      createdAt: DateTime.now(),
      isEmailVerified: user.emailVerified,
      userStat: user.emailVerified ? 'active' : 'inactive',
    );
  }

  // نسخة محدثة من النموذج
  @override
  UserModel copyWith({
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
    return UserModel(
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
}
