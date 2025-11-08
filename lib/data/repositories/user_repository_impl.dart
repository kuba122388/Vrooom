import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:vrooom/data/models/user_model.dart';
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

  @override
  Future<Either<String, User>> getCurrentUserInformation() async {
    try {
      return Right(await userApiService.getCurrentUserInformation());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> editCurrentUser(UserModel request) async {
    try {
      return Right(await userApiService.editCurrentUser(request));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> uploadUserProfilePicture(int userId, File imageFile) async {
    try {
      await userApiService.uploadUserProfilePicture(userId, imageFile);

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Uint8List>> downloadUserProfilePicture(int userId) async {
    try {
      return Right(await userApiService.downloadUserProfilePicture(userId));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
