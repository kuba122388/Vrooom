import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/discount_code_repository.dart';

class DeleteDiscountCodeUseCase {
  final DiscountCodesRepository discountCodesRepository;

  DeleteDiscountCodeUseCase(this.discountCodesRepository);

  Future<Either<String, void>> call(int id) async {
    return await discountCodesRepository.deleteDiscountCode(id);
  }
}