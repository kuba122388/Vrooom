import 'package:flutter/material.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/presentation/admin/rental_history/widgets/rental_history_car_entry.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/loading_widget.dart';
import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/search_car_module/widget/search_filter_module_admin.dart';
import '../controllers/vehicle_list_history_controller.dart';

class RentalHistoryPage extends StatefulWidget {
  const RentalHistoryPage({super.key});

  @override
  State<RentalHistoryPage> createState() => _RentalHistoryPageState();
}

class _RentalHistoryPageState extends State<RentalHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FilterState(
                  getRentalLocationsUseCase: sl(),
                  getVehicleEquipmentUseCase: sl(),
                )),
        ChangeNotifierProxyProvider<FilterState, VehicleListHistoryController>(
          create: (context) => VehicleListHistoryController(
            filterState: context.read<FilterState>(),
          ),
          update: (_, filterState, previous) => previous!..filterState.loadFilterOptions(),
        ),
      ],
      child: const _RentalHistoryView(),
    );
  }
}

class _RentalHistoryView extends StatelessWidget {
  const _RentalHistoryView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VehicleListHistoryController>();
    final filterState = context.watch<FilterState>();

    return Scaffold(
      appBar: const AdminAppBar(
        title: "Rental History",
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SearchFilterModuleAdmin(
              onSearchChanged: controller.onSearchChanged,
              filterState: filterState,
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
          ]),
        ),
      ),
    );
  }

  Widget _buildBookings(BuildContext context, VehicleListHistoryController controller) {
    return Column(
      children: controller.filteredBookings.asMap().entries.map((entry) {
        final item = entry.value;
        final index = entry.key;

        return Column(
          children: [
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
            const SizedBox(height: AppSpacing.sm),
          ],
        );
      }).toList(),
    );
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
}
