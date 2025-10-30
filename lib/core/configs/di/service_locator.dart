import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vrooom/data/repositories/auth_repository_impl.dart';
import 'package:vrooom/data/sources/auth/auth_api_service.dart';
import 'package:vrooom/domain/repositories/auth_repository.dart';
import 'package:vrooom/domain/usecases/auth/login_usecase.dart';
import 'package:vrooom/domain/usecases/auth/logout_usecase.dart';
import 'package:vrooom/domain/usecases/auth/register_usecase.dart';

import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(DioClient.createDio());
  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl()));
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase(sl()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl()));
}
