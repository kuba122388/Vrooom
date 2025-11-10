import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';

class GetUpcomingRentalsUseCase {
  final BookingRepository bookingRepository;

  GetUpcomingRentalsUseCase(this.bookingRepository);

  Future<Either<String, List<Booking>>> call() async {
    return await bookingRepository.getUpcomingRentals();
  }
}