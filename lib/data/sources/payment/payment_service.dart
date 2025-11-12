import 'package:dio/dio.dart';
import 'package:vrooom/data/models/payment/stripe_session_model.dart';


class PaymentService {
  final Dio _dio;
  final String _paymentApi = "/api/payment";

  PaymentService(this._dio);

  Future<StripeSessionModel> createStripeSession(double amount) async {
    final String endpoint = "$_paymentApi/create-checkout-session";

    final Map<String, dynamic> requestBody = {
      'amount': amount,
    };

    try {
      final response = await _dio.post(
        endpoint,
        data: requestBody,
      );

      if (response.data is Map<String, dynamic>) {
        return StripeSessionModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception("Invalid response format received.");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception("Server error (${e.response?.statusCode}): ${e.response?.data['error'] ?? 'Unknown error'}");
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
