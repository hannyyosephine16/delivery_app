// lib/data/providers/tracking_provider.dart
import 'package:dio/dio.dart';
import 'package:del_pick/core/services/api/api_service.dart';
import 'package:del_pick/core/constants/api_endpoints.dart';
import 'package:get/get.dart' as getx;

class TrackingProvider {
  final ApiService _apiService = getx.Get.find<ApiService>();

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
