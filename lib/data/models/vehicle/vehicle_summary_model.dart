import 'package:vrooom/core/configs/network/network_config.dart';
import 'package:vrooom/domain/entities/vehicle_summary.dart';

import 'equipment_model.dart';

class VehicleSummaryModel extends VehicleSummary {
  VehicleSummaryModel({
    required super.vehicleID,
    required super.make,
    required super.model,
    required super.type,
    required super.pricePerDay,
    required super.vehicleImage,
    required super.description,
    required super.equipmentList,
    required super.vehicleLocation,
  });

  factory VehicleSummaryModel.fromJson(Map<String, dynamic> json) {
    return VehicleSummaryModel(
      vehicleID: json["vehicleID"] as int,
      make: json["make"] as String,
      model: json["model"] as String,
      type: json["type"] as String,
      pricePerDay: json["pricePerDay"] as double,
      vehicleImage:
          "${NetworkConfig.vehicleImages}/${json["vehicleImage"] as String}",
      description: json["description"] as String,
      equipmentList: (json["equipmentList"] as List<dynamic>)
          .map((e) => EquipmentModel.fromJson(e))
          .toList(),
      vehicleLocation: json["carLocation"] as String,
    );
  }
}
