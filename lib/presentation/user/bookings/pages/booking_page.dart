import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/core/common/widgets/title_widget.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/enums/rental_status.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/usecases/user/get_user_active_rentals_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_rental_history_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_upcoming_rentals_usecase.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/common/widgets/booking_car_tile.dart';

class BookingsPage extends StatefulWidget {
  final Function(bool hasActiveRentals)? onActiveRentalsLoaded;

  const BookingsPage({super.key, this.onActiveRentalsLoaded});

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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final activeResult = await _getUserActiveRentalsUseCase();
      if (!mounted) return;

      activeResult.fold((error) {
        if (mounted) {
          setState(() {
            _errorMessage = error;
            _isLoading = false;
            return;
          });
        }
      }, (activeRentals) {
        if (!mounted) return;
        setState(() => _activeRentals = activeRentals);
      });
      widget.onActiveRentalsLoaded?.call(_activeRentals.isNotEmpty);

      final upcomingResult = await _getUserUpcomingRentalsUseCase();
      upcomingResult.fold((error) {
        if (mounted) {
          setState(() {
            _errorMessage = error;
            _isLoading = false;
            return;
          });
        }
      }, (upcomingRentals) {
        if (!mounted) return;
        setState(() => _upcomingRentals = upcomingRentals);
      });

      final historyResult = await _getUserRentalHistoryUseCase();
      historyResult.fold((error) {
        if (mounted) {
          setState(() {
            _errorMessage = error;
            _isLoading = false;
          });
        }
      }, (rentalHistory) {
        if (!mounted) return;
        _rentalHistory = rentalHistory;
      });

      _penaltyRentals = _rentalHistory
          .where((booking) => booking.bookingStatus! == RentalStatus.penalty.displayText)
          .toList();
      _rentalHistory = _rentalHistory
          .where((booking) =>
              booking.bookingStatus! == RentalStatus.completed.displayText ||
              booking.bookingStatus! == RentalStatus.cancelled.displayText)
          .toList();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      isLoading: _isLoading,
      emptyResultMsg: "You don't have rental history",
      errorMessage: _errorMessage,
      refreshFunction: _load,
      futureResultObj: _rentalHistory,
      futureBuilder: _buildBookingPage,
    );
  }

  Widget _buildBookingPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_penaltyRentals.isNotEmpty) ...[
          const TitleWidget(title: "Penalty Section:"),
          ..._penaltyRentals.map(
            (item) => Column(
              children: [
                BookingCarTile(
                  booking: item,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.userBookingDetails,
                      arguments: {'booking': item, 'title': 'Booking details'}).then(
                    (value) {
                      if (value == 'refresh') {
                        _load();
                      }
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ],
        if (_activeRentals.isNotEmpty) ...[
          const TitleWidget(title: "Active Rentals:"),
          ..._activeRentals.map((item) => Column(
                children: [
                  BookingCarTile(
                    booking: item,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.userBookingDetails,
                        arguments: {'booking': item, 'title': 'Booking details'}).then(
                      (value) {
                        if (value == 'refresh') {
                          _load();
                        }
                      },
                    ),
                  ),
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
                    onTap: () => Navigator.pushNamed(context, AppRoutes.userBookingDetails,
                        arguments: {'booking': item, 'title': 'Booking details'}).then(
                      (value) {
                        if (value == 'refresh') {
                          _load();
                        }
                      },
                    ),
                  ),
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
                      onTap: () => Navigator.pushNamed(context, AppRoutes.userBookingDetails,
                          arguments: {'booking': item, 'title': 'Booking details'})),
                  const SizedBox(height: AppSpacing.md),
                ],
              )),
        ],
      ],
    );
  }
}
