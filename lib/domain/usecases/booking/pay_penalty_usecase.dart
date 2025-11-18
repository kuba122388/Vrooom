import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';

class PayPenaltyUsecase {
  final BookingRepository bookingRepository;

  PayPenaltyUsecase(this.bookingRepository);

  Future<Either<String, bool>> call(int bookingId) async {
    return await bookingRepository.payPenalty(bookingId);
  }
}
