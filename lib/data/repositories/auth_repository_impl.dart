import 'package:dartz/dartz.dart';
import 'package:vrooom/data/models/auth/login_request_model.dart';
import 'package:vrooom/data/models/auth/password_request_model.dart';
import 'package:vrooom/data/models/auth/register_request_model.dart';
import 'package:vrooom/data/sources/auth/auth_api_service.dart';
import 'package:vrooom/data/sources/auth/auth_storage.dart';
import 'package:vrooom/domain/entities/user.dart';
import 'package:vrooom/domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService authApiService;
  final AuthStorage tokenStorage;

  AuthRepositoryImpl(
    this.authApiService,
    this.tokenStorage,
  );

  @override
  Future<Either<String, User>> login({required String email, required String password}) async {
    try {
      final request = LoginRequestModel(email: email, password: password);
      final response = await authApiService.login(request);

      await tokenStorage.saveLoginData(response.jwt, response.user.customerID, response.user.role.toString());
      return Right(response.user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, User>> googleLogin({required String token}) async{
    try {
      final response = await authApiService.googleLogin(token);

      await tokenStorage.saveLoginData(response.jwt, response.user.customerID, response.user.role.toString());
      return Right(response.user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, User>> facebookLogin({required String token}) async{
    try {
      final response = await authApiService.facebookLogin(token);

      await tokenStorage.saveLoginData(response.jwt, response.user.customerID, response.user.role.toString());
      return Right(response.user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> changePassword({
    required String oldPassword,
    required String newPassword
  }) async {
    try {
      final request = PasswordRequestModel(oldPassword: oldPassword, newPassword: newPassword);
      await authApiService.changePassword(request);

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> resetPassword({required String email}) async {
    try {
      final result = await authApiService.resetPassword(email);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String,User>> verifyEmail({required String code})async {
    try {
      final response = await authApiService.verifyEmail(code);

      tokenStorage.saveLoginData(response.jwt, response.user.customerID,response.user.role.toString());
      return Right(response.user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      await authApiService.logout();
      await tokenStorage.clear();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
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
  }) async {
    try {
      final request = RegisterRequestModel(
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
      final response = await authApiService.register(request);
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> resendVerificationCode({required String email}) async {
    try {
      final message = await authApiService.resendVerificationCode(email);
      return Right(message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
