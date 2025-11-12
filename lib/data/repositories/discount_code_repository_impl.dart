import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/discount_code.dart';
import 'package:vrooom/domain/repositories/discount_code_repository.dart';
import '../models/discount_codes/discount_code_model.dart';
import '../sources/discount_codes/discount_code_service.dart';

class DiscountCodeRepositoryImpl extends DiscountCodesRepository {
  final DiscountCodeService discountCodeService;

  DiscountCodeRepositoryImpl(this.discountCodeService);

  @override
  Future<Either<String, List<DiscountCode>>> getAllDiscountCodes() async {
    try {
      return Right(await discountCodeService.getAllDiscountCodes());
    } catch (e) {
      return Left(e.toString());
    }
  }
  
  @override
  Future<Either<String, DiscountCode>> addDiscountCode(DiscountCode code) async {
    try {
      final discountCode = DiscountCodeModel.fromEntity(code);
      final response = await discountCodeService.addNewDiscountCode(discountCode:discountCode);
      return Right(response.toEntity());
    }catch(e){
      return Left(e.toString());
    }
  }
}