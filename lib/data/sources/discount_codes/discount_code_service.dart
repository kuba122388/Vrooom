import 'package:dio/dio.dart';

import 'package:vrooom/data/models/discount_codes/discount_code_model.dart';

class DiscountCodeService {
  final Dio _dio;
  final String _discountCodesApi = "/api/discounts";

  DiscountCodeService(this._dio);

  Future<List<DiscountCodeModel>> getAllDiscountCodes() async {
    try {
      final response = await _dio.get(_discountCodesApi);

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

  Future<DiscountCodeModel> addNewDiscountCode({
    required DiscountCodeModel discountCode,
  }) async {
    try {
      final response = await _dio.post(
        _discountCodesApi,
        data: discountCode.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DiscountCodeModel.fromJson(response.data);
      } else {
        throw ("Error adding discount code.");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<DiscountCodeModel> updateDiscountCode({
    required DiscountCodeModel discountCode,
  }) async {
    try {
      final response = await _dio.put(
        '$_discountCodesApi/${discountCode.id}',
        data: discountCode.toJson(),
      );

      if (response.statusCode == 200) {
        return DiscountCodeModel.fromJson(response.data);
      } else {
        throw ("Error updating discount code.");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<void> deleteDiscountCode({required int id}) async {
    try {
      final response = await _dio.delete(
        '$_discountCodesApi/$id',
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      } else {
        throw ("Error deleting discount code.");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }
}