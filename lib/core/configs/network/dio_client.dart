import 'package:dio/dio.dart';
import 'package:vrooom/core/configs/network/network_config.dart';

import '../../../data/sources/auth/auth_storage.dart';

class DioClient {
  static Dio createDio(AuthStorage tokenStorage) {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: NetworkConfig.ip,
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
          final token = await tokenStorage.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await tokenStorage.clear();

            // Navigate to login page
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
