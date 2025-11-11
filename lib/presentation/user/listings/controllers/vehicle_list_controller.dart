import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/di/service_locator.dart';
import 'package:vrooom/domain/entities/vehicle_summary.dart';
import 'package:vrooom/domain/usecases/vehicle/get_all_vehicles_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_available_vehicles_between_dates_usecase.dart';
import '../../../../core/common/widgets/search_car_module/filter_state.dart';

class VehicleListController extends ChangeNotifier {
  final GetAllVehiclesUseCase _getAllVehiclesUseCase = sl();
  final GetAvailableVehiclesBetweenDatesUseCase
  _getAvailableVehiclesBetweenDatesUseCase = sl();

  final FilterState filterState;

  VehicleListController({required this.filterState}) {
    filterState.addListener(_onFilterChanged);
    _loadVehicles();
  }

  bool _isLoading = true;
  String? _errorMessage;
  List<VehicleSummary> _vehicles = [];
  List<VehicleSummary> _filteredVehicles = [];
  DateTimeRange? _currentDateRangeLoaded;
  String _searchQuery = '';

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<VehicleSummary> get filteredVehicles => _filteredVehicles;
  String get searchQuery => _searchQuery;

  // Public methods
  void onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  Future<void> _loadVehicles() async {
    _setLoading(true);
    final result = await _getAllVehiclesUseCase();
    result.fold(
          (error) {
        _errorMessage = error;
        _setLoading(false);
      },
          (vehicleList) {
        _vehicles = vehicleList;
        _currentDateRangeLoaded = null;
        _errorMessage = null;
        _setLoading(false);
        _applyFilters();
      },
    );
  }

  Future<void> _getVehiclesBetweenDates() async {
    final range = filterState.selectedDateRange;
    if (range == null) {
      await _loadVehicles();
      return;
    }

    if (range == _currentDateRangeLoaded) return;

    _setLoading(true);

    final result = await _getAvailableVehiclesBetweenDatesUseCase(range);
    result.fold(
          (error) {
        _errorMessage = error;
        _setLoading(false);
      },
          (vehicleList) {
        _vehicles = vehicleList;
        _currentDateRangeLoaded = range;
        _errorMessage = null;
        _setLoading(false);
        _applyFilters();
      },
    );
  }

  void _onFilterChanged() async {
    if (filterState.selectedDateRange != _currentDateRangeLoaded) {
      await _getVehiclesBetweenDates();
    } else {
      _applyFilters();
    }
  }

  void _applyFilters() {
    final filtered = _vehicles.where((vehicle) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final fullCarName = "${vehicle.make} ${vehicle.model}".toLowerCase();
        if (!fullCarName.contains(searchLower)) return false;
      }

      // Location filter
      if (filterState.selectedLocation != null &&
          vehicle.vehicleLocation != filterState.selectedLocation) {
        return false;
      }

      // Car type filter
      if (filterState.selectedCarType != null &&
          vehicle.type.toLowerCase() !=
              filterState.selectedCarType!.toLowerCase()) {
        return false;
      }

      // Price range
      if (vehicle.pricePerDay < filterState.priceRange.start ||
          vehicle.pricePerDay > filterState.priceRange.end) {
        return false;
      }

      // Equipment
      if (filterState.selectedEquipment.isNotEmpty) {
        final vehicleEquipment = vehicle.equipmentList
            .map((entry) => entry.equipmentName)
            .toList();
        if (!filterState.selectedEquipment
            .every(vehicleEquipment.contains)) return false;
      }

      return true;
    }).toList();

    _filteredVehicles = filtered;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    filterState.removeListener(_onFilterChanged);
    super.dispose();
  }
}
