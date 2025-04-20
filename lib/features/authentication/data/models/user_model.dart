import 'package:strongerkiddos/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.name});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
