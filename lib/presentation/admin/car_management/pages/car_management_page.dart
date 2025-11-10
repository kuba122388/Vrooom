import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/common/widgets/search_filter_module.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/domain/usecases/vehicle/get_all_vehicles_with_details_usecase.dart';
import 'package:vrooom/presentation/admin/widgets/admin_app_bar.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';
import 'package:vrooom/presentation/admin/widgets/car_inventory_entry.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_colors.dart';

class CarManagementPage extends StatefulWidget {
  const CarManagementPage({super.key});

  @override
  State<CarManagementPage> createState() => _CarManagementPageState();
}

class _CarManagementPageState extends State<CarManagementPage> {
  final GetAllVehiclesWithDetailsUseCase _getAllVehiclesWithDetailsUseCase = sl();

  bool _isLoading = false;
  List<Vehicle> _vehicles = [];

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

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() => _isLoading = true);

    try {
      final result = await _getAllVehiclesWithDetailsUseCase();
      result.fold(
        (error) {},
        (vehicleList) {
          setState(() => _vehicles = vehicleList);
        },
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const SearchFilterModule(),
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

              if (_isLoading) ... [
                const SizedBox(height: AppSpacing.xl),
                const Center(child: CircularProgressIndicator(color: AppColors.primary))
              ] else ... [
                ..._vehicles.map((entry) {
                  return CarInventoryEntry(
                      carImage: entry.vehicleImage,
                      carName: "${entry.make} ${entry.model}",
                      carStatus: _getCarStatus(entry.availabilityStatus),
                      fuel: entry.fuelType,
                      mileage: entry.mileage,
                      seats: entry.numberOfSeats,
                      transmission: entry.gearShift,
                      price: entry.pricePerDay);
                }).expand(
                      (widget) => [widget, const SizedBox(height: AppSpacing.sm)],
                ),

                PrimaryButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.addNewCar);
                  },
                  text: "Add New Car",
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
