import 'package:dartz/dartz.dart';

import '../entities/stripe_session.dart';

abstract class PaymentRepository {
  Future<Either<String, StripeSession>> createStripeSession(double amount);
}
