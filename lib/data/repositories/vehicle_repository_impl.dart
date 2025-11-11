import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vrooom/data/models/vehicle/vehicle_model.dart';
import 'package:vrooom/data/models/vehicle/vehicle_summary_model.dart';
import 'package:vrooom/data/sources/vehicle/vehicle_api_service.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/domain/repositories/vehicle_repository.dart';

import '../models/vehicle/equipment_model.dart';

class VehicleRepositoryImpl extends VehicleRepository {
  final VehicleApiService vehicleApiService;

  VehicleRepositoryImpl(this.vehicleApiService);

  @override
  Future<Either<String, List<VehicleSummaryModel>>> getAllVehicles() async {
    try {
      return Right(await vehicleApiService.getAllVehicles());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Vehicle>> getVehicleById(int vehicleId) async {
    try {
      return Right(await vehicleApiService.getVehicleById(vehicleId));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, VehicleModel>> addNewVehicle({
    required Vehicle vehicle,
    required File imageFile,
  }) async {
    try {
      return Right(await vehicleApiService.addNewVehicle(vehicle: VehicleModel.fromEntity(vehicle), imageFile: imageFile));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<String>>> getRentalLocations() async {
    try{
      return Right(await vehicleApiService.getRentalLocations());
    } catch (e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<EquipmentModel>>> getAvailableEquipment() async {
    try{
      return Right(await vehicleApiService.getAvailableEquipment());
    } catch (e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<VehicleSummaryModel>>> getAvailableVehiclesBetweenDates(DateTimeRange dateRange) async {
    try{
      return Right(await vehicleApiService.getAvailableVehiclesBetweenDates(dateRange));
    } catch (e){
    return Left(e.toString());
    }
  }
}
