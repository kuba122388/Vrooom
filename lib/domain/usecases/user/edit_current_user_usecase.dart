import 'package:dartz/dartz.dart';
import 'package:vrooom/data/models/user_model.dart';
import '../../repositories/user_repository.dart';

class EditCurrentUserUseCase {
  final UserRepository userRepository;

  EditCurrentUserUseCase(this.userRepository);

  Future<Either<String, void>> call({required UserModel request}) async {
    return await userRepository.editCurrentUser(request);
  }
}