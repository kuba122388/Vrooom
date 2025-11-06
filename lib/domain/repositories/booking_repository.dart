import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/insurance.dart';


abstract class BookingRepository {
  Future<Either<String, List<Insurance>>> getAllInsurances();
}
