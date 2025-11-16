import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<String, String>> call ({
    required String email
  }) async {
    if (email.isEmpty) {
      return const Left("Old and new password are required");
    }

    return await repository.resetPassword(email: email);
  }
}