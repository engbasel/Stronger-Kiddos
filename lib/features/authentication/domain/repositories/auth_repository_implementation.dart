import 'package:dio/dio.dart';
import 'package:strongerkiddos/core/network/network_info.dart';
import 'package:strongerkiddos/core/utils/backend_endpoint.dart';
import 'package:strongerkiddos/features/authentication/domain/entities/user.dart';
import 'package:strongerkiddos/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final Dio dio;
  AuthRepositoryImpl({required this.networkInfo, required this.dio});
  @override
  Future<User> getUserDetails(String id) async {
    if (await networkInfo.isConnected()) {
      final response = await dio.get(
        '${BackendEndpoints.baseUrl}${BackendEndpoints.getUserDetails}/$id',
      );
      return User(id: response.data['id'], name: response.data['name']);
    } else {
      throw Exception('No internet connection');
    }
  }
}
