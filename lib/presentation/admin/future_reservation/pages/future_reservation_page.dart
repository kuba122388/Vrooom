import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/presentation/admin/widgets/admin_app_bar.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';
import 'package:vrooom/presentation/admin/widgets/rental_information_entry.dart';

import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../controllers/vehicle_list_future_controller.dart';
import '../widgets/search_filter_module_future.dart';

class FutureReservation extends StatefulWidget {
  const FutureReservation({super.key});

  @override
  State<FutureReservation> createState() => _FutureReservationState();
}

class _FutureReservationState extends State<FutureReservation> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FilterState(
                  getRentalLocationsUseCase: sl(),
                  getVehicleEquipmentUseCase: sl(),
                )),
        ChangeNotifierProxyProvider<FilterState, VehicleListFutureController>(
          create: (context) => VehicleListFutureController(
            filterState: context.read<FilterState>(),
          ),
          update: (_, filterState, previous) => previous!..filterState.loadFilterOptions(),
        ),
      ],
      child: const _FutureReservationView(),
    );
  }
}

class _FutureReservationView extends StatelessWidget {
  const _FutureReservationView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VehicleListFutureController>();
    final filterState = context.watch<FilterState>();

    return Scaffold(
      appBar: const AdminAppBar(title: "Future Reservations"),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchFilterModuleFuture(
                onSearchChanged: controller.onSearchChanged,
                filterState: filterState,
              ),
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
              LoadingWidget(
                isLoading: controller.isLoading,
                errorMessage: controller.errorMessage,
                emptyResultMsg: filterState.hasActiveFilters || controller.searchQuery.isNotEmpty
                    ? "No future entries match your filters."
                    : "No future reservation data found.",
                futureResultObj: controller.filteredBookings,
                futureBuilder: () => _buildBookings(context, controller),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookings(BuildContext context, VehicleListFutureController controller) {
    return Column(
      children: controller.filteredBookings.asMap().entries.map((entry) {
        final item = entry.value;
        final index = entry.key;

        return Column(
          children: [
            RentalInformationEntry(
                profileImage: controller.customerImage[index],
                firstName: item.customerName as String,
                surname: item.customerSurname as String,
                reservationID: item.bookingID.toString(),
                pickupDate:
                    DateTime(item.startDate!.year, item.startDate!.month, item.startDate!.day),
                returnDate: DateTime(item.endDate!.year, item.endDate!.month, item.endDate!.day),
                rentalStatus: RentalStatus.getRentalStatus(item.bookingStatus as String),
                carImage: item.vehicleImage as String,
                model: "${item.vehicleMake} ${item.vehicleModel}",
                productionYear: item.vehicleProductionYear as int),
            const SizedBox(height: AppSpacing.sm)
          ],
        );
      }).toList(),
    );
  }
}
