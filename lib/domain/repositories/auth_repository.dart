import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> login({
    required String email,
    required String password,
  });

  Future<Either<String, User>> googleLogin({required String token});

  Future<Either<String, User>> facebookLogin({required String token});

  Future<Either<String, void>> logout();


  Future<Either<String,User>> verifyEmail({required String code});

  Future<Either<String, String>> register({
    required String name,
    required String surname,
    required String email,
    required String password,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String postalCode,
    required String country,
  });

  Future<Either<String, void>> changePassword(
      {required String oldPassword, required String newPassword});
}
