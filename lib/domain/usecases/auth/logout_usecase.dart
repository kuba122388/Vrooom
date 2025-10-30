import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<String, void>> call() async {
    try {
      return await repository.logout();
    } catch (e) {
      return Left("Error: $e");
    }
  }
}
