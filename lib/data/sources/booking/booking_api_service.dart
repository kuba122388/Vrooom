import 'package:dio/dio.dart';
import 'package:vrooom/data/models/boooking/booked_date_model.dart';
import 'package:vrooom/data/models/boooking/booking_model.dart';
import 'package:vrooom/data/models/boooking/booking_request_model.dart';
import 'package:vrooom/domain/entities/booked_date.dart';
import 'package:vrooom/domain/entities/booking.dart';
import '../../models/vehicle/insurance_model.dart';
import '../auth/auth_storage.dart';

class BookingApiService {
  final Dio _dio;
  final String _bookingApi = "/api/bookings";
  final String _userApi = "/api/customers";
  final AuthStorage _authStorage;

  BookingApiService(this._dio, this._authStorage);

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
      final userId = await _authStorage.getUserId();
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

  Future<List<Booking>> getFullRentalHistory() async {
    try {
      final response = await _dio.get("$_bookingApi/rental-history");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data.map((json) => BookingModel.fromJson(json)).toList();
        }

        throw Exception("Invalid response format - expected a list. ");
      } else {
        throw Exception("Received data about Rentals is not a list.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<List<Booking>> getActiveRentals() async {
    try {
      final response = await _dio.get("$_bookingApi/active-rentals");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data.map((json) => BookingModel.fromJson(json)).toList();
        }

        throw Exception("Invalid response format - expected a list. ");
      } else {
        throw Exception("Received data about Rentals is not a list.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<List<Booking>> getUpcomingRentals() async {
    try {
      final response = await _dio.get("$_bookingApi/upcoming-rentals");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data.map((json) => BookingModel.fromJson(json)).toList();
        }

        throw Exception("Invalid response format - expected a list. ");
      } else {
        throw Exception("Received data about Rentals is not a list.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<List<BookedDate>> getBookedDatesForVehicle(int vehicleId) async {
    try {
      final response = await _dio.get("$_bookingApi/vehicle/$vehicleId/booked-dates");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data.map((json) => BookedDateModel.fromJson(json)).toList();
        }

        throw Exception("Invalid response format - expected a list. ");
      } else {
        throw Exception("There was a problem with fetching data.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<bool> createBooking(BookingRequestModel booking) async {
    try {
      final response = await _dio.post("$_bookingApi/confirm", data: booking.toJson());

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("There was a problem with fetching data.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<bool> cancelBooking(int bookingId) async {
    try {
      final response =
          await _dio.post("$_bookingApi/cancel", queryParameters: {"bookingId": bookingId});

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("There was a problem with fetching data.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<bool> acceptBooking(int bookingId) async {
    try {
      final response =
          await _dio.post("$_bookingApi/accept", queryParameters: {"bookingId": bookingId});

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("There was a problem with fetching data.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<bool> finishBooking(int bookingId) async {
    try {
      final response =
          await _dio.post("$_bookingApi/finish", queryParameters: {"bookingId": bookingId});

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("There was a problem with fetching data.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<bool> finalizeBooking(BookingModel booking, int endMileage) async {
    try {
      final response = await _dio.post("$_bookingApi/finalize",
          data: booking.toJson(), queryParameters: {"endMileage": endMileage});

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("There was a problem with fetching data.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<bool> payPenalty(int bookingId) async {
    try {
      final response =
          await _dio.post("$_bookingApi/penalty", queryParameters: {"bookingId": bookingId});

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("There was a problem with fetching data.");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
