import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/core/common/widgets/search_filter_module.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/domain/entities/vehicle_summary.dart';
import 'package:vrooom/domain/usecases/vehicle/get_all_vehicles_usecase.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/routes/app_routes.dart';
import '../widgets/car_tile.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final GetAllVehiclesUseCase _getAllVehiclesUseCase = sl();
  bool _isLoading = true;
  List<VehicleSummary> _vehicles = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final result = await _getAllVehiclesUseCase();
    result.fold(
      (error) {
        print("=== ERROR OCCURED === $error");
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
      },
      (vehicleList) {
        print("=== VEHICLES LOADED ===");
        setState(() {
          _vehicles = vehicleList;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          children: [
            const SearchFilterModule(),
            const SizedBox(
              height: AppSpacing.xl,
            ),
            LoadingWidget(
              isLoading: _isLoading,
              errorMessage: _errorMessage,
              futureResultObj: _vehicles,
              emptyResultMsg: "No vehicles data found.",
              futureBuilder: _buildVehicles,
            ),
            const SizedBox(width: AppSpacing.sm)
          ],
        ),
      ),
    );
  }

  Widget _buildVehicles() {
    return Column(
      children: [
        for (int i = 0; i < (_vehicles.length).ceil(); i++) ...[
          CarTile(
            imgPath: _vehicles[i].vehicleImage,
            make: _vehicles[i].make,
            model: _vehicles[i].model,
            price: _vehicles[i].pricePerDay,
            description: _vehicles[i].description,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.carDetails,
                arguments: {
                  "vehicleId": _vehicles[i].vehicleID,
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
