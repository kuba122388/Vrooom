import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/domain/repositories/vehicle_repository.dart';

class UpdateVehicleUseCase {
  final VehicleRepository vehicleRepository;

  UpdateVehicleUseCase(this.vehicleRepository);

  Future<Either<String, Vehicle>> call({
    required Vehicle vehicle,
    File? imageFile
  }) async {
    return await vehicleRepository.updateVehicle(vehicle: vehicle, imageFile: imageFile);
  }
}