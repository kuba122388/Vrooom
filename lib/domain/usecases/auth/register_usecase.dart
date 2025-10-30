import 'package:dartz/dartz.dart';

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<String, User>> call({
    required String name,
    required String surname,
    required String email,
    required String password,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String postalCode,
    required String country,
  }) async {
    if (name.isEmpty ||
        surname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phoneNumber.isEmpty ||
        streetAddress.isEmpty ||
        city.isEmpty ||
        postalCode.isEmpty ||
        country.isEmpty) {
      return const Left("Error: All fields must be filled");
    }
    return repository.register(
      name: name,
      surname: surname,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      streetAddress: streetAddress,
      city: city,
      postalCode: postalCode,
      country: country,
    );
  }
}
