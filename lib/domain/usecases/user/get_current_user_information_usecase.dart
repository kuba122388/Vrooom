import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/user.dart';

import '../../repositories/user_repository.dart';

class GetCurrentUserInformationUseCase {
  final UserRepository userRepository;

  GetCurrentUserInformationUseCase(this.userRepository);

  Future<Either<String, User>> call() async {
    return await userRepository.getCurrentUserInformation();
  }
}