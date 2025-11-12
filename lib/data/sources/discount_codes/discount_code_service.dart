import 'package:dio/dio.dart';
import 'package:vrooom/data/models/discount_codes/discount_code_model.dart';

class DiscountCodeService {
  final Dio _dio;
  final String _discountCodesApi = "/api/discounts";

  DiscountCodeService(this._dio);

  Future<List<DiscountCodeModel>> getAllDiscountCodes() async {
    try {
      final response = await _dio.get('$_discountCodesApi');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => DiscountCodeModel.fromJson(json)).toList();
        } else {
          throw Exception("Invalid response format — expected a list");
        }
      } else {
        throw Exception("Error while fetching discount codes");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }
}

