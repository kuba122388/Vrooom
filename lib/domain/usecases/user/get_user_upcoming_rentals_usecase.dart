import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';

class GetUserUpcomingRentalsUseCase {
  final UserRepository userRepository;

  GetUserUpcomingRentalsUseCase(this.userRepository);

  Future<Either<String, List<Booking>>> call() async {
    return await userRepository.getUserUpcomingRentals();
  }
}