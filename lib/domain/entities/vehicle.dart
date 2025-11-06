import 'package:vrooom/domain/entities/equipment.dart';

class Vehicle {
  final int vehicleID;
  final String make;
  final String model;
  final String type;
  final double pricePerDay;
  final int deposit;
  final String gearShift;
  final String driveType;
  final String fuelType;
  final double engineCapacity;
  final int horsePower;
  final double averageConsumption;
  final int numberOfSeats;
  final int numberOfDoors;
  final String description;
  final String vehicleImage;
  final String availabilityStatus;
  final int wheelSize;
  final List<Equipment> equipmentList;

  Vehicle(this.vehicleID, {
    required this.make,
    required this.model,
    required this.type,
    required this.pricePerDay,
    required this.deposit,
    required this.gearShift,
    required this.driveType,
    required this.fuelType,
    required this.engineCapacity,
    required this.horsePower,
    required this.averageConsumption,
    required this.numberOfSeats,
    required this.numberOfDoors,
    required this.description,
    required this.vehicleImage,
    required this.availabilityStatus,
    required this.equipmentList,
    required this.wheelSize,
  });
}
