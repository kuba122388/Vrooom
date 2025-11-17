import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booked_date.dart';
import 'package:vrooom/domain/entities/booking.dart';

import 'package:vrooom/domain/entities/insurance.dart';

import '../../domain/entities/booking_request.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/boooking/booking_model.dart';
import '../models/boooking/booking_request_model.dart';
import '../sources/booking/booking_api_service.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingApiService bookingApiService;

  BookingRepositoryImpl(this.bookingApiService);

  @override
  Future<Either<String, List<Insurance>>> getAllInsurances() async {
    try {
      final response = await bookingApiService.getAllInsurances();

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Booking>>> getRecentRentalsForUser() async {
    try {
      final response = await bookingApiService.getRecentRentalsForUser();
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Booking>>> getFullRentalHistory() async {
    try {
      return Right(await bookingApiService.getFullRentalHistory());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Booking>>> getActiveRentals() async {
    try {
      return Right(await bookingApiService.getActiveRentals());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Booking>>> getUpcomingRentals() async {
    try {
      return Right(await bookingApiService.getUpcomingRentals());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<BookedDate>>> getBookedDatesForVehicle(int vehicleId) async {
    try {
      return Right(await bookingApiService.getBookedDatesForVehicle(vehicleId));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> createBooking(BookingRequest booking) async {
    try {
      final requestModel = BookingRequestModel.fromEntity(booking);

      final response = await bookingApiService.createBooking(requestModel);

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> cancelBooking(int bookingId) async {
    try {
      return Right(await bookingApiService.cancelBooking(bookingId));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> acceptBooking(int bookingId) async {
    try {
      return Right(await bookingApiService.acceptBooking(bookingId));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> finishBooking(int bookingId) async {
    try {
      return Right(await bookingApiService.finishBooking(bookingId));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> finalizeBooking(Booking booking, int endMileage) async {
    try {
      return Right(
          await bookingApiService.finalizeBooking(BookingModel.fromEntity(booking), endMileage));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> payPenalty(int bookingId) async {
    try {
      return Right(await bookingApiService.payPenalty(bookingId));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
