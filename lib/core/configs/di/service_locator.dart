import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vrooom/data/repositories/auth_repository_impl.dart';
import 'package:vrooom/data/repositories/discount_code_repository_impl.dart';
import 'package:vrooom/data/repositories/payment_repository_impl.dart';
import 'package:vrooom/data/repositories/user_repository_impl.dart';
import 'package:vrooom/data/repositories/vehicle_repository_impl.dart';
import 'package:vrooom/data/sources/auth/auth_api_service.dart';
import 'package:vrooom/data/sources/auth/auth_storage.dart';
import 'package:vrooom/data/sources/discount_codes/discount_code_service.dart';
import 'package:vrooom/data/sources/payment/payment_service.dart';
import 'package:vrooom/data/sources/user/user_api_service.dart';
import 'package:vrooom/data/sources/vehicle/vehicle_api_service.dart';
import 'package:vrooom/domain/repositories/auth_repository.dart';
import 'package:vrooom/domain/repositories/discount_code_repository.dart';
import 'package:vrooom/domain/repositories/payment_repository.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';
import 'package:vrooom/domain/usecases/auth/change_password_usecase.dart';
import 'package:vrooom/domain/usecases/auth/facebook_login_usecase.dart';
import 'package:vrooom/domain/usecases/auth/google_login_usecase.dart';
import 'package:vrooom/domain/usecases/auth/login_usecase.dart';
import 'package:vrooom/domain/usecases/auth/logout_usecase.dart';
import 'package:vrooom/domain/usecases/auth/register_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_active_rentals_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_all_insurances_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_full_rental_history_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_recent_rentals_for_user_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_upcoming_rentals_usecase.dart';
import 'package:vrooom/domain/usecases/discount_codes/delete_discount_code_usecase.dart';
import 'package:vrooom/domain/usecases/discount_codes/update_discount_code_usecase.dart';
import 'package:vrooom/domain/usecases/payment/create_stripe_session_usecase.dart';
import 'package:vrooom/domain/usecases/user/delete_user_by_id_usecase.dart';
import 'package:vrooom/domain/usecases/user/download_user_profile_picture_usecase.dart';
import 'package:vrooom/domain/usecases/user/edit_current_user_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_all_users_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_current_user_information_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_active_rentals_by_id_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_active_rentals_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_id_by_email_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_rental_history_by_id_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_rental_history_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_upcoming_rentals_by_id_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_upcoming_rentals_usecase.dart';
import 'package:vrooom/domain/usecases/user/upload_user_profile_picture_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/add_new_vehicle_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_all_vehicles_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_available_vehicles_between_dates_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_all_vehicles_with_details_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_rental_locations_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_vehicle_details_usecase.dart';
import 'package:vrooom/data/repositories/booking_repository_impl.dart';
import 'package:vrooom/data/sources/booking/booking_api_service.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';
import 'package:vrooom/domain/usecases/vehicle/update_vehicle_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_vehicle_equipment_usecase.dart';
import '../../../domain/repositories/vehicle_repository.dart';
import '../../../domain/usecases/discount_codes/add_discount_code_usecase.dart';
import '../../../domain/usecases/discount_codes/get_all_discount_codes_usecase.dart';
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
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(),sl()));

  sl.registerSingleton<BookingApiService>(BookingApiService(sl()));
  sl.registerSingleton<BookingRepository>(BookingRepositoryImpl(sl()));

  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl()));
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase(sl()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl()));
  sl.registerSingleton<ChangePasswordUseCase>(ChangePasswordUseCase(sl()));
  sl.registerSingleton<GoogleLoginUseCase>(GoogleLoginUseCase(sl()));
  sl.registerSingleton<FacebookLoginUseCase>(FacebookLoginUseCase(sl()));

  sl.registerSingleton<VehicleApiService>(VehicleApiService(sl()));
  sl.registerSingleton<VehicleRepository>(VehicleRepositoryImpl(sl()));
  sl.registerSingleton<GetAllVehiclesUseCase>(GetAllVehiclesUseCase(sl()));
  sl.registerSingleton<GetVehicleDetailsUseCase>(GetVehicleDetailsUseCase(sl()));
  sl.registerSingleton<GetRentalLocationsUseCase>(GetRentalLocationsUseCase(sl()));

  sl.registerSingleton<GetVehicleEquipmentUseCase>(GetVehicleEquipmentUseCase(sl()));
  sl.registerSingleton<GetAvailableVehiclesBetweenDatesUseCase>(GetAvailableVehiclesBetweenDatesUseCase(sl()));

  sl.registerSingleton<GetAllVehiclesWithDetailsUseCase>(GetAllVehiclesWithDetailsUseCase(sl()));
  sl.registerSingleton<UpdateVehicleUseCase>(UpdateVehicleUseCase(sl()));

  sl.registerSingleton<DiscountCodeService>(DiscountCodeService(sl()));
  sl.registerSingleton<DiscountCodesRepository>(DiscountCodeRepositoryImpl(sl()));
  sl.registerSingleton<GetAllDiscountCodesUseCase>(GetAllDiscountCodesUseCase(sl()));
  sl.registerSingleton<AddDiscountCodeUseCase>(AddDiscountCodeUseCase(sl()));
  sl.registerSingleton<UpdateDiscountCodeUseCase>(UpdateDiscountCodeUseCase(sl()));
  sl.registerSingleton<DeleteDiscountCodeUseCase>(DeleteDiscountCodeUseCase(sl()));

  sl.registerSingleton<PaymentService>(PaymentService(sl()));
  sl.registerSingleton<PaymentRepository>(PaymentRepositoryImpl(sl()));
  sl.registerSingleton<CreateStripeSessionUseCase>(CreateStripeSessionUseCase(sl()));

  sl.registerSingleton<UserApiService>(UserApiService(sl()));
  sl.registerSingleton<UserRepository>(UserRepositoryImpl(sl()));
  sl.registerSingleton<GetAllUsersUsecase>(GetAllUsersUsecase(sl()));
  sl.registerSingleton<EditCurrentUserUseCase>(EditCurrentUserUseCase(sl()));
  sl.registerSingleton<GetCurrentUserInformationUseCase>(GetCurrentUserInformationUseCase(sl()));
  sl.registerSingleton<DeleteUserByIdUseCase>(DeleteUserByIdUseCase(sl()));
  sl.registerSingleton<UploadUserProfilePictureUseCase>(UploadUserProfilePictureUseCase(sl()));
  sl.registerSingleton<DownloadUserProfilePictureUseCase>(DownloadUserProfilePictureUseCase(sl()));
  sl.registerSingleton<GetUserActiveRentalsUseCase>(GetUserActiveRentalsUseCase(sl()));
  sl.registerSingleton<GetUserActiveRentalsByIdUseCase>(GetUserActiveRentalsByIdUseCase(sl()));
  sl.registerSingleton<GetUserUpcomingRentalsUseCase>(GetUserUpcomingRentalsUseCase(sl()));
  sl.registerSingleton<GetUserUpcomingRentalsByIdUseCase>(GetUserUpcomingRentalsByIdUseCase(sl()));
  sl.registerSingleton<GetUserRentalHistoryUseCase>(GetUserRentalHistoryUseCase(sl()));
  sl.registerSingleton<GetUserRentalHistoryByIdUseCase>(GetUserRentalHistoryByIdUseCase(sl()));
  sl.registerSingleton<GetUserIdByEmailUseCase>(GetUserIdByEmailUseCase(sl()));

  sl.registerSingleton<AddNewVehiclesUseCase>(AddNewVehiclesUseCase(sl()));
  sl.registerSingleton<GetAllInsurancesUseCase>(GetAllInsurancesUseCase(sl()));

  sl.registerSingleton<GetRecentRentalsForUserUseCase>(GetRecentRentalsForUserUseCase(sl()));
  sl.registerSingleton<GetFullRentalHistoryUseCase>(GetFullRentalHistoryUseCase(sl()));
  sl.registerSingleton<GetActiveRentalsUseCase>(GetActiveRentalsUseCase(sl()));
  sl.registerSingleton<GetUpcomingRentalsUseCase>(GetUpcomingRentalsUseCase(sl()));
}
