import 'package:dio/dio.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/constants/api_endpoints.dart';
import 'package:get/get.dart' as getx;

class OrderProvider {
  final ApiService _apiService = getx.Get.find<ApiService>();

  Future<Response> createOrder(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.createOrder, data: data);
  }

  Future<Response> getOrdersByUser({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.userOrders,
      queryParameters: params,
    );
  }

  Future<Response> getOrdersByStore({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.storeOrders,
      queryParameters: params,
    );
  }

  Future<Response> getOrderDetail(int orderId) async {
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
