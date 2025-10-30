import 'package:dartz/dartz.dart';

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<String, User>> call({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return const Left('Email and password are required');
    }
    return await repository.login(email: email, password: password);
  }
}
