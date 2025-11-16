import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/auth_repository.dart';

class ResendVerificationCodeUseCase {
  final AuthRepository repository;

  ResendVerificationCodeUseCase(this.repository);

  Future<Either<String, String>> call({
    required String email,
  }) async {
    if (email.isEmpty) {
      return const Left("Email address is required for resend operation.");
    }

    return await repository.resendVerificationCode(email: email);
  }
}