import 'package:dio/dio.dart';
import 'package:strongerkiddos/core/utils/backend_endpoint.dart';

class AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSource(this.dio);
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      '${BackendEndpoints.baseUrl}${BackendEndpoints.loginEndpoint}',
      data: {'email': email, 'password': password},
    );
    return response.data;
  }
}
