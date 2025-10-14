import 'package:flutter/material.dart';
import 'package:vrooom/presentation/auth/pages/email_verification_page.dart';
import 'package:vrooom/presentation/auth/pages/signin_page.dart';
import 'package:vrooom/presentation/auth/pages/signup_page.dart';
import 'package:vrooom/presentation/auth/pages/verification_success_page.dart';
import 'package:vrooom/presentation/listings/pages/listings_page.dart';
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

      case AppRoutes.verifyEmail:
        return MaterialPageRoute(builder: (_) => const EmailVerificationPage());

      case AppRoutes.verifyEmailSuccess:
        return MaterialPageRoute(builder: (_) => const VerificationSuccessPage());

      case AppRoutes.listings:
        return MaterialPageRoute(builder: (_) => const ListingsPage());

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
