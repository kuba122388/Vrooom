import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';

class GetUserIdByEmailUseCase {
  final UserRepository userRepository;

  GetUserIdByEmailUseCase(this.userRepository);

  Future<Either<String, int?>> call({required String email}) async {
    return await userRepository.getUserIdByEmail(email);
  }
}