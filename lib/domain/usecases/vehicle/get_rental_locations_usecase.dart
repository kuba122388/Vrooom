import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/repositories/vehicle_repository.dart';

class GetRentalLocationsUseCase{
  final VehicleRepository vehicleRepository;

  GetRentalLocationsUseCase(this.vehicleRepository);

  Future<Either<String, List<String>>> call (){
    return vehicleRepository.getRentalLocations();
  }
}