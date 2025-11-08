import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/user_repository.dart';

class DownloadUserProfilePictureUseCase {
  final UserRepository userRepository;

  DownloadUserProfilePictureUseCase(this.userRepository);

  Future<Either<String, Uint8List>> call({
    required int userId
  }) async {
    return await userRepository.downloadUserProfilePicture(userId);
  }
}