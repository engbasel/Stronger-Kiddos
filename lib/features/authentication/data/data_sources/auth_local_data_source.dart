import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strongerkiddos/core/errors/exceptions.dart';
import 'package:strongerkiddos/features/authentication/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getLastLoggedInUser();
  Future<void> clearUser();
  Future<bool> hasLoggedInUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  static const cashedUserKey = 'CACHED_USER';

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        cashedUserKey,
        json.encode(user.toJson()),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache user data');
    }
  }

  @override
  Future<UserModel> getLastLoggedInUser() async {
    try {
      final jsonString = sharedPreferences.getString(cashedUserKey);
      if (jsonString == null) {
        throw CacheException(message: 'No cached user found');
      }

      return UserModel.fromJson(json.decode(jsonString));
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve cached user data');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(cashedUserKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached user data');
    }
  }

  @override
  Future<bool> hasLoggedInUser() async {
    return sharedPreferences.containsKey(cashedUserKey);
  }
}
