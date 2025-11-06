import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<String, List<User>>> getAllUsers();

  Future<Either<String, void>> deleteUserById(int userId);
}
