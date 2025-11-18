import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/vehicle.dart';

import '../../repositories/vehicle_repository.dart';

class GetVehicleByIdUseCase {
  final VehicleRepository repository;

  GetVehicleByIdUseCase(this.repository);

  Future<Either<String, Vehicle>> call(int vehicleId) async {
    return await repository.getVehicleById(vehicleId);
  }
}
