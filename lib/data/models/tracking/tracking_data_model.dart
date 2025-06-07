// lib/core/services/api/tracking_service.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/constants/api_endpoints.dart';
import 'package:delivery_app/core/utils/result.dart';
import 'package:delivery_app/data/models/tracking/tracking_data_model.dart';

class TrackingService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  /// Get tracking data for a specific order
  Future<Result<TrackingData>> getTrackingData(int orderId) async {
    try {
      final response =
          await _apiService.get(ApiEndpoints.getTrackingData(orderId));

      if (response.statusCode == 200) {
        final trackingData = TrackingData.fromJson(response.data['data']);
        return Result.success(trackingData);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to get tracking data',
        );
      }
    } catch (e) {
      return Result.failure('An error occurred: $e');
    }
  }

  /// Start delivery (for driver)
  Future<Result<Map<String, dynamic>>> startDelivery(int orderId) async {
    try {
      final response =
          await _apiService.put(ApiEndpoints.startDelivery(orderId));

      if (response.statusCode == 200) {
        return Result.success(response.data['data']);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to start delivery',
        );
      }
    } catch (e) {
      return Result.failure('An error occurred: $e');
    }
  }

  /// Complete delivery (for driver)
  Future<Result<Map<String, dynamic>>> completeDelivery(int orderId) async {
    try {
      final response =
          await _apiService.put(ApiEndpoints.completeDelivery(orderId));

      if (response.statusCode == 200) {
        return Result.success(response.data['data']);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to complete delivery',
        );
      }
    } catch (e) {
      return Result.failure('An error occurred: $e');
    }
  }

  /// Update driver location (needs new endpoint in backend)
  Future<Result<void>> updateDriverLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _apiService.post('/driver/location', data: {
        'latitude': latitude,
        'longitude': longitude,
      });

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to update location',
        );
      }
    } catch (e) {
      return Result.failure('An error occurred: $e');
    }
  }
}
