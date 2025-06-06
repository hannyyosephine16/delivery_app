import 'package:dio/dio.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/constants/api_endpoints.dart';

class OrderRemoteDataSource {
  final ApiService _apiService;

  OrderRemoteDataSource(this._apiService);

  Future<Response> createOrder(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.createOrder, data: data);
  }

  Future<Response> getOrders({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.orders,
      queryParameters: params,
    );
  }

  Future<Response> getUserOrders({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.userOrders,
      queryParameters: params,
    );
  }

  Future<Response> getStoreOrders({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.storeOrders,
      queryParameters: params,
    );
  }

  Future<Response> getOrderById(int orderId) async {
    return await _apiService.get(ApiEndpoints.getOrderById(orderId));
  }

  Future<Response> updateOrderStatus(Map<String, dynamic> data) async {
    return await _apiService.put(ApiEndpoints.updateOrderStatus, data: data);
  }

  Future<Response> processOrder(int orderId, Map<String, dynamic> data) async {
    return await _apiService.put(
      ApiEndpoints.processOrder(orderId),
      data: data,
    );
  }

  Future<Response> cancelOrder(int orderId) async {
    return await _apiService.put(ApiEndpoints.cancelOrder(orderId));
  }

  Future<Response> createReview(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.createReview, data: data);
  }
}
