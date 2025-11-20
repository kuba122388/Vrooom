import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booked_date.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/entities/booking_request.dart';
import 'package:vrooom/domain/entities/insurance.dart';

abstract class BookingRepository {
  Future<Either<String, List<Insurance>>> getAllInsurances();

  Future<Either<String, List<Booking>>> getRecentRentalsForUser();

  Future<Either<String, List<Booking>>> getFullRentalHistory();

  Future<Either<String, List<Booking>>> getActiveRentals();

  Future<Either<String, List<Booking>>> getUpcomingRentals();

  Future<Either<String, List<BookedDate>>> getBookedDatesForVehicle(int vehicleId);

  Future<Either<String, bool>> createBooking(BookingRequest booking);

  Future<Either<String, bool>> cancelBooking(int bookingId);

  Future<Either<String, bool>> acceptBooking(int bookingId);

  Future<Either<String, bool>> finishBooking(int bookingId);

  Future<Either<String, bool>> finalizeBooking(Booking booking, int endMileage);

  Future<Either<String, bool>> payPenalty(int bookingId);
}
