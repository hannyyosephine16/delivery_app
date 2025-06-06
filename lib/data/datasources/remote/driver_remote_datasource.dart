import 'package:dio/dio.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/constants/api_endpoints.dart';

class DriverRemoteDataSource {
  final ApiService _apiService;

  DriverRemoteDataSource(this._apiService);

  Future<Response> getAllDrivers({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.getAllDrivers,
      queryParameters: params,
    );
  }

  Future<Response> getDriverById(int driverId) async {
    return await _apiService.get(ApiEndpoints.getDriverById(driverId));
  }

  Future<Response> createDriver(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.createDriver, data: data);
  }

  Future<Response> updateDriver(int driverId, Map<String, dynamic> data) async {
    return await _apiService.put(
      ApiEndpoints.updateDriver(driverId),
      data: data,
    );
  }

  Future<Response> updateDriverProfile(Map<String, dynamic> data) async {
    return await _apiService.put(ApiEndpoints.updateDriverProfile, data: data);
  }

  Future<Response> updateDriverLocation(Map<String, dynamic> data) async {
    return await _apiService.put(ApiEndpoints.updateDriverLocation, data: data);
  }

  Future<Response> getDriverLocation(int driverId) async {
    return await _apiService.get(ApiEndpoints.getDriverLocation(driverId));
  }

  Future<Response> updateDriverStatus(Map<String, dynamic> data) async {
    return await _apiService.put(ApiEndpoints.updateDriverStatus, data: data);
  }

  Future<Response> getDriverOrders({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.driverOrders,
      queryParameters: params,
    );
  }

  Future<Response> deleteDriver(int driverId) async {
    return await _apiService.delete(ApiEndpoints.deleteDriver(driverId));
  }

  // Driver Requests
  Future<Response> getDriverRequests({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.getDriverRequests,
      queryParameters: params,
    );
  }

  Future<Response> getDriverRequestById(int requestId) async {
    return await _apiService.get(ApiEndpoints.getDriverRequestById(requestId));
  }

  Future<Response> respondToDriverRequest(
    int requestId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.put(
      ApiEndpoints.respondToDriverRequest(requestId),
      data: data,
    );
  }
}
