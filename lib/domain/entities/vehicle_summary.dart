import 'package:vrooom/domain/entities/equipment.dart';

class VehicleSummary{
  final int vehicleID;
  final String make;
  final String model;
  final String type;
  final double pricePerDay;
  final String vehicleImage;
  final String description;
  final List<Equipment> equipmentList;
  final String vehicleLocation;

  VehicleSummary({
    required this.vehicleID,
    required this.make,
    required this.model,
    required this.type,
    required this.pricePerDay,
    required this.vehicleImage,
    required this.description,
    required this.equipmentList,
    required this.vehicleLocation,
});
}