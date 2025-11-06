import 'package:dio/dio.dart';
import 'package:vrooom/data/models/user_model.dart';
import 'package:vrooom/data/sources/auth/auth_storage.dart';
import 'package:vrooom/domain/entities/user.dart';

class UserApiService {
  final Dio _dio;
  final String _userApi = "/api/customers";
  final String _authApi = '/api/auth';

  UserApiService(this._dio);

  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio.get("$_userApi/all");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => UserModel.fromJson(json)).toList();
        }
        throw Exception("Invalid response format - expected a list. ");
      } else {
        throw Exception("Received data about Users is not a list.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<void> deleteUserById(int userId) async {
    try {
      final response = await _dio.delete("$_userApi/delete/$userId");

      if (response.statusCode == 200) {
        return;
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<User> getCurrentUserInformation() async {
    try {
      final userId = await AuthStorage.getUserId();
      if (userId == null) {
        throw Exception("No userID in storage");
      }

      final response = await _dio.get("$_authApi/user/$userId");

      if (response.statusCode == 200) {
        final data = response.data;
        return UserModel.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception("Received data about Users is not a list.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<void> editCurrentUser(UserModel request) async {
    try {
      await _dio.put(
        '$_userApi/user/edit',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Invalid email or password");
      }
      throw Exception("Network error ${e.message}");
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
