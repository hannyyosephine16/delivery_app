// lib/core/services/api/tracking_service.dart
// import 'package:dio/dio.dart';
// import 'package:delivery_app/core/services/api/api_service.dart';
// import 'package:delivery_app/core/constants/api_endpoints.dart';
//
// class TrackingApiService {
//   final ApiService _apiService;
//
//   TrackingApiService(this._apiService);
//
//   Future<Response> getTrackingInfo(int orderId) async {
//     return await _apiService.get('${ApiEndpoints.tracking}/$orderId');
//   }
//
//   Future<Response> startDelivery(int orderId) async {
//     return await _apiService.put('${ApiEndpoints.tracking}/$orderId/start');
//   }
//
//   Future<Response> completeDelivery(int orderId) async {
//     return await _apiService.put('${ApiEndpoints.tracking}/$orderId/complete');
//   }
// }
// lib/core/services/api/tracking_service.dart
import 'package:get/get.dart';

import '../../constants/api_endpoints.dart';
import 'api_service.dart';

class TrackingService extends GetxService {
  final ApiService _apiService;

  /// Mendapatkan data tracking untuk order tertentu
  Future<Response> getTrackingData(int orderId) async {
    try {
      final response =
          await _apiService.get('${ApiEndpoints.tracking}/$orderId');

      if (response.isSuccessful) {
        final trackingData = TrackingData.fromJson(response.data['data']);
        return ApiResponse.success(trackingData);
      } else {
        return ApiResponse.error(
            response.message ?? 'Gagal mengambil data tracking');
      }
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: $e');
    }
  }

  /// Memulai pengantaran (untuk driver)
  Future<ApiResponse<Map<String, dynamic>>> startDelivery(int orderId) async {
    try {
      final response = await _apiService.post('/tracking/$orderId/start', {});

      if (response.isSuccessful) {
        return ApiResponse.success(response.data['data']);
      } else {
        return ApiResponse.error(
            response.message ?? 'Gagal memulai pengantaran');
      }
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: $e');
    }
  }

  /// Menyelesaikan pengantaran (untuk driver)
  Future<ApiResponse<Map<String, dynamic>>> completeDelivery(
      int orderId) async {
    try {
      final response =
          await _apiService.post('/tracking/$orderId/complete', {});

      if (response.isSuccessful) {
        return ApiResponse.success(response.data['data']);
      } else {
        return ApiResponse.error(
            response.message ?? 'Gagal menyelesaikan pengantaran');
      }
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: $e');
    }
  }

  /// Update lokasi driver (perlu endpoint baru di backend)
  Future<ApiResponse<void>> updateDriverLocation(
      double latitude, double longitude) async {
    try {
      final response = await _apiService.post('/driver/location', {
        'latitude': latitude,
        'longitude': longitude,
      });

      if (response.isSuccessful) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error(response.message ?? 'Gagal update lokasi');
      }
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: $e');
    }
  }
}
