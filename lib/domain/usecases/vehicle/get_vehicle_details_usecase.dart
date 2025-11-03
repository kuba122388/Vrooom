import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/vehicle.dart';

import '../../repositories/vehicle_repository.dart';

class GetVehicleDetailsUseCase{
  final VehicleRepository repository;

  GetVehicleDetailsUseCase(this.repository);

  Future<Either<String, Vehicle>> call(int vehicleId) async{
    if(vehicleId <= 0){
      return const Left("Vehicles do not have ids below or equal to 0.");
    }
    return await repository.getVehicleById(vehicleId);
  }

}