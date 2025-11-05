import '../../../domain/entities/vehicle.dart';
import 'equipment_model.dart';

class VehicleModel extends Vehicle {
  VehicleModel(
    super.vehicleID, {
    required super.make,
    required super.model,
    required super.type,
    required super.pricePerDay,
    required super.deposit,
    required super.gearShift,
    required super.driveType,
    required super.fuelType,
    required super.engineCapacity,
    required super.horsePower,
    required super.averageConsumption,
    required super.numberOfSeats,
    required super.numberOfDoors,
    required super.description,
    required super.vehicleImage,
    required super.availabilityStatus,
    required super.equipmentList,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      json["vehicleID"] as int,
      make: json["make"] as String,
      model: json["model"] as String,
      type: json["type"] as String,
      pricePerDay: json["pricePerDay"] as double,
      deposit: json["deposit"] as double,
      gearShift: json["gearShift"] as String,
      driveType: json["driveType"] as String,
      fuelType: json["fuelType"] as String,
      engineCapacity: json["engineCapacity"] as double,
      horsePower: json["horsePower"] as int,
      averageConsumption: json["averageConsumption"] as double,
      numberOfSeats: json["numberOfSeats"] as int,
      numberOfDoors: json["numberOfDoors"] as int,
      description: json["description"] as String,
      vehicleImage: "http://192.168.1.106:8080/images/${json["vehicleImage"] as String}",
      availabilityStatus: json["availabilityStatus"] as String,
      equipmentList:
          (json["equipmentList"] as List<dynamic>).map((e) => EquipmentModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "make": make,
      "model": model,
      "type": type,
      "pricePerDay": pricePerDay,
      "deposit": deposit,
      "gearShift": gearShift,
      "driveType": driveType,
      "fuelType": fuelType,
      "engineCapacity": engineCapacity,
      "horsePower": horsePower,
      "averageConsumption": averageConsumption,
      "numberOfSeats": numberOfSeats,
      "numberOfDoors": numberOfDoors,
      "description": description,
      "vehicleImage": vehicleImage,
      "availabilityStatus": availabilityStatus,
      "equipmentList": equipmentList,
    };
  }
}
