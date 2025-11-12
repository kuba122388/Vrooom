import 'package:vrooom/domain/entities/discount_code.dart';

class DiscountCodeModel extends DiscountCode {
  DiscountCodeModel({
    required super.id,
    required super.code,
    required super.value,
    required super.percentage,
    required super.active,
  });

  factory DiscountCodeModel.fromJson(Map<String, dynamic> json) {
    return DiscountCodeModel(
      id: json["id"] as int?,
      code: json["code"] as String?,
      value: json["value"] as double?,
      percentage: json["percentage"] as bool?,
      active: json["active"] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "value": value,
      "percentage": percentage,
      "active": active,
    };
  }
}