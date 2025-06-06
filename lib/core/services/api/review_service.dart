// lib/core/services/api/review_service.dart
import 'package:dio/dio.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/constants/api_endpoints.dart';

class ReviewApiService {
  final ApiService _apiService;

  ReviewApiService(this._apiService);

  Future<Response> createOrderReview(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.createReview, data: data);
  }

  Future<Response> getOrderReviews(int orderId) async {
    return await _apiService.get('${ApiEndpoints.reviews}/order/$orderId');
  }

  Future<Response> getStoreReviews(
    int storeId, {
    Map<String, dynamic>? queryParams,
  }) async {
    return await _apiService.get(
      '${ApiEndpoints.reviews}/store/$storeId',
      queryParameters: queryParams,
    );
  }

  Future<Response> getDriverReviews(
    int driverId, {
    Map<String, dynamic>? queryParams,
  }) async {
    return await _apiService.get(
      '${ApiEndpoints.reviews}/driver/$driverId',
      queryParameters: queryParams,
    );
  }
}
