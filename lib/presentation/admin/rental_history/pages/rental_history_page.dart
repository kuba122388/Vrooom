import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/usecases/booking/get_full_rental_history_usecase.dart';
import 'package:vrooom/domain/usecases/user/download_user_profile_picture_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_user_id_by_email_usecase.dart';
import 'package:vrooom/presentation/admin/rental_history/widgets/rental_history_car_entry.dart';

import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../core/common/widgets/search_car_module/search_filter_module.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../../../../domain/usecases/vehicle/get_rental_locations_usecase.dart';
import '../../../../domain/usecases/vehicle/get_vehicle_equipment_usecase.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';

class RentalHistoryPage extends StatefulWidget {
  const RentalHistoryPage({super.key});

  @override
  State<RentalHistoryPage> createState() => _RentalHistoryPageState();
}

class _RentalHistoryPageState extends State<RentalHistoryPage> {
  final GetFullRentalHistoryUseCase _getFullRentalHistoryUseCase = sl();
  final GetUserIdByEmailUseCase _getUserIdByEmailUseCase = sl();
  final DownloadUserProfilePictureUseCase _downloadUserProfilePictureUseCase = sl();
  final FilterState _filterState = FilterState(
    getRentalLocationsUseCase: sl<GetRentalLocationsUseCase>(),
    getVehicleEquipmentUseCase: sl<GetVehicleEquipmentUseCase>(),
  );

  bool _isLoading = false;
  List<Booking> _rentalHistory = [];
  final List<Uint8List?> _customerImage = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final result = await _getFullRentalHistoryUseCase();
      result.fold(
        (error) {},
        (vehicleList) {
          _rentalHistory = vehicleList;
        },
      );

      _customerImage.clear();

      final futures = _rentalHistory.map((booking) async {
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

  RentalStatus _getRentalStatus(Booking booking) {
    switch (booking.bookingStatus) {
      case "Pending":
        return RentalStatus.pending;
      case "Cancelled":
        return RentalStatus.cancelled;
      default:
        return RentalStatus.completed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(
        title: "Rental History",
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchFilterModule(
                filterState: _filterState,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Rental History",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              if (_isLoading) ...[
                const SizedBox(height: AppSpacing.xl),
                const Center(child: CircularProgressIndicator(color: AppColors.primary))
              ] else ...[
                ..._rentalHistory.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Column(
                    children: [
                      RentalHistoryCarEntry(
                          rentalID: item.bookingID.toString(),
                          carName: "${item.vehicleMake} ${item.vehicleModel}",
                          carImage: item.vehicleImage as String,
                          startDate: DateTime(
                              item.startDate!.year, item.startDate!.month, item.startDate!.day),
                          endDate:
                              DateTime(item.endDate!.year, item.endDate!.month, item.endDate!.day),
                          rentalStatus: _getRentalStatus(item),
                          customerName: "${item.customerName} ${item.customerSurname}",
                          customerPicture: _customerImage[index]),
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
