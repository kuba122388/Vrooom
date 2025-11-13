import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrooom/core/common/widgets/splash_hero.dart';
import 'package:vrooom/presentation/auth/pages/login_page.dart';
import 'package:vrooom/presentation/splash/bloc/splash_cubit.dart';
import 'package:vrooom/presentation/splash/bloc/splash_state.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
              transitionDuration: const Duration(milliseconds: 1000),
            ),
          );
        } else if (state is AuthenticatedUser) {
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        } else if (state is AuthenticatedAdmin) {
          Navigator.pushReplacementNamed(context, AppRoutes.carManagement);
        }
      },
      child: const Scaffold(
        backgroundColor: AppColors.background,
        body: SplashHero(),
      ),
    );
  }
}
