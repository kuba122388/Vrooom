import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/presentation/admin/widgets/admin_app_bar.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';
import 'package:vrooom/presentation/admin/widgets/car_inventory_entry.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/loading_widget.dart';
import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../core/common/widgets/search_car_module/search_filter_module.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../controllers/vehicle_list_management_controller.dart';

class CarManagementPage extends StatefulWidget {
  const CarManagementPage({super.key});

  @override
  State<CarManagementPage> createState() => _CarManagementPageState();
}

class _CarManagementPageState extends State<CarManagementPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FilterState(
                  getRentalLocationsUseCase: sl(),
                  getVehicleEquipmentUseCase: sl(),
                )),
        ChangeNotifierProxyProvider<FilterState, VehicleListManagementController>(
          create: (context) => VehicleListManagementController(
            filterState: context.read<FilterState>(),
          ),
          update: (_, filterState, previous) => previous!..filterState.loadFilterOptions(),
        ),
      ],
      child: const _CarManagementView(),
    );
  }
}

class _CarManagementView extends StatelessWidget {
  const _CarManagementView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VehicleListManagementController>();
    final filterState = context.watch<FilterState>();

    return Scaffold(
      appBar: const AdminAppBar(
        title: "Manage cars",
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchFilterModule(
                onSearchChanged: controller.onSearchChanged,
                filterState: filterState,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Car Inventory",
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
                    '${controller.filteredVehicles.length} vehicles found',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              LoadingWidget(
                isLoading: controller.isLoading,
                errorMessage: controller.errorMessage,
                futureResultObj: controller.filteredVehicles,
                emptyResultMsg: filterState.hasActiveFilters || controller.searchQuery.isNotEmpty
                    ? "No vehicles match your filters."
                    : "No vehicles data found.",
                futureBuilder: () => _buildVehicles(context, controller),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.addNewCar);
                },
                text: "Add New Car",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicles(BuildContext context, VehicleListManagementController controller) {
    return Column(
      children: controller.filteredVehicles.map((vehicle) {
        return Column(
          children: [
            CarInventoryEntry(
                carImage: vehicle.vehicleImage,
                carName: "${vehicle.make} ${vehicle.model}",
                carStatus: _getCarStatus(vehicle.availabilityStatus),
                fuel: vehicle.fuelType,
                mileage: vehicle.mileage,
                seats: vehicle.numberOfSeats,
                transmission: vehicle.gearShift,
                price: vehicle.pricePerDay),
            const SizedBox(height: AppSpacing.md),
          ],
        );
      }).toList(),
    );
  }

  CarStatus _getCarStatus(String status) {
    switch (status) {
      case "Available":
        return CarStatus.available;
      case "Not Available":
        return CarStatus.unavailable;
      case "Maintenance":
        return CarStatus.maintenance;
      default:
        return CarStatus.archived;
    }
  }
}
