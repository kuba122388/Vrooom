import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booking.dart';

import '../../repositories/booking_repository.dart';

class FinalizeBookingUseCase {
  final BookingRepository bookingRepository;

  FinalizeBookingUseCase(this.bookingRepository);

  Future<Either<String, bool>> call(Booking booking, int endMileage) async {
    return bookingRepository.finalizeBooking(booking, endMileage);
  }
}
