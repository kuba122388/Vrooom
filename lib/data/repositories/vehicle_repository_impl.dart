import 'package:dartz/dartz.dart';
import 'package:vrooom/data/models/vehicle/vehicle_summary_model.dart';
import 'package:vrooom/data/sources/vehicle/vehicle_api_service.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl extends VehicleRepository{
  final VehicleApiService vehicleApiService;

  VehicleRepositoryImpl(this.vehicleApiService);

  @override
  Future<Either<String, List<VehicleSummaryModel>>> getAllVehicles() async {
    try{
      return Right(await vehicleApiService.getAllVehicles());
    } catch (e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Vehicle>> getVehicleById(int vehicleId) async {
    try{
      return Right(await vehicleApiService.getVehicleById(vehicleId));
    } catch (e) {
      return Left(e.toString());
    }
  }



}