import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';

class AdminMenuItem {
  final String title;
  final String svgVector;
  final String route;

  const AdminMenuItem({
    required this.title,
    required this.svgVector,
    required this.route,
  });
}

class AdminMenuConfig {
  static List<AdminMenuItem> menuItems = [
    const AdminMenuItem(
      title: "Car Management",
      svgVector: AppVectors.car,
      route: AppRoutes.carManagement,
    ),
    const AdminMenuItem(
      title: "Rental History",
      svgVector: AppVectors.historyRental,
      route: AppRoutes.rentalHistory,
    ),
    const AdminMenuItem(
      title: "Active Rental Agreements",
      svgVector: AppVectors.activeRental,
      route: AppRoutes.activeRentals,
    ),
    const AdminMenuItem(
      title: "Future Rentals",
      svgVector: AppVectors.futureRental,
      route: AppRoutes.futureReservation,
    ),
    const AdminMenuItem(
      title: "Manage Users",
      svgVector: AppVectors.usersRound,
      route: AppRoutes.manageUsers,
    ),
    const AdminMenuItem(
      title: "Discount codes",
      svgVector: AppVectors.discount,
      route: AppRoutes.discountCodes,
    ),
    const AdminMenuItem(
      title: "Settings",
      svgVector: AppVectors.settings,
      route: AppRoutes.adminSettings
    )
  ];

  AdminMenuConfig._();
}
