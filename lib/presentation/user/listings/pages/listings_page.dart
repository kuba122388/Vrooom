import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/di/service_locator.dart';
import 'package:vrooom/core/common/widgets/search_car_module/search_filter_module.dart';
import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../controllers/vehicle_list_controller.dart';
import '../widgets/car_tile.dart';

class ListingsPage extends StatelessWidget {
  const ListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FilterState(
                  getRentalLocationsUseCase: sl(),
                  getVehicleEquipmentUseCase: sl(),
                )),
        ChangeNotifierProxyProvider<FilterState, VehicleListController>(
          create: (context) => VehicleListController(
            filterState: context.read<FilterState>(),
          ),
          update: (_, filterState, previous) => previous!..filterState.loadFilterOptions(),
        ),
      ],
      child: const _ListingsView(),
    );
  }
}

class _ListingsView extends StatelessWidget {
  const _ListingsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VehicleListController>();
    final filterState = context.watch<FilterState>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            children: [
              SearchFilterModule(
                onSearchChanged: controller.onSearchChanged,
                filterState: filterState,
              ),
              const SizedBox(height: AppSpacing.xl),
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
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicles(BuildContext context, VehicleListController controller) {
    return Column(
      children: controller.filteredVehicles.map((vehicle) {
        return Column(
          children: [
            CarTile(
              imgPath: vehicle.vehicleImage,
              make: vehicle.make,
              model: vehicle.model,
              price: vehicle.pricePerDay,
              description: vehicle.description,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.carDetails,
                  arguments: {"vehicleId": vehicle.vehicleID},
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        );
      }).toList(),
    );
  }
}
