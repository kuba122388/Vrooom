import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/di/service_locator.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/usecases/booking/get_upcoming_rentals_usecase.dart';

import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../domain/usecases/user/download_user_profile_picture_usecase.dart';
import '../../../../domain/usecases/user/get_user_id_by_email_usecase.dart';

class VehicleListFutureController extends ChangeNotifier {
  final GetUpcomingRentalsUseCase _getUpcomingRentalsUseCase = sl();
  final DownloadUserProfilePictureUseCase _downloadUserProfilePictureUseCase = sl();
  final GetUserIdByEmailUseCase _getUserIdByEmailUseCase = sl();

  final FilterState filterState;

  VehicleListFutureController({required this.filterState}) {
    filterState.addListener(_applyFilters);
    _loadVehicles();
  }

  bool _isLoading = true;
  String? _errorMessage;
  List<Booking> _bookings = [];
  List<Booking> _filteredHistory = [];
  String _searchQuery = '';
  bool _disposed = false;
  List<Uint8List?> _customerImage = [];

  // Getters
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<Booking> get filteredBookings => _filteredHistory;

  String get searchQuery => _searchQuery;

  // Public methods
  void onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  Future<void> refreshBookings() async {
    _customerImage.clear();
    await _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    _setLoading(true);
    final result = await _getUpcomingRentalsUseCase();

    if (_disposed) return;
    result.fold(
      (error) => _errorMessage = error,
      (vehicleList) {
        vehicleList.sort((a, b) => a.startDate!.day.compareTo(b.startDate!.day));
        _bookings = vehicleList;
        _errorMessage = null;
        _applyFilters();
      },
    );

    if (_disposed) return;

    final futures = _bookings.map((booking) async {
      if (_disposed) return null;

      final idResult = await _getUserIdByEmailUseCase(email: booking.customerEmail!);
      if (_disposed) return null;

      return await idResult.fold(
        (error) async => null,
        (userId) async {
          if (_disposed) return null;

          final picResult = await _downloadUserProfilePictureUseCase(userId: userId as int);
          return picResult.fold((error) => null, (bytes) => bytes);
        },
      );
    }).toList();

    final images = await Future.wait(futures);
    if (_disposed) return;

    _setLoading(false);
    if (!_disposed) {
      _customerImage.addAll(images);
    }
  }

  void _applyFilters() {
    final filtered = _bookings.where((booking) {
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final fullCustomerName = "${booking.customerName} ${booking.customerSurname}".toLowerCase();
        final customerPhone = booking.customerPhoneNumber ?? "";
        final emailAddress = booking.customerEmail ?? "";
        final vehicle = "${booking.vehicleMake} ${booking.vehicleModel}".toLowerCase();

        if (!fullCustomerName.contains(searchLower) &&
            !customerPhone.contains(searchLower) &&
            !emailAddress.contains(searchLower) &&
            !vehicle.contains(searchLower)) {
          return false;
        }
      }

      if (filterState.selectedLocation != null &&
          booking.pickupAddress != filterState.selectedLocation) {
        return false;
      }

      return true;
    }).toList();

    _filteredHistory = filtered;
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

  List<Uint8List?> get customerImage => _customerImage;
}
