import 'package:flutter/material.dart';
import 'package:vrooom/presentation/admin/car_management/pages/car_management_page.dart';
import 'package:vrooom/presentation/admin/car_management/pages/finalize_rental.dart';
import 'package:vrooom/presentation/user/auth/pages/email_verification_page.dart';
import 'package:vrooom/presentation/user/auth/pages/signin_page.dart';
import 'package:vrooom/presentation/user/auth/pages/signup_page.dart';
import 'package:vrooom/presentation/user/auth/pages/verification_success_page.dart';
import 'package:vrooom/presentation/user/listings/pages/booking_details_page.dart';
import 'package:vrooom/presentation/user/listings/pages/car_details_page.dart';
import 'package:vrooom/presentation/user/listings/pages/listings_page.dart';
import 'package:vrooom/presentation/user/profile/pages/edit_profile_details.dart';
import 'package:vrooom/presentation/user/splash/pages/splash_page.dart';

import '../../../presentation/user/main/pages/main_navigation_page.dart';
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

      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => const MainNavigationPage());

      case AppRoutes.verifyEmailSuccess:
        return MaterialPageRoute(builder: (_) => const VerificationSuccessPage());

      case AppRoutes.listings:
        return MaterialPageRoute(builder: (_) => const ListingsPage());

      case AppRoutes.carDetails:
        return MaterialPageRoute(builder: (_) => const CarDetailsPage());

      case AppRoutes.bookingDetails:
        return MaterialPageRoute(builder: (_) => const BookingDetailsPage());

      case AppRoutes.editProfileDetails:
        return MaterialPageRoute(builder: (_) => const EditProfileDetails());

      case AppRoutes.carManagement:
        return MaterialPageRoute(builder: (_) => const CarManagementPage());
      case AppRoutes.finalizeRental:
        return MaterialPageRoute(builder: (_) => const FinalizeRentalPage());

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
