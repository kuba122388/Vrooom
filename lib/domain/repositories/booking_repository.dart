import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/entities/insurance.dart';


abstract class BookingRepository {
  Future<Either<String, List<Insurance>>> getAllInsurances();
  Future<Either<String, List<Booking>>> getRecentRentalsForUser();
}
