import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/domain/entities/vehicle_summary.dart';

abstract class VehicleRepository {
  Future<Either<String, List<VehicleSummary>>> getAllVehicles();

  Future<Either<String, Vehicle>> getVehicleById(int vehicleId);

  Future<Either<String, Vehicle>> addNewVehicle({
    required Vehicle vehicle,
    required File imageFile,
  });

  Future<Either<String, Vehicle>> updateVehicle({
    required Vehicle vehicle,
    File? imageFile,
  });

  Future<Either<String, List<String>>> getRentalLocations();

  Future<Either<String, List<Vehicle>>> getAllVehiclesWithDetails();
}
