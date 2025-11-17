import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';

class FinishBookingUseCase {
  final BookingRepository bookingRepository;

  FinishBookingUseCase(this.bookingRepository);

  Future<Either<String, bool>> call(int bookingId) async {
    return bookingRepository.finishBooking(bookingId);
  }
}
