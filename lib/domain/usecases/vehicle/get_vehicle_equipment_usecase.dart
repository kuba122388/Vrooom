import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/equipment.dart';

import '../../repositories/vehicle_repository.dart';

class GetVehicleEquipmentUseCase {
  final VehicleRepository vehicleRepository;

  GetVehicleEquipmentUseCase(this.vehicleRepository);

  Future<Either<String, List<Equipment>>> call() async {
    return await vehicleRepository.getAvailableEquipment();
  }
}