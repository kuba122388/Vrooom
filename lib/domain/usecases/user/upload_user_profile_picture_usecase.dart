import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';

class UploadUserProfilePictureUseCase {
  final UserRepository userRepository;

  UploadUserProfilePictureUseCase(this.userRepository);

  Future<Either<String, void>> call({
    required int userId,
    required File imageFile
  }) async {
    return await userRepository.uploadUserProfilePicture(userId, imageFile);
  }
}