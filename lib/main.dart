import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrooom/core/configs/theme/app_theme.dart';
import 'package:vrooom/domain/usecases/auth/logout_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_current_user_information_usecase.dart';
import 'package:vrooom/presentation/splash/bloc/splash_cubit.dart';

import 'core/configs/di/service_locator.dart';
import 'core/configs/routes/app_router.dart';
import 'core/configs/routes/app_routes.dart';
import 'data/sources/auth/auth_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  final CheckUserInformation checkUserInformation = CheckUserInformation();
  checkUserInformation.check();
  runApp(const MyApp());
}

class CheckUserInformation {
  final GetCurrentUserInformationUseCase _getCurrentUserInformationUseCase = sl();
  final LogoutUseCase _logoutUseCase = sl();

  Future<void> check() async {
    final result = await _getCurrentUserInformationUseCase();

    result.fold(
      (error) {},
      (user) async {
        if (user.country.isEmpty || user.phoneNumber.isEmpty || user.streetAddress.isEmpty) {
          await _logoutUseCase();
        }
      }
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(
        authStorage: sl<AuthStorage>(),
      )..appStarted(),
      child: MaterialApp(
        theme: AppTheme.appTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
