import 'package:flutter/material.dart';
import 'package:vrooom/domain/usecases/vehicle/get_rental_locations_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_vehicle_equipment_usecase.dart';
import 'package:vrooom/presentation/admin/rental_history/widgets/rental_history_car_entry.dart';

import '../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../core/common/widgets/search_car_module/search_filter_module.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../core/common/widgets/primary_button.dart';
import '../../../core/configs/di/service_locator.dart';
import '../../../core/configs/routes/app_routes.dart';
import '../../../core/configs/theme/app_text_styles.dart';
import '../../../core/enums/rental_status.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';

class ActiveRentalsPage extends StatelessWidget {
  final FilterState _filterState = FilterState(
    getRentalLocationsUseCase: sl<GetRentalLocationsUseCase>(),
    getVehicleEquipmentUseCase: sl<GetVehicleEquipmentUseCase>(),
  );

  ActiveRentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<RentalHistoryCarEntry> rentalHistory = [
      RentalHistoryCarEntry(
        rentalID: "RENT001",
        startDate: DateTime(2025, 6, 30),
        endDate: DateTime(2025, 7, 30),
        rentalStatus: RentalStatus.finished,
      ),
      RentalHistoryCarEntry(
        rentalID: "RENT002",
        startDate: DateTime(2025, 6, 30),
        endDate: DateTime(2025, 7, 30),
        rentalStatus: RentalStatus.inProgress,
      ),
      RentalHistoryCarEntry(
        rentalID: "RENT003",
        startDate: DateTime(2025, 6, 30),
        endDate: DateTime(2025, 7, 30),
        rentalStatus: RentalStatus.overdue,
      )
    ];

    return Scaffold(
      appBar: const AdminAppBar(
        title: "Active Rentals",
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
                "Active Rentals",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ...rentalHistory.expand(
                (entry) => [
                  if (entry.rentalStatus == RentalStatus.finished) ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: entry,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: PrimaryButton(
                            text: "FINALIZE RENTAL",
                            width: 180,
                            textStyle: AppTextStyles.smallButton,
                            backgroundOpacity: 0.75,
                            onPressed: () => Navigator.pushNamed(
                                context, AppRoutes.finalizeRental),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    entry
                  ],
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
