import 'package:vrooom/domain/entities/equipment.dart';

class EquipmentModel extends Equipment {
  EquipmentModel({
    required super.equipmentID,
    required super.equipmentName,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      equipmentID: json["equipmentID"] as int,
      equipmentName: json["equipmentName"] as String,
    );
  }
}
