import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/domain/repositories/vehicle_repository.dart';

class GetAllVehiclesWithDetailsUseCase {
  final VehicleRepository vehicleRepository;

  GetAllVehiclesWithDetailsUseCase(this.vehicleRepository);

  Future<Either<String, List<Vehicle>>> call() async {
    return await vehicleRepository.getAllVehiclesWithDetails();
  }
}
