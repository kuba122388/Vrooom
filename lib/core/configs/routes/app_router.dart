import 'package:flutter/material.dart';
import 'package:vrooom/presentation/auth/pages/signin_page.dart';
import 'package:vrooom/presentation/auth/pages/signup_page.dart';
import 'package:vrooom/presentation/splash/pages/splash_page.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case AppRoutes.signin:
        return MaterialPageRoute(builder: (_) => const SigninPage());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}