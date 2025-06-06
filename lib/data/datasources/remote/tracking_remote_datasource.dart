import 'package:dio/dio.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/constants/api_endpoints.dart';

class TrackingRemoteDataSource {
  final ApiService _apiService;

  TrackingRemoteDataSource(this._apiService);

  Future<Response> getTrackingInfo(int orderId) async {
    return await _apiService.get(ApiEndpoints.getTrackingData(orderId));
  }

  Future<Response> startDelivery(int orderId) async {
    return await _apiService.put(ApiEndpoints.startDelivery(orderId));
  }

  Future<Response> completeDelivery(int orderId) async {
    return await _apiService.put(ApiEndpoints.completeDelivery(orderId));
  }
}
