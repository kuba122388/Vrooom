import 'package:dartz/dartz.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/domain/entities/vehicle_summary.dart';

abstract class VehicleRepository {
  Future<Either<String, List<VehicleSummary>>> getAllVehicles();
  Future<Either<String, Vehicle>> getVehicleById(int vehicleId);
}