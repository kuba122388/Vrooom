import 'package:dartz/dartz.dart';
import 'package:vrooom/data/sources/user/user_api_service.dart';
import 'package:vrooom/domain/entities/user.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserApiService userApiService;

  UserRepositoryImpl(this.userApiService);

  @override
  Future<Either<String, List<User>>> getAllUsers() async {
    try {
      return Right(await userApiService.getAllUsers());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteUserById(int userId) async {
    try {
      return Right(await userApiService.deleteUserById(userId));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
