import 'package:flutter/material.dart';
import 'package:vrooom/presentation/admin/rental_history/widgets/rental_history_car_entry.dart';

import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../core/common/widgets/search_car_module/search_filter_module.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../../../../domain/usecases/vehicle/get_rental_locations_usecase.dart';
import '../../../../domain/usecases/vehicle/get_vehicle_equipment_usecase.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';

class RentalHistoryPage extends StatelessWidget {
  final FilterState _filterState = FilterState(
    getRentalLocationsUseCase: sl<GetRentalLocationsUseCase>(),
    getVehicleEquipmentUseCase: sl<GetVehicleEquipmentUseCase>(),
  );

  RentalHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<RentalHistoryCarEntry> rentalHistory = [
      RentalHistoryCarEntry(
        rentalID: "RENT001",
        startDate: DateTime(2025, 6, 30),
        endDate: DateTime(2025, 7, 30),
        rentalStatus: RentalStatus.completed,
      ),
      RentalHistoryCarEntry(
        rentalID: "RENT002",
        startDate: DateTime(2025, 6, 30),
        endDate: DateTime(2025, 7, 30),
        rentalStatus: RentalStatus.cancelled,
      ),
      RentalHistoryCarEntry(
        rentalID: "RENT003",
        startDate: DateTime(2025, 6, 30),
        endDate: DateTime(2025, 7, 30),
        rentalStatus: RentalStatus.cancelled,
      )
    ];

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
              SearchFilterModule(filterState: _filterState,),
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
              ...rentalHistory.expand(
                (entry) => [
                  entry,
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
