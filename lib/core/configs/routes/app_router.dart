import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/settings_widget.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/entities/user.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/presentation/admin/active_rental/active_rentals_page.dart';
import 'package:vrooom/presentation/admin/car_management/pages/add_new_car.dart';
import 'package:vrooom/presentation/admin/car_management/pages/car_management_details.dart';
import 'package:vrooom/presentation/admin/car_management/pages/car_management_page.dart';
import 'package:vrooom/presentation/admin/car_management/pages/edit_car_page.dart';
import 'package:vrooom/presentation/admin/discount_codes/pages/discount_codes_page.dart';
import 'package:vrooom/presentation/admin/future_reservation/pages/future_reservation_page.dart';
import 'package:vrooom/presentation/admin/manage_users/pages/manage_users_page.dart';
import 'package:vrooom/presentation/admin/car_management/pages/finalize_rental.dart';
import 'package:vrooom/presentation/admin/manage_users/pages/user_rental_history_page.dart';
import 'package:vrooom/presentation/admin/rental_history/pages/rental_history_page.dart';
import 'package:vrooom/presentation/user/auth/pages/change_password_page.dart';
import 'package:vrooom/presentation/user/auth/pages/email_verification_page.dart';
import 'package:vrooom/presentation/user/auth/pages/forgot_password_page.dart';
import 'package:vrooom/presentation/user/auth/pages/login_page.dart';
import 'package:vrooom/presentation/user/auth/pages/signup_page.dart';
import 'package:vrooom/presentation/user/auth/pages/verification_success_page.dart';
import 'package:vrooom/core/common/widgets/user_booking_details.dart';
import 'package:vrooom/presentation/user/listings/pages/booking_details_page.dart';
import 'package:vrooom/presentation/user/listings/pages/car_details_page.dart';
import 'package:vrooom/presentation/user/listings/pages/listings_page.dart';
import 'package:vrooom/presentation/user/listings/pages/payment_success_page.dart';
import 'package:vrooom/presentation/user/profile/pages/contact_page.dart';
import 'package:vrooom/presentation/user/profile/pages/edit_profile_details.dart';
import 'package:vrooom/presentation/user/profile/pages/privacy_policy_page.dart';
import 'package:vrooom/presentation/user/splash/pages/splash_page.dart';

import '../../../presentation/admin/admin_settings/pages/admin_settings.dart';
import '../../../presentation/user/main/pages/main_navigation_page.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case AppRoutes.signin:
        return MaterialPageRoute(builder: (_) => const LoginPage());

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
        final args = settings.arguments as Map<String, dynamic>?;
        final vehicleId = args?["vehicleId"] as int?;

        if(vehicleId == null || vehicleId <=0){
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invalid car ID')),
            ),
          );
        }

        return MaterialPageRoute(builder: (_) => CarDetailsPage(vehicleId: vehicleId));

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

      case AppRoutes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());

      case AppRoutes.userBookingDetails:
        final args = settings.arguments as Map<String, dynamic>;
        final booking = args['booking'] as Booking;
        final title = args['title'] as String;
        return MaterialPageRoute(builder: (_) => UserBookingDetails(booking: booking, title: title));

      case AppRoutes.userRentalHistory:
        final user = settings.arguments as User;
        return MaterialPageRoute(builder: (_) => UserRentalHistoryPage(user: user));

      case AppRoutes.carManagementDetail:
        final vehicle = settings.arguments as Vehicle;
        return MaterialPageRoute(builder: (_) => CarManagementDetail(vehicle: vehicle));

      case AppRoutes.editCar:
        final vehicle = settings.arguments as Vehicle;
        return MaterialPageRoute(builder: (_) => EditCarPage(vehicle: vehicle));

      case AppRoutes.bookingDetails:
        return MaterialPageRoute(builder: (_) => const BookingDetailsPage());

      case AppRoutes.editProfileDetails:
        return MaterialPageRoute(builder: (_) => const EditProfileDetails());

      case AppRoutes.carManagement:
        return MaterialPageRoute(builder: (_) => const CarManagementPage());

      case AppRoutes.finalizeRental:
        return MaterialPageRoute(builder: (_) => const FinalizeRentalPage());

      case AppRoutes.futureReservation:
        return MaterialPageRoute(builder: (_) => const FutureReservation());

      case AppRoutes.manageUsers:
        return MaterialPageRoute(builder: (_) => const ManageUsersPage());

      case AppRoutes.adminSettings:
        return MaterialPageRoute(builder: (_) => const AdminSettingsPage());

      case AppRoutes.settingsWidget:
        final popScreen = settings.arguments as bool;
        return MaterialPageRoute(builder: (_) => SettingsWidget(popScreen: popScreen));

      case AppRoutes.discountCodes:
        return MaterialPageRoute(builder: (_) => const DiscountCodesPage());

      case AppRoutes.rentalHistory:
        return MaterialPageRoute(builder: (_) => const RentalHistoryPage());

      case AppRoutes.activeRentals:
        return MaterialPageRoute(builder: (_) => const ActiveRentalsPage());

      case AppRoutes.contact:
        return MaterialPageRoute(builder: (_) => const ContactPage());
      case AppRoutes.addNewCar:
        return MaterialPageRoute(builder: (_) => const AddNewCar());

      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
      case AppRoutes.paymentSuccess:
        return MaterialPageRoute(builder: (_) => const PaymentSuccessPage());


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
