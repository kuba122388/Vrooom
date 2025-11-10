import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:vrooom/core/common/widgets/search_filter_module.dart';
import 'package:vrooom/domain/usecases/booking/get_upcoming_rentals_usecase.dart';
import 'package:vrooom/domain/usecases/user/download_user_profile_picture_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_id_by_email_usecase.dart';
import 'package:vrooom/presentation/admin/widgets/admin_app_bar.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';
import 'package:vrooom/presentation/admin/widgets/rental_information_entry.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../../../../domain/entities/booking.dart';

class FutureReservation extends StatefulWidget {
  const FutureReservation({super.key});

  @override
  State<FutureReservation> createState() => _FutureReservationState();
}

class _FutureReservationState extends State<FutureReservation> {
  final GetUpcomingRentalsUseCase _getUpcomingRentalsUseCase = sl();
  final GetUserIdByEmailUseCase _getUserIdByEmailUseCase = sl();
  final DownloadUserProfilePictureUseCase _downloadUserProfilePictureUseCase = sl();

  bool _isLoading = false;
  List<Booking> _upcomingRentals = [];
  final List<Uint8List?> _customerImage = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final result = await _getUpcomingRentalsUseCase();
      result.fold(
            (error) {},
            (vehicleList) {
          _upcomingRentals = vehicleList;
        },
      );

      _customerImage.clear();

      final futures = _upcomingRentals.map((booking) async {
        final idResult = await _getUserIdByEmailUseCase(email: booking.customerEmail!);
        return await idResult.fold(
              (error) async => null,
              (userId) async {
            final picResult = await _downloadUserProfilePictureUseCase(userId: userId as int);
            return picResult.fold((error) => null, (success) => success);
          },
        );
      }).toList();

      final images = await Future.wait(futures);
      _customerImage.addAll(images);

    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: "Future Reservations"),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchFilterModule(),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Upcoming Rentals",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              if (_isLoading) ... [
                const SizedBox(height: AppSpacing.xl),
                const Center(child: CircularProgressIndicator(color: AppColors.primary))
              ] else ... [
                ..._upcomingRentals.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Column(
                    children: [
                      RentalInformationEntry(
                        profileImage: _customerImage[index],
                        firstName: item.customerName as String,
                        surname: item.customerSurname as String,
                        reservationID: item.bookingID.toString(),
                        pickupDate: DateTime(item.startDate!.year, item.startDate!.month, item.startDate!.day),
                        returnDate: DateTime(item.endDate!.year, item.endDate!.month, item.endDate!.day),
                        rentalStatus: RentalStatus.pending,
                        carImage: item.vehicleImage as String,
                        model: "${item.vehicleMake} ${item.vehicleModel}",
                        productionYear: 2022
                      ),
                      const SizedBox(height: AppSpacing.sm)
                    ],
                  );
                })
              ]
            ],
          ),
        ),
      ),
    );
  }
}
