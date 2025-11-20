import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booking_request.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository bookingRepository;

  CreateBookingUseCase(this.bookingRepository);

  Future<Either<String, bool>> call(BookingRequest booking) async {
    return bookingRepository.createBooking(booking);
  }
}
