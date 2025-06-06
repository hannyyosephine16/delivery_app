// lib/core/services/api/driver_service.dart
import 'package:dio/dio.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/constants/api_endpoints.dart';

class DriverApiService {
  final ApiService _apiService;

  DriverApiService(this._apiService);

  Future<Response> getDrivers({Map<String, dynamic>? queryParams}) async {
    return await _apiService.get(
      ApiEndpoints.drivers,
      queryParameters: queryParams,
    );
  }

  Future<Response> getDriverDetail(int driverId) async {
    return await _apiService.get('${ApiEndpoints.drivers}/$driverId');
  }

  Future<Response> createDriver(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.drivers, data: data);
  }

  Future<Response> updateDriver(int driverId, Map<String, dynamic> data) async {
    return await _apiService.put(
      '${ApiEndpoints.drivers}/$driverId',
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
    return await _apiService.get('${ApiEndpoints.drivers}/$driverId/location');
  }

  Future<Response> updateDriverStatus(Map<String, dynamic> data) async {
    return await _apiService.put(ApiEndpoints.updateDriverStatus, data: data);
  }

  Future<Response> getDriverOrders({Map<String, dynamic>? queryParams}) async {
    return await _apiService.get(
      ApiEndpoints.driverOrders,
      queryParameters: queryParams,
    );
  }

  Future<Response> deleteDriver(int driverId) async {
    return await _apiService.delete('${ApiEndpoints.drivers}/$driverId');
  }

  // Driver Requests
  Future<Response> getDriverRequests({
    Map<String, dynamic>? queryParams,
  }) async {
    return await _apiService.get(
      ApiEndpoints.driverRequests,
      queryParameters: queryParams,
    );
  }

  Future<Response> getDriverRequestDetail(int requestId) async {
    return await _apiService.get('${ApiEndpoints.driverRequests}/$requestId');
  }

  Future<Response> respondToDriverRequest(
    int requestId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.put(
      '${ApiEndpoints.driverRequests}/$requestId/respond',
      data: data,
    );
  }
}
