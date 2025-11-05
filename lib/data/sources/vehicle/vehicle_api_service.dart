import 'package:dio/dio.dart';
import 'package:vrooom/data/models/vehicle/vehicle_model.dart';
import 'package:vrooom/data/models/vehicle/vehicle_summary_model.dart';

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

  Future<VehicleModel> getVehicleById(int vehicleId) async{
    try{
      final response = await _dio.get("$_vehicleApi/$vehicleId/details");

      if(response.statusCode == 200){
        return VehicleModel.fromJson(response.data);
      } else{
        throw ("Vehicle with id: $vehicleId does not exist.");
      }

    } on DioException catch (e) {
      throw ("Network Error: ${e.message}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

}
