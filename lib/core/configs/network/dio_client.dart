import 'package:dio/dio.dart';

import '../../../data/sources/auth/token_storage.dart';

class DioClient {
  static Dio createDio(TokenStorage tokenStorage) {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.1.106:8080",
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from secure storage
          final token = await tokenStorage.getToken();

          if (token != null && token.isNotEmpty) {
            // Add Authorization header
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - token expired or invalid
          if (error.response?.statusCode == 401) {
            // Clear invalid token
            await tokenStorage.deleteToken();

            // Optional: Navigate to login page
            // You can use a navigation service or event bus here
          }

          handler.next(error);
        },
      ),
    );

    // Logging interceptor
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }
}
