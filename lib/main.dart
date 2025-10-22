import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrooom/core/configs/theme/app_theme.dart';
import 'package:vrooom/presentation/admin/car_management/pages/add_new_car.dart';
import 'package:vrooom/presentation/user/splash/bloc/splash_cubit.dart';

import 'core/configs/routes/app_router.dart';
import 'core/configs/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AddNewCar();
  }
}
