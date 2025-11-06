import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../entities/vehicle.dart';
import '../../repositories/vehicle_repository.dart';

class AddNewVehiclesUseCase {
  final VehicleRepository vehicleRepository;

  AddNewVehiclesUseCase(this.vehicleRepository);

  Future<Either<String, Vehicle>> call({
    required Vehicle vehicle,
    required File imageFile,
  }) async {
    return await vehicleRepository.addNewVehicle(
      vehicle: vehicle,
      imageFile: imageFile,
    );
  }
}
