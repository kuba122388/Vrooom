import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booking.dart';

import 'package:vrooom/domain/entities/insurance.dart';

import '../../domain/repositories/booking_repository.dart';
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
}