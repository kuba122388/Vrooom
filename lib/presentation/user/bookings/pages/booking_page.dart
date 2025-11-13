import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/title_widget.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/usecases/user/get_user_active_rentals_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_rental_history_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_upcoming_rentals_usecase.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/common/widgets/booking_car_tile.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final GetUserActiveRentalsUseCase _getUserActiveRentalsUseCase = sl();
  final GetUserUpcomingRentalsUseCase _getUserUpcomingRentalsUseCase = sl();
  final GetUserRentalHistoryUseCase _getUserRentalHistoryUseCase = sl();

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
      final activeResult = await _getUserActiveRentalsUseCase();
      activeResult.fold(
          (error) {},
          (activeRentals) {
            setState(() => _activeRentals = activeRentals);
          }
      );

      final upcomingResult = await _getUserUpcomingRentalsUseCase();
      upcomingResult.fold(
        (error) {},
        (upcomingRentals) {
          setState(() => _upcomingRentals = upcomingRentals);
        }
      );

      final historyResult = await _getUserRentalHistoryUseCase();
      historyResult.fold(
        (error) {},
        (rentalHistory) {
          _rentalHistory = rentalHistory;
        }
      );

      _penaltyRentals = _rentalHistory.where((booking) => booking.penalty != 0).toList();
      _rentalHistory = _rentalHistory.where((booking) => booking.penalty == 0).toList();

      if (_activeRentals.isEmpty && _upcomingRentals.isEmpty && _rentalHistory.isEmpty && _penaltyRentals.isEmpty) {
        _nothingToShow = true;
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_nothingToShow) {
      return Center(
        child: Text(
          "You don't have rental history",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: AppColors.text.neutral200,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_penaltyRentals.isNotEmpty) ...[
              const TitleWidget(title: "Penalty Section:"),
              ..._penaltyRentals.map((item) => Column(
                children: [
                  BookingCarTile(booking: item, onTap: () => Navigator.pushNamed(context, AppRoutes.userBookingDetails, arguments: {'booking' : item, 'title' : 'Booking details'})),
                  const SizedBox(height: AppSpacing.md),
                ],
              )),
            ],
            if (_activeRentals.isNotEmpty) ...[
              const TitleWidget(title: "Active Rentals:"),
              ..._activeRentals.map((item) => Column(
                children: [
                  BookingCarTile(booking: item, onTap: () => Navigator.pushNamed(context, AppRoutes.userBookingDetails, arguments: {'booking' : item, 'title' : 'Booking details'})),
                  const SizedBox(height: AppSpacing.md),
                ],
              )),
            ],
            if (_upcomingRentals.isNotEmpty) ...[
              const TitleWidget(title: "Upcoming Rentals:"),
              ..._upcomingRentals.map((item) => Column(
                children: [
                  BookingCarTile(booking: item, onTap: () => Navigator.pushNamed(context, AppRoutes.userBookingDetails, arguments: {'booking' : item, 'title' : 'Booking details'})),
                  const SizedBox(height: AppSpacing.md),
                ],
              )),
            ],
            if (_rentalHistory.isNotEmpty) ...[
              const TitleWidget(title: "Rentals History:"),
              ..._rentalHistory.map((item) => Column(
                children: [
                  BookingCarTile(booking: item, onTap: () => Navigator.pushNamed(context, AppRoutes.userBookingDetails, arguments: {'booking' : item, 'title' : 'Booking details'})),
                  const SizedBox(height: AppSpacing.md),
                ],
              )),
            ],
          ],
        ),
      ),
    );
  }
}
