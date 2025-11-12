import 'package:dartz/dartz.dart';
import 'package:vrooom/data/sources/payment/payment_service.dart';
import 'package:vrooom/domain/repositories/payment_repository.dart';

import '../../domain/entities/stripe_session.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final PaymentService paymentApiService;

  PaymentRepositoryImpl(this.paymentApiService);

  @override
  Future<Either<String,StripeSession>> createStripeSession(double amount) async {
    try {
      final response = await paymentApiService.createStripeSession(amount);
      return Right(response.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
