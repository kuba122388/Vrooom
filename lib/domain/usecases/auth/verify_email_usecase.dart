import 'package:dartz/dartz.dart';

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Either<String, User>> call({
    required String code,
  }) async {
    if (code.isEmpty) {
      return const Left('Token is empty.');
    }
    return await repository.verifyEmail(code: code);
  }
}