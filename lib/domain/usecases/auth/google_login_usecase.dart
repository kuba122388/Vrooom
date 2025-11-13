import 'package:dartz/dartz.dart';

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<Either<String, User>> call({
    required String token,
  }) async {
    if (token.isEmpty) {
      return const Left('Token is empty.');
    }
    return await repository.googleLogin(token: token);
  }
}
