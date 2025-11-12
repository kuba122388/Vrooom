import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/discount_code.dart';


abstract class DiscountCodesRepository {
  Future<Either<String, List<DiscountCode>>> getAllDiscountCodes();
  Future<Either<String, DiscountCode>> addDiscountCode(DiscountCode code);
  Future<Either<String, void>> deleteDiscountCode(int id);
  Future<Either<String, DiscountCode>> updateDiscountCode(DiscountCode code);
  }
