import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vrooom/domain/repositories/vehicle_repository.dart';

import '../../entities/vehicle_summary.dart';

class GetAvailableVehiclesBetweenDatesUseCase{
  final VehicleRepository vehicleRepository;

  GetAvailableVehiclesBetweenDatesUseCase(this.vehicleRepository);

  Future<Either<String, List<VehicleSummary>>> call(DateTimeRange dateRange) async{
    return vehicleRepository.getAvailableVehiclesBetweenDates(dateRange);
  }

}