import 'package:dio/dio.dart';
import 'package:del_pick/core/services/api/api_service.dart';
import 'package:del_pick/core/constants/api_endpoints.dart';

class MenuRemoteDataSource {
  final ApiService _apiService;

  MenuRemoteDataSource(this._apiService);

  Future<Response> getAllMenuItems({Map<String, dynamic>? params}) async {
    return await _apiService.get(
      ApiEndpoints.getAllMenuItems,
      queryParameters: params,
    );
  }

  Future<Response> getMenuItemsByStoreId(
    int storeId, {
    Map<String, dynamic>? params,
  }) async {
    return await _apiService.get(
      ApiEndpoints.getMenuItemsByStoreId(storeId),
      queryParameters: params,
    );
  }

  Future<Response> getMenuItemById(int menuItemId) async {
    return await _apiService.get(ApiEndpoints.getMenuItemById(menuItemId));
  }

  Future<Response> createMenuItem(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.createMenuItem, data: data);
  }

  Future<Response> updateMenuItem(
    int menuItemId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.put(
      ApiEndpoints.updateMenuItem(menuItemId),
      data: data,
    );
  }

  Future<Response> deleteMenuItem(int menuItemId) async {
    return await _apiService.delete(ApiEndpoints.deleteMenuItem(menuItemId));
  }
}
