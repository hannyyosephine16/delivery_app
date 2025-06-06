// lib/core/services/api/customer_service.dart
import 'package:dio/dio.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/constants/api_endpoints.dart';

class CustomerApiService {
  final ApiService _apiService;

  CustomerApiService(this._apiService);

  Future<Response> getCustomers({Map<String, dynamic>? queryParams}) async {
    return await _apiService.get(
      ApiEndpoints.customers,
      queryParameters: queryParams,
    );
  }

  Future<Response> getCustomerDetail(int customerId) async {
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
