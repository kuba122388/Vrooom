import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';

class DeleteUserByIdUseCase {
  final UserRepository userRepository;

  DeleteUserByIdUseCase(this.userRepository);

  Future<Either<String, void>> call(int userId) async {
    return await userRepository.deleteUserById(userId);
  }
}
