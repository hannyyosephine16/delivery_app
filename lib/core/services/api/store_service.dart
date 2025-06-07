// lib/core/services/api/store_service.dart
import 'package:dio/dio.dart';
import 'package:del_pick/core/services/api/api_service.dart';
import 'package:del_pick/core/constants/api_endpoints.dart';

class StoreApiService {
  final ApiService _apiService;

  StoreApiService(this._apiService);

  Future<Response> getStores({Map<String, dynamic>? queryParams}) async {
    return await _apiService.get(
      ApiEndpoints.stores,
      queryParameters: queryParams,
    );
  }

  Future<Response> getStoreDetail(int storeId) async {
    return await _apiService.get('${ApiEndpoints.stores}/$storeId');
  }

  Future<Response> createStore(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.stores, data: data);
  }

  Future<Response> updateStore(int storeId, Map<String, dynamic> data) async {
    return await _apiService.put('${ApiEndpoints.stores}/$storeId', data: data);
  }

  Future<Response> updateStoreProfile(Map<String, dynamic> data) async {
    return await _apiService.put(ApiEndpoints.updateStoreProfile, data: data);
  }

  Future<Response> updateStoreStatus(
    int storeId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.patch(
      '${ApiEndpoints.stores}/$storeId/status',
      data: data,
    );
  }

  Future<Response> deleteStore(int storeId) async {
    return await _apiService.delete('${ApiEndpoints.stores}/$storeId');
  }
}
