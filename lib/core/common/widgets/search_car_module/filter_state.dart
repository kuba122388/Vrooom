import 'package:flutter/material.dart';
import 'package:vrooom/domain/usecases/vehicle/get_rental_locations_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_vehicle_equipment_usecase.dart';

import '../../../../domain/entities/equipment.dart';

class FilterState extends ChangeNotifier {
  final GetRentalLocationsUseCase _getRentalLocationsUseCase;
  final GetVehicleEquipmentUseCase _getVehicleEquipmentUseCase;

  FilterState({
    required GetRentalLocationsUseCase getRentalLocationsUseCase,
    required GetVehicleEquipmentUseCase getVehicleEquipmentUseCase,
  })  : _getRentalLocationsUseCase = getRentalLocationsUseCase,
        _getVehicleEquipmentUseCase = getVehicleEquipmentUseCase {
    loadFilterOptions();
  }

  String? _selectedLocation;
  DateTimeRange? _selectedDateRange;
  String? _selectedCarType;
  RangeValues _priceRange = const RangeValues(0, 1000);
  List<String> _selectedEquipment = [];

  bool _isLoadingOptions = false;
  String? _optionsError;

  Future<void> loadFilterOptions() async {
    _isLoadingOptions = true;
    _optionsError = null;

    final results = await Future.wait([
      _getRentalLocationsUseCase(),
      _getVehicleEquipmentUseCase(),
    ]);

    results[0].fold(
      (error) => _optionsError = error,
      (locations) => _availableLocations = locations as List<String>,
    );

    results[1].fold(
      (error) => _optionsError = error,
      (vehicleEquipments) {
        final equipments = vehicleEquipments as List<Equipment>;
        _availableEquipment = equipments.map((e) => e.equipmentName).toList();
      },
    );
  }

  List<String> _availableLocations = [];
  List<String> _availableEquipment = [];

  final List<String> availableCarTypes = [
    'Sedan',
    'SUV',
    'Coupe',
    'Cabriolet',
    'Hatchback',
    'Convertible',
    'Minivan',
    'Minibus',
    'Wagon',
  ];

  double minPrice = 0;
  double maxPrice = 1000;

// Getters
  String? get selectedLocation => _selectedLocation;

  DateTimeRange? get selectedDateRange => _selectedDateRange;

  String? get selectedCarType => _selectedCarType;

  RangeValues get priceRange => _priceRange;

  List<String> get selectedEquipment => _selectedEquipment;

  bool get isLoadingOptions => _isLoadingOptions;

  String? get optionsError => _optionsError;

  List<String> get availableLocations => _availableLocations;

  List<String> get availableEquipment => _availableEquipment;

  bool get hasActiveFilters =>
      _selectedLocation != null ||
      _selectedDateRange != null ||
      _selectedCarType != null ||
      _selectedEquipment.isNotEmpty ||
      _priceRange.start != minPrice ||
      _priceRange.end != maxPrice;

// Setters
  void setLocation(String? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? dateRange) {
    _selectedDateRange = dateRange;
    notifyListeners();
  }

  void setCarType(String? carType) {
    _selectedCarType = carType;
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void setEquipmentList(List<String> equipment) {
    _selectedEquipment = List.from(equipment);
    notifyListeners();
  }

  void toggleEquipment(String equipment) {
    if (_selectedEquipment.contains(equipment)) {
      _selectedEquipment.remove(equipment);
    } else {
      _selectedEquipment.add(equipment);
    }
    notifyListeners();
  }

  void clearAllFilters() {
    _selectedLocation = null;
    _selectedDateRange = null;
    _selectedCarType = null;
    _priceRange = RangeValues(minPrice, maxPrice);
    _selectedEquipment.clear();
    notifyListeners();
  }

  void clearLocationFilter() {
    _selectedLocation = null;
    notifyListeners();
  }

  void clearDateFilter() {
    _selectedDateRange = null;
    notifyListeners();
  }

  void clearCarTypeFilter() {
    _selectedCarType = null;
    notifyListeners();
  }
}
