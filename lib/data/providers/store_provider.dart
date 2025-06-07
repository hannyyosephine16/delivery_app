import 'package:dio/dio.dart';
import 'package:del_pick/core/services/api/api_service.dart';
import 'package:del_pick/core/constants/api_endpoints.dart';
import 'package:get/get.dart' as getx;

class StoreProvider {
  final ApiService _apiService = getx.Get.find<ApiService>();

  Future<Response> getAllStores({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.getAllStores,
      queryParameters: params,
    );
  }

  Future<Response> getNearbyStores({
    required double latitude,
    required double longitude,
  }) async {
    final params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };
    return await _apiService.get(
      ApiEndpoints.getAllStores,
      queryParameters: params,
    );
  }
}
