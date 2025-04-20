import 'package:strongerkiddos/core/usecases/usecase.dart';
import 'package:strongerkiddos/features/authentication/domain/entities/user.dart';
import 'package:strongerkiddos/features/authentication/domain/repositories/auth_repository.dart';

class GetUserUseCase implements UseCase<User, String> {
  final AuthRepository repository;
  GetUserUseCase(this.repository);
  @override
  Future<User> call(String userId) async {
    return await repository.getUserDetails(userId);
  }
}
