import 'package:vrooom/domain/entities/vehicle_summary.dart';

class VehicleSummaryModel extends VehicleSummary {
  VehicleSummaryModel({
    required super.vehicleID,
    required super.make,
    required super.model,
    required super.type,
    required super.pricePerDay,
    required super.vehicleImage,
    required super.description,
  });

  factory VehicleSummaryModel.fromJson(Map<String, dynamic> json) {
    return VehicleSummaryModel(
      vehicleID: json["vehicleID"] as int,
      make: json["make"] as String,
      model: json["model"] as String,
      type: json["type"] as String,
      pricePerDay: json["pricePerDay"] as double,
      vehicleImage: "http://192.168.1.12:8080/images/${json["vehicleImage"] as String}",
      description: json["description"] as String,
    );
  }
}
