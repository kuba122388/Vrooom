import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';

class GetUserActiveRentalsByIdUseCase {
  final UserRepository userRepository;

  GetUserActiveRentalsByIdUseCase(this.userRepository);

  Future<Either<String, List<Booking>>> call({required int userId}) async {
    return await userRepository.getUserActiveRentalsById(userId);
  }
}