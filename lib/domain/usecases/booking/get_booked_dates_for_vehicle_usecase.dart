import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booked_date.dart';
import 'package:vrooom/domain/repositories/booking_repository.dart';

class GetBookedDatesForVehicleUseCase {
  final BookingRepository bookingRepository;

  GetBookedDatesForVehicleUseCase(this.bookingRepository);

  Future<Either<String, List<BookedDate>>> call(int vehicleId) async {
    return await bookingRepository.getBookedDatesForVehicle(vehicleId);
  }
}
