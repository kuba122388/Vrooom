import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vrooom/data/models/vehicle/equipment_model.dart';
import 'package:vrooom/data/models/vehicle/vehicle_model.dart';
import 'package:vrooom/data/models/vehicle/vehicle_summary_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:vrooom/domain/entities/vehicle.dart';

class VehicleApiService {
  final Dio _dio;
  final String _vehicleApi = "/api/vehicles";

  VehicleApiService(this._dio);

  Future<List<VehicleSummaryModel>> getAllVehicles() async {
    try {
      final response = await _dio.get(_vehicleApi);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => VehicleSummaryModel.fromJson(json)).toList();
        } else {
          throw Exception("Invalid response format — expected a list");
        }
      } else {
        throw Exception("Error while fetching vehicles");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<List<VehicleSummaryModel>> getAvailableVehiclesBetweenDates(
      DateTimeRange dateRange) async {
    try {
      final response = await _dio.get(_vehicleApi, queryParameters: {
        "from": DateFormat('yyyy-MM-dd').format(dateRange.start),
        "to": DateFormat('yyyy-MM-dd').format(dateRange.end),
      });

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => VehicleSummaryModel.fromJson(json)).toList();
        } else {
          throw Exception("Invalid response format — expected a list");
        }
      } else {
        throw Exception("Error while fetching vehicles");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<VehicleModel> getVehicleById(int vehicleId) async {
    try {
      final response = await _dio.get("$_vehicleApi/$vehicleId/details");

      if (response.statusCode == 200) {
        return VehicleModel.fromJson(response.data);
      } else {
        throw ("Vehicle with id: $vehicleId does not exist.");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<List<String>> getRentalLocations() async {
    try {
      final response = await _dio.get("$_vehicleApi/locations");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => json["rentalAddress"] as String).toList();
        }
        throw "There was a problem with location fetching.";
      } else {
        throw ("Problem with addresses fetching");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<VehicleModel> addNewVehicle({
    required VehicleModel vehicle,
    required File imageFile,
  }) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "vehicle": MultipartFile.fromString(
          jsonEncode(vehicle.toJson()),
          contentType: MediaType.parse("application/json"),
        ),
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      print("=== FormData fields ===");
      for (var field in formData.fields) {
        print("${field.key}: ${field.value}");
      }
      final response = await _dio.post(
        _vehicleApi,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VehicleModel.fromJson(response.data);
      } else {
        throw ("Error adding vehicle.");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<List<Vehicle>> getAllVehiclesWithDetails() async {
    try {
      final response = await _dio.get(_vehicleApi);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => VehicleModel.fromJson(json)).toList();
        } else {
          throw Exception("Invalid response format — expected a list");
        }
      } else {
        throw Exception("Error while fetching vehicles");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<List<EquipmentModel>> getAvailableEquipment() async {
    try {
      final response = await _dio.get("$_vehicleApi/equipment");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => EquipmentModel.fromJson(json)).toList();
        }
        throw ("There was a problem with equipment fetching.");
      } else {
        throw ("Problem with fetching");
      }
    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }
}
