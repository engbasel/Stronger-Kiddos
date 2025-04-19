import 'package:strongerkiddos/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> getUserDetails(String id);
}
