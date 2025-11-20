import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/domain/entities/user.dart';
import 'package:vrooom/domain/usecases/user/get_user_active_rentals_by_id_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_rental_history_by_id_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_upcoming_rentals_by_id_usecase.dart';

import '../../../../core/common/widgets/booking_car_tile.dart';
import '../../../../core/common/widgets/title_widget.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/routes/app_routes.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../domain/entities/booking.dart';

class UserRentalHistoryPage extends StatefulWidget {
  final User user;

  const UserRentalHistoryPage({super.key, required this.user});

  @override
  State<UserRentalHistoryPage> createState() => _UserRentalHistoryPageState();
}

class _UserRentalHistoryPageState extends State<UserRentalHistoryPage> {
  final GetUserActiveRentalsByIdUseCase _getUserActiveRentalsByIdUseCase = sl();
  final GetUserUpcomingRentalsByIdUseCase _getUserUpcomingRentalsByIdUseCase = sl();
  final GetUserRentalHistoryByIdUseCase _getUserRentalHistoryByIdUseCase = sl();

  List<Booking> _activeRentals = [];
  List<Booking> _penaltyRentals = [];
  List<Booking> _upcomingRentals = [];
  List<Booking> _rentalHistory = [];

  bool _isLoading = false;
  bool _nothingToShow = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final activeResult = await _getUserActiveRentalsByIdUseCase(userId: widget.user.customerID);
      if (!mounted) return;
      activeResult.fold((error) {}, (activeRentals) {
        setState(() => _activeRentals = activeRentals);
      });

      final upcomingResult =
          await _getUserUpcomingRentalsByIdUseCase(userId: widget.user.customerID);
      if (!mounted) return;
      upcomingResult.fold((error) {}, (upcomingRentals) {
        setState(() => _upcomingRentals = upcomingRentals);
      });

      final historyResult = await _getUserRentalHistoryByIdUseCase(userId: widget.user.customerID);
      if (!mounted) return;
      historyResult.fold((error) {}, (rentalHistory) {
        _rentalHistory = rentalHistory;
      });

      _penaltyRentals = _rentalHistory.where((booking) => booking.penalty != 0).toList();
      _rentalHistory = _rentalHistory.where((booking) => booking.penalty == 0).toList();

      if (_activeRentals.isEmpty &&
          _upcomingRentals.isEmpty &&
          _rentalHistory.isEmpty &&
          _penaltyRentals.isEmpty) {
        _nothingToShow = true;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: "${widget.user.name} ${widget.user.surname}"),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_nothingToShow) {
      return Scaffold(
        appBar: CustomAppBar(title: "${widget.user.name} ${widget.user.surname}"),
        body: Center(
          child: Text(
            "Nothing to show",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: AppColors.text.neutral200,
            ),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(title: "${widget.user.name} ${widget.user.surname}"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_penaltyRentals.isNotEmpty) ...[
                  const TitleWidget(title: "Penalty Section:"),
                  ..._penaltyRentals.map((item) => Column(
                        children: [
                          BookingCarTile(
                              booking: item,
                              onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.userBookingDetails, arguments: {
                                    'booking': item,
                                    'title': '${item.customerName} ${item.customerSurname}'
                                  })),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      )),
                ],
                if (_activeRentals.isNotEmpty) ...[
                  const TitleWidget(title: "Active Rentals:"),
                  ..._activeRentals.map((item) => Column(
                        children: [
                          BookingCarTile(
                              booking: item,
                              onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.userBookingDetails, arguments: {
                                    'booking': item,
                                    'title': '${item.customerName} ${item.customerSurname}'
                                  })),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      )),
                ],
                if (_upcomingRentals.isNotEmpty) ...[
                  const TitleWidget(title: "Upcoming Rentals:"),
                  ..._upcomingRentals.map((item) => Column(
                        children: [
                          BookingCarTile(
                              booking: item,
                              onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.userBookingDetails, arguments: {
                                    'booking': item,
                                    'title': '${item.customerName} ${item.customerSurname}'
                                  })),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      )),
                ],
                if (_rentalHistory.isNotEmpty) ...[
                  const TitleWidget(title: "Rentals History:"),
                  ..._rentalHistory.map((item) => Column(
                        children: [
                          BookingCarTile(
                              booking: item,
                              onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.userBookingDetails, arguments: {
                                    'booking': item,
                                    'title': '${item.customerName} ${item.customerSurname}'
                                  })),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      )),
                ],
              ],
            ),
          ),
        ));
  }
}
