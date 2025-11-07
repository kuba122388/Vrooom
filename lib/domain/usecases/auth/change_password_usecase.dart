import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<String, void>> call ({
    required String oldPassword,
    required String newPassword
  }) async {
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      return const Left("Old and new password are required");
    }

    return await repository.changePassword(oldPassword: oldPassword, newPassword: newPassword);
  }
}