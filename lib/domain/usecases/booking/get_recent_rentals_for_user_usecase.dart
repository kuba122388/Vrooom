import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';

class GetRecentRentalsForUserUseCase {
  final BookingRepository bookingRepository;

  GetRecentRentalsForUserUseCase(this.bookingRepository);

  Future<Either<String, List<Booking>>> call() async {
    return await bookingRepository.getRecentRentalsForUser();
  }
}