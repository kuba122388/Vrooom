import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';

class AcceptBookingUseCase {
  final BookingRepository bookingRepository;

  AcceptBookingUseCase(this.bookingRepository);

  Future<Either<String, bool>> call(int bookingId) async {
    return bookingRepository.acceptBooking(bookingId);
  }
}
