import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/user.dart';

import '../../repositories/user_repository.dart';

class GetAllUsersUsecase {
  final UserRepository userRepository;

  GetAllUsersUsecase(this.userRepository);

  Future<Either<String, List<User>>> call() async {
    return await userRepository.getAllUsers();
  }
}
