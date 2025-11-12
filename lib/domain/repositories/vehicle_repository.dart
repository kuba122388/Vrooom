import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vrooom/domain/entities/equipment.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/domain/entities/vehicle_summary.dart';

abstract class VehicleRepository {
  Future<Either<String, List<VehicleSummary>>> getAllVehicles();

  Future<Either<String, Vehicle>> getVehicleById(int vehicleId);

  Future<Either<String, Vehicle>> addNewVehicle({
    required Vehicle vehicle,
    required File imageFile,
  });

  Future<Either<String, List<String>>> getRentalLocations();

  Future<Either<String, List<Equipment>>> getAvailableEquipment();

  Future<Either<String, List<VehicleSummary>>> getAvailableVehiclesBetweenDates(
      DateTimeRange dateRange);

  Future<Either<String, List<Vehicle>>> getAllVehiclesWithDetails();
}
