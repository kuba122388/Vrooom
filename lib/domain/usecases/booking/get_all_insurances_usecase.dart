import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/insurance.dart';

import '../../repositories/booking_repository.dart';

class GetAllInsurancesUseCase {
  final BookingRepository bookingRepository;

  GetAllInsurancesUseCase(this.bookingRepository);

  Future<Either<String, List<Insurance>>> call() async{
    return await  bookingRepository.getAllInsurances();
  }
}