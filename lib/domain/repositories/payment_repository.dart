
import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/vehicle_summary.dart';

abstract class PaymentRepository {
  Future<Either<String, List<VehicleSummary>>> createStripeSession();
}
