import 'package:dio/dio.dart';
import 'package:del_pick/core/services/api/api_service.dart';
import 'package:del_pick/core/constants/api_endpoints.dart';

class StoreRemoteDataSource {
  final ApiService _apiService;

  StoreRemoteDataSource(this._apiService);

  Future<Response> getAllStores({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.getAllStores,
      queryParameters: params,
    );
  }

  Future<Response> getNearbyStores({
    required double latitude,
    required double longitude,
    Map<String, dynamic>? params,
  }) async {
    final queryParams = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      ...?params,
    };
    return await _apiService.get(
      ApiEndpoints.getAllStores,
      queryParameters: queryParams,
    );
  }
}
