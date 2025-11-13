import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/di/service_locator.dart';
import 'package:vrooom/domain/usecases/vehicle/get_all_vehicles_with_details_usecase.dart';

import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../domain/entities/vehicle.dart';

class VehicleListManagementController extends ChangeNotifier {
  final GetAllVehiclesWithDetailsUseCase _getAllVehiclesWithDetailsUseCase = sl();

  final FilterState filterState;

  VehicleListManagementController({required this.filterState}) {
    filterState.addListener(_applyFilters);
    _loadVehicles();
  }

  bool _isLoading = true;
  String? _errorMessage;
  List<Vehicle> _vehicles = [];
  List<Vehicle> _filteredVehicles = [];
  String _searchQuery = '';
  bool _disposed = false;

  // Getters
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<Vehicle> get filteredVehicles => _filteredVehicles;

  String get searchQuery => _searchQuery;

  // Public methods
  void onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  Future<void> _loadVehicles() async {
    _setLoading(true);
    final result = await _getAllVehiclesWithDetailsUseCase();

    if (_disposed) return;
    result.fold(
      (error) {
        _errorMessage = error;
        _setLoading(false);
      },
      (vehicleList) {
        _vehicles = vehicleList;
        _errorMessage = null;
        _setLoading(false);
        _applyFilters();
      },
    );
  }

  void _applyFilters() {
    final filtered = _vehicles.where((vehicle) {
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final fullCarName = "${vehicle.make} ${vehicle.model}".toLowerCase();
        if (!fullCarName.contains(searchLower)) return false;
      }

      if (filterState.selectedLocation != null &&
          vehicle.vehicleLocation != filterState.selectedLocation) {
        return false;
      }

      return true;
    }).toList();

    _filteredVehicles = filtered;
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_disposed) return;
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
