import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/discount_code.dart';
import 'package:vrooom/domain/repositories/discount_code_repository.dart';

class UpdateDiscountCodeUseCase {
  final DiscountCodesRepository discountCodesRepository;

  UpdateDiscountCodeUseCase(this.discountCodesRepository);

  Future<Either<String, DiscountCode>> call(DiscountCode code) async {
    return await discountCodesRepository.updateDiscountCode(code);
  }
}