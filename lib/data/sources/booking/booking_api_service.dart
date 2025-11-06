import 'package:dio/dio.dart';


import '../../models/vehicle/insurance_model.dart';

class BookingApiService {
  final Dio _dio;
  final String _bookingApi = "/api/bookings";

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
}

