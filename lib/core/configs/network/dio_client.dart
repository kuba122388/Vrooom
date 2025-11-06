import 'package:dio/dio.dart';



class DioClient {
  static Dio createDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.1.12:8080",
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return dio;
  }
}
