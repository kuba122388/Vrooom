import 'package:dio/dio.dart';
import 'package:vrooom/data/models/auth/login_response_model.dart';
import 'package:vrooom/data/models/auth/password_request_model.dart';
import 'package:vrooom/data/models/auth/register_request_model.dart';

import '../../models/auth/login_request_model.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception("Login failed");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Invalid email or password");
      }
      throw Exception("Network error ${e.message}");
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<LoginResponseModel> googleLogin(String token) async {
    try {
      final response = await _dio.post(
        '/api/auth/google',
        data: {'token': token},
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception("Google Login failed with status code ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Invalid Google token");
      }
      if (e.response?.statusCode == 500) {
        throw Exception("Server error during Google login. Check backend logs.");
      }
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<LoginResponseModel> facebookLogin(String token) async {
    try {
      final response = await _dio.post(
        '/api/auth/facebook',
        data: {'token': token},
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception("Facebook login failed with status code ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Invalid Facebook token");
      }
      if (e.response?.statusCode == 500) {
        throw Exception("Server error during Facebook login. Check backend logs.");
      }
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<String> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        if (response.statusCode == 200) {
          final message = response.data['message'] ?? "Registration successful";
          return message;
        }
      } else {
        throw Exception("Registration failed with status code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final message = e.response?.data?['message'] ?? "User with this email already exists.";
        throw Exception(message);
      }
      if (e.response?.statusCode == 500) {
        final message = e.response?.data?['message'] ?? "Error sending verification email.";
        throw Exception(message);
      }
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
    return "";
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/auth/logout');
    } catch (e) {
      throw "Logout failed: $e";
    }
  }

  Future<LoginResponseModel> verifyEmail(String code) async {
    try {
      final response = await _dio.post(
        '/api/auth/verify',
        data: {'code': code},
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception("Verification failed");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Invalid code');
      }
      throw Exception("Network error ${e.message}");
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> changePassword(PasswordRequestModel request) async {
    try {
      final response = await _dio.post(
        '/api/auth/change-password',
        data: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception("Login failed");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception("Old password is incorrect");
      }
      throw Exception("Network error ${e.message}");
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static List<String> validatePassword(String password) {
    List<String> errors = [];

    if (password.length < 8) {
      errors.add("Hasło musi mieć co najmniej 8 znaków");
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add("Hasło musi zawierać przynajmniej jedną wielką literę");
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add("Hasło musi zawierać przynajmniej jedną małą literę");
    }
    if (!password.contains(RegExp(r'\d'))) {
      errors.add("Hasło musi zawierać przynajmniej jedną cyfrę");
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add("Hasło musi zawierać przynajmniej jeden znak specjalny");
    }

    return errors;
  }
}
