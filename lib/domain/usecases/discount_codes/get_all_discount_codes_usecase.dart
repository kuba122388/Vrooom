import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/discount_code_repository.dart';

import '../../entities/discount_code.dart';

class GetAllDiscountCodesUseCase {
  final DiscountCodesRepository discountCodesRepository;

  GetAllDiscountCodesUseCase(this.discountCodesRepository);

  Future<Either<String, List<DiscountCode>>> call() async {
    return await discountCodesRepository.getAllDiscountCodes();
  }
}