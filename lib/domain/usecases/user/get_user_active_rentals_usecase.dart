import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';

class GetUserActiveRentalsUseCase {
  final UserRepository userRepository;

  GetUserActiveRentalsUseCase(this.userRepository);

  Future<Either<String, List<Booking>>> call() async {
    return await userRepository.getUserActiveRentals();
  }
}