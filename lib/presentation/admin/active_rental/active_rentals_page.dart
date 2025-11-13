import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vrooom/domain/usecases/vehicle/get_rental_locations_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_vehicle_equipment_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_active_rentals_usecase.dart';
import 'package:vrooom/presentation/admin/active_rental/widgets/search_filter_module_active.dart';
import 'dart:typed_data';
import 'package:vrooom/presentation/admin/rental_history/widgets/rental_history_car_entry.dart';

import '../../../core/common/widgets/loading_widget.dart';
import '../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../core/common/widgets/search_car_module/search_filter_module.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../core/common/widgets/primary_button.dart';
import '../../../core/configs/di/service_locator.dart';
import '../../../core/configs/routes/app_routes.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/app_text_styles.dart';
import '../../../core/enums/rental_status.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/usecases/user/download_user_profile_picture_usecase.dart';
import '../../../domain/usecases/user/get_user_id_by_email_usecase.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import 'controllers/vehicle_list_active_controller.dart';

class ActiveRentalsPage extends StatefulWidget {
  const ActiveRentalsPage({super.key});

  @override
  State<ActiveRentalsPage> createState() => _ActiveRentalsPageState();
}

class _ActiveRentalsPageState extends State<ActiveRentalsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FilterState(
                  getRentalLocationsUseCase: sl(),
                  getVehicleEquipmentUseCase: sl(),
                )),
        ChangeNotifierProxyProvider<FilterState, VehicleListActiveController>(
          create: (context) => VehicleListActiveController(
            filterState: context.read<FilterState>(),
          ),
          update: (_, filterState, previous) => previous!..filterState.loadFilterOptions(),
        ),
      ],
      child: const _ActiveRentalsView(),
    );
  }
}

class _ActiveRentalsView extends StatelessWidget {
  const _ActiveRentalsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VehicleListActiveController>();
    final filterState = context.watch<FilterState>();

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
              SearchFilterModuleActive(
                onSearchChanged: controller.onSearchChanged,
                filterState: filterState,
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
              if (filterState.hasActiveFilters || controller.searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    '${controller.filteredBookings.length} vehicles found',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              LoadingWidget(
                isLoading: controller.isLoading,
                errorMessage: controller.errorMessage,
                futureResultObj: controller.filteredBookings,
                emptyResultMsg: filterState.hasActiveFilters || controller.searchQuery.isNotEmpty
                    ? "No history entries match your filters."
                    : "No history data found.",
                futureBuilder: () => _buildBookings(context, controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookings(BuildContext context, VehicleListActiveController controller) {
    return Column(
      children: controller.filteredBookings.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Column(
          children: [
            if (_getRentalStatus(item) == RentalStatus.pending) ...[
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: RentalHistoryCarEntry(
                        rentalID: item.bookingID.toString(),
                        carName: "${item.vehicleMake} ${item.vehicleModel}",
                        carImage: item.vehicleImage as String,
                        startDate: DateTime(
                            item.startDate!.year, item.startDate!.month, item.startDate!.day),
                        endDate:
                            DateTime(item.endDate!.year, item.endDate!.month, item.endDate!.day),
                        rentalStatus: _getRentalStatus(item),
                        customerName: "${item.customerName} ${item.customerSurname}",
                        customerPicture: controller.customerImage[index]),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PrimaryButton(
                      text: "FINALIZE RENTAL",
                      width: 180,
                      textStyle: AppTextStyles.smallButton,
                      backgroundOpacity: 0.75,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.finalizeRental),
                    ),
                  ),
                ],
              ),
            ] else ...[
              RentalHistoryCarEntry(
                  rentalID: item.bookingID.toString(),
                  carName: "${item.vehicleMake} ${item.vehicleModel}",
                  carImage: item.vehicleImage as String,
                  startDate:
                      DateTime(item.startDate!.year, item.startDate!.month, item.startDate!.day),
                  endDate: DateTime(item.endDate!.year, item.endDate!.month, item.endDate!.day),
                  rentalStatus: _getRentalStatus(item),
                  customerName: "${item.customerName} ${item.customerSurname}",
                  customerPicture: controller.customerImage[index]),
            ],
            const SizedBox(height: AppSpacing.sm)
          ],
        );
      }).toList(),
    );
  }

  RentalStatus _getRentalStatus(Booking booking) {
    if (booking.bookingStatus == "Pending" && booking.endDate!.isBefore(DateTime.now())) {
      return RentalStatus.overdue;
    } else if (booking.bookingStatus == "Pending") {
      return RentalStatus.pending;
    }

    return RentalStatus.completed;
  }
}
