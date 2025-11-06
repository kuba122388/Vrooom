import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vrooom/data/repositories/auth_repository_impl.dart';
import 'package:vrooom/data/repositories/user_repository_impl.dart';
import 'package:vrooom/data/repositories/vehicle_repository_impl.dart';
import 'package:vrooom/data/sources/auth/auth_api_service.dart';
import 'package:vrooom/data/sources/auth/auth_storage.dart';
import 'package:vrooom/data/sources/user/user_api_service.dart';
import 'package:vrooom/data/sources/vehicle/vehicle_api_service.dart';
import 'package:vrooom/domain/repositories/auth_repository.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';
import 'package:vrooom/domain/usecases/auth/login_usecase.dart';
import 'package:vrooom/domain/usecases/auth/logout_usecase.dart';
import 'package:vrooom/domain/usecases/auth/register_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_all_insurances_usecase.dart';
import 'package:vrooom/domain/usecases/user/delete_user_by_id_usecase.dart';
import 'package:vrooom/domain/usecases/user/edit_current_user_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_all_users_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_current_user_information_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/add_new_vehicle_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_all_vehicles_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_vehicle_details_usecase.dart';
import 'package:vrooom/data/repositories/booking_repository_impl.dart';
import 'package:vrooom/data/sources/booking/booking_api_service.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';
import '../../../domain/repositories/vehicle_repository.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ),
  );
  sl.registerSingleton<AuthStorage>(AuthStorage(sl()));
  sl.registerSingleton<Dio>(DioClient.createDio(sl()));
  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));

  sl.registerSingleton<VehicleApiService>(VehicleApiService(sl()));
  sl.registerSingleton<VehicleRepository>(VehicleRepositoryImpl(sl()));

  sl.registerSingleton<BookingApiService>(BookingApiService(sl()));
  sl.registerSingleton<BookingRepository>(BookingRepositoryImpl(sl()));


  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl()));
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase(sl()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl()));

  sl.registerSingleton<VehicleApiService>(VehicleApiService(sl()));
  sl.registerSingleton<VehicleRepository>(VehicleRepositoryImpl(sl()));
  sl.registerSingleton<GetAllVehiclesUseCase>(GetAllVehiclesUseCase(sl()));
  sl.registerSingleton<GetVehicleDetailsUseCase>(GetVehicleDetailsUseCase(sl()));

  sl.registerSingleton<UserApiService>(UserApiService(sl()));
  sl.registerSingleton<UserRepository>(UserRepositoryImpl(sl()));
  sl.registerSingleton<GetAllUsersUsecase>(GetAllUsersUsecase(sl()));
  sl.registerSingleton<EditCurrentUserUseCase>(EditCurrentUserUseCase(sl()));
  sl.registerSingleton<GetCurrentUserInformationUseCase>(GetCurrentUserInformationUseCase(sl()));
  sl.registerSingleton<DeleteUserByIdUseCase>(DeleteUserByIdUseCase(sl()));
  sl.registerSingleton<AddNewVehiclesUseCase>(AddNewVehiclesUseCase(sl()));
  sl.registerSingleton<GetAllInsurancesUseCase>(GetAllInsurancesUseCase(sl()));
}
