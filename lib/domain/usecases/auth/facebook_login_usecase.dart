import 'package:dartz/dartz.dart';

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class FacebookLoginUseCase {
  final AuthRepository repository;

  FacebookLoginUseCase(this.repository);

  Future<Either<String, User>> call({
    required String token,
  }) async {
    if (token.isEmpty) {
      return const Left('Token is empty.');
    }
    return await repository.facebookLogin(token: token);
  }
}
