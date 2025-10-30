import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> login({
    required String email,
    required String password,
  });

  Future<Either<String, void>> logout();

  Future<Either<String, User>> register({
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
}
