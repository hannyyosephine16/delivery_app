// lib/core/services/api/menu_item_service.dart
import 'package:dio/dio.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/constants/api_endpoints.dart';

class MenuItemApiService {
  final ApiService _apiService;

  MenuItemApiService(this._apiService);

  Future<Response> getMenuItems({Map<String, dynamic>? queryParams}) async {
    return await _apiService.get(
      ApiEndpoints.menuItems,
      queryParameters: queryParams,
    );
  }

  Future<Response> getMenuItemsByStore(
    int storeId, {
    Map<String, dynamic>? queryParams,
  }) async {
    return await _apiService.get(
      '${ApiEndpoints.menuItems}/store/$storeId',
      queryParameters: queryParams,
    );
  }

  Future<Response> getMenuItemDetail(int menuItemId) async {
    return await _apiService.get('${ApiEndpoints.menuItems}/$menuItemId');
  }

  Future<Response> createMenuItem(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.menuItems, data: data);
  }

  Future<Response> updateMenuItem(
    int menuItemId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.put(
      '${ApiEndpoints.menuItems}/$menuItemId',
      data: data,
    );
  }

  Future<Response> deleteMenuItem(int menuItemId) async {
    return await _apiService.delete('${ApiEndpoints.menuItems}/$menuItemId');
  }
}
