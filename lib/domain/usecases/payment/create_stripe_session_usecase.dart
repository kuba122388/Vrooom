import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/payment_repository.dart';

import '../../entities/stripe_session.dart';

class CreateStripeSessionUseCase {
  final PaymentRepository paymentRepository;

  CreateStripeSessionUseCase(this.paymentRepository);

  Future<Either<String,StripeSession>> call(double amount) async {
    return await paymentRepository.createStripeSession(amount);
  }
}