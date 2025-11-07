import 'package:dio/dio.dart';
import 'package:vrooom/data/models/auth/login_response_model.dart';
import 'package:vrooom/data/models/auth/password_request_model.dart';
import 'package:vrooom/data/models/auth/register_request_model.dart';
import 'package:vrooom/data/models/auth/register_response_model.dart';

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

  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return RegisterResponseModel.fromJson(response.data);
      } else {
        throw Exception("Registration failed");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception("User with provided email already exists.");
      }
      throw Exception("Network error ${e.message}");
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/auth/logout');
    } catch (e) {
      throw "Logout failed: $e";
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
}
