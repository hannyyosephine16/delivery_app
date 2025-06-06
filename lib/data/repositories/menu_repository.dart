// lib/data/repositories/menu_repository.dart

import 'package:delivery_app/data/providers/menu_provider.dart';
import 'package:delivery_app/data/models/menu/menu_item_model.dart';
import 'package:delivery_app/data/models/base/base_model.dart';
import 'package:delivery_app/core/utils/result.dart';

class MenuRepository {
  final MenuProvider _menuProvider;

  MenuRepository(this._menuProvider);

  Future<Result<PaginatedResponse<MenuItemModel>>> getAllMenuItems({
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _menuProvider.getAllMenuItems(params: params);

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final menuItems =
            (data['menuItems'] as List)
                .map((json) => MenuItemModel.fromJson(json))
                .toList();

        final paginatedResponse = PaginatedResponse<MenuItemModel>(
          data: menuItems,
          totalItems: data['totalItems'] ?? 0,
          totalPages: data['totalPages'] ?? 0,
          currentPage: data['currentPage'] ?? 1,
          limit: params?['limit'] ?? 10,
        );

        return Result.success(paginatedResponse);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch menu items',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<MenuItemModel>>> getMenuItemsByStoreId(
    int storeId, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _menuProvider.getMenuItemsByStoreId(
        storeId,
        params: params,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final menuItems =
            (data['menuItems'] as List)
                .map((json) => MenuItemModel.fromJson(json))
                .toList();
        return Result.success(menuItems);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch menu items',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<MenuItemModel>> getMenuItemById(int menuItemId) async {
    try {
      final response = await _menuProvider.getMenuItemById(menuItemId);

      if (response.statusCode == 200) {
        final menuItem = MenuItemModel.fromJson(response.data['data']);
        return Result.success(menuItem);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Menu item not found',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<MenuItemModel>> createMenuItem(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _menuProvider.createMenuItem(data);

      if (response.statusCode == 201) {
        final menuItem = MenuItemModel.fromJson(response.data['data']);
        return Result.success(menuItem);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to create menu item',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<MenuItemModel>> updateMenuItem(
    int menuItemId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _menuProvider.updateMenuItem(menuItemId, data);

      if (response.statusCode == 200) {
        final menuItem = MenuItemModel.fromJson(response.data['data']);
        return Result.success(menuItem);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to update menu item',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> deleteMenuItem(int menuItemId) async {
    try {
      final response = await _menuProvider.deleteMenuItem(menuItemId);

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to delete menu item',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
