import 'package:vrooom/domain/entities/insurance.dart';

class InsuranceModel extends Insurance {
  InsuranceModel({
    required super.insuranceID,
    required super.insuranceType,
    required super.insuranceCost,
    required super.description,
  });

  factory InsuranceModel.fromEntity(Insurance entity) {
    return InsuranceModel(
      insuranceID: entity.insuranceID,
      insuranceType: entity.insuranceType,
      insuranceCost: entity.insuranceCost,
      description: entity.description,
    );
  }

  factory InsuranceModel.fromJson(Map<String, dynamic> json) {
    return InsuranceModel(
      insuranceID: json['insuranceID'] as int,
      insuranceType: json['insuranceType'] as String,
      insuranceCost: (json['insuranceCost'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'insuranceID': insuranceID,
      'insuranceType': insuranceType,
      'insuranceCost': insuranceCost,
      'description': description,
    };
  }
}
