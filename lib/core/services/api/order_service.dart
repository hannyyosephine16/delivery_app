// lib/core/services/api/order_service.dart
import 'package:dio/dio.dart';
import 'package:del_pick/core/services/api/api_service.dart';
import 'package:del_pick/core/constants/api_endpoints.dart';

class OrderApiService {
  final ApiService _apiService;

  OrderApiService(this._apiService);

  Future<Response> createOrder(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.orders, data: data);
  }

  Future<Response> getOrders({Map<String, dynamic>? queryParams}) async {
    return await _apiService.get(
      ApiEndpoints.orders,
      queryParameters: queryParams,
    );
  }

  Future<Response> getUserOrders({Map<String, dynamic>? queryParams}) async {
    return await _apiService.get(
      ApiEndpoints.userOrders,
      queryParameters: queryParams,
    );
  }

  Future<Response> getStoreOrders({Map<String, dynamic>? queryParams}) async {
    return await _apiService.get(
      ApiEndpoints.storeOrders,
      queryParameters: queryParams,
    );
  }

  Future<Response> getOrderDetail(int orderId) async {
    return await _apiService.get('${ApiEndpoints.orders}/$orderId');
  }

  Future<Response> updateOrderStatus(Map<String, dynamic> data) async {
    return await _apiService.put(ApiEndpoints.updateOrderStatus, data: data);
  }

  Future<Response> processOrder(int orderId, Map<String, dynamic> data) async {
    return await _apiService.put(
      '${ApiEndpoints.orders}/$orderId/process',
      data: data,
    );
  }

  Future<Response> cancelOrder(int orderId) async {
    return await _apiService.put('${ApiEndpoints.orders}/$orderId/cancel');
  }

  Future<Response> createReview(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.createReview, data: data);
  }
}
