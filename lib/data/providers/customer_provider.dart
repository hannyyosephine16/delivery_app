import 'package:dio/dio.dart';
import 'package:del_pick/core/services/api/api_service.dart';
import 'package:del_pick/core/constants/api_endpoints.dart';
import 'package:get/get.dart' as getx;

class CustomerProvider {
  final ApiService _apiService = getx.Get.find<ApiService>();

  Future<Response> getAllCustomers({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.customers,
      queryParameters: params,
    );
  }

  Future<Response> getCustomerById(int customerId) async {
    return await _apiService.get('${ApiEndpoints.customers}/$customerId');
  }

  Future<Response> createCustomer(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.customers, data: data);
  }

  Future<Response> updateCustomer(
    int customerId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.put(
      '${ApiEndpoints.customers}/$customerId',
      data: data,
    );
  }

  Future<Response> deleteCustomer(int customerId) async {
    return await _apiService.delete('${ApiEndpoints.customers}/$customerId');
  }
}
