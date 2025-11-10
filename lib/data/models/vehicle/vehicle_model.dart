import '../../../core/configs/network/network_config.dart';
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
    required super.mileage,
    required super.vehicleImage,
    required super.availabilityStatus,
    required super.wheelSize,
    required super.equipmentList,
    required super.vehicleLocation,
  });

  factory VehicleModel.fromEntity(Vehicle entity) {
    final convertedEquipment =
        entity.equipmentList.map((e) => EquipmentModel.fromEntity(e)).toList();

    return VehicleModel(entity.vehicleID,
        make: entity.make,
        model: entity.model,
        type: entity.type,
        pricePerDay: entity.pricePerDay,
        deposit: entity.deposit,
        gearShift: entity.gearShift,
        driveType: entity.driveType,
        fuelType: entity.fuelType,
        engineCapacity: entity.engineCapacity,
        horsePower: entity.horsePower,
        averageConsumption: entity.averageConsumption,
        numberOfSeats: entity.numberOfSeats,
        numberOfDoors: entity.numberOfDoors,
        description: entity.description,
        mileage: entity.mileage,
        vehicleImage: entity.vehicleImage,
        availabilityStatus: entity.availabilityStatus,
        wheelSize: entity.wheelSize,
        equipmentList: convertedEquipment,
        vehicleLocation: entity.vehicleLocation);
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      json["vehicleID"] as int,
      make: json["make"] as String,
      model: json["model"] as String,
      type: json["type"] as String,
      pricePerDay: json["pricePerDay"] as double,
      deposit: json["deposit"] as int,
      gearShift: json["gearShift"] as String,
      driveType: json["driveType"] as String,
      fuelType: json["fuelType"] as String,
      engineCapacity: json["engineCapacity"] as double,
      horsePower: json["horsePower"] as int,
      averageConsumption: json["averageConsumption"] as double,
      wheelSize: json["wheelSize"] as int,
      numberOfSeats: json["numberOfSeats"] as int,
      numberOfDoors: json["numberOfDoors"] as int,
      description: json["description"] as String,
      mileage: json["mileage"] as int,
      vehicleImage:
          "${NetworkConfig.vehicleImages}/${json["vehicleImage"] as String}",
      availabilityStatus: json["availabilityStatus"] as String,
      equipmentList: (json["equipmentList"] as List<dynamic>)
          .map((e) => EquipmentModel.fromJson(e))
          .toList(),
      vehicleLocation: json["carLocation"] as String,
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
      "wheelSize": wheelSize,
      "numberOfSeats": numberOfSeats,
      "numberOfDoors": numberOfDoors,
      "description": description,
      "mileage": mileage,
      "vehicleImage": vehicleImage,
      "equipment": equipmentList
          .map((e) => EquipmentModel.fromEntity(e).toJson())
          .toList(),
      "carLocation": vehicleLocation
    };
  }
}
