import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/vehicle_summary.dart';
import 'package:vrooom/domain/repositories/vehicle_repository.dart';

class GetAllVehiclesUseCase {
  final VehicleRepository vehicleRepository;

  GetAllVehiclesUseCase(this.vehicleRepository);

  Future<Either<String, List<VehicleSummary>>> call() async{
    return await vehicleRepository.getAllVehicles();
  }
}