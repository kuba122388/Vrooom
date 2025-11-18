import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository bookingRepository;

  CancelBookingUseCase(this.bookingRepository);

  Future<Either<String, bool>> call(int bookingId) async {
    return bookingRepository.cancelBooking(bookingId);
  }
}
