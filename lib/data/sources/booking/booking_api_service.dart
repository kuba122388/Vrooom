import 'package:dio/dio.dart';
import 'package:vrooom/data/models/boooking/booking_model.dart';
import 'package:vrooom/domain/entities/booking.dart';
import '../../models/vehicle/insurance_model.dart';
import '../auth/auth_storage.dart';

class BookingApiService {
  final Dio _dio;
  final String _bookingApi = "/api/bookings";
  final String _userApi = "/api/customers";

  BookingApiService(this._dio);

  Future<List<InsuranceModel>> getAllInsurances() async {
    try {
      final response = await _dio.get('$_bookingApi/insurances');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => InsuranceModel.fromJson(json)).toList();
        } else {
          throw Exception("Invalid response format — expected a list");
        }
      } else {
        throw Exception("Error while fetching insurances");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<List<Booking>> getRecentRentalsForUser() async {
    try {
      final userId = await AuthStorage.getUserId();
      if (userId == null) {
        throw Exception("No userID in storage");
      }

      final response = await _dio.get("$_userApi/user/$userId/recent-rentals");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data.map((json) => BookingModel.fromJson(json)).toList();
        }

        throw Exception("Invalid response format - expected a list. ");
      } else {
        throw Exception("Received data about Users is not a list.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}

