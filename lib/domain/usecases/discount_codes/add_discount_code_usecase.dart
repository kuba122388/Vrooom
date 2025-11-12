import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/discount_code_repository.dart';

import '../../entities/discount_code.dart';

class AddDiscountCodeUseCase {
  final DiscountCodesRepository discountCodesRepository;

  AddDiscountCodeUseCase(this.discountCodesRepository);

  Future<Either<String, DiscountCode>> call(DiscountCode code) async {
    return await discountCodesRepository.addDiscountCode(code);
  }
}