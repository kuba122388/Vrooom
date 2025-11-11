import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';

import '../../entities/booking.dart';

class GetUserRentalHistoryByIdUseCase {
  final UserRepository userRepository;

  GetUserRentalHistoryByIdUseCase(this.userRepository);

  Future<Either<String, List<Booking>>> call({required int userId}) async {
    return await userRepository.getUserRentalHistoryById(userId);
  }
}