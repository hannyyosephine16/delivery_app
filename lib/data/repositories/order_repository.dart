// lib/data/repositories/order_repository.dart

import 'package:delivery_app/data/providers/order_provider.dart';
import 'package:delivery_app/data/models/order/order_model.dart';
import 'package:delivery_app/data/models/base/base_model.dart';
import 'package:delivery_app/core/utils/result.dart';

class OrderRepository {
  final OrderProvider _orderProvider;

  OrderRepository(this._orderProvider);

  Future<Result<OrderModel>> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await _orderProvider.createOrder(data);

      if (response.statusCode == 201) {
        final order = OrderModel.fromJson(response.data['data']);
        return Result.success(order);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to create order',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<PaginatedResponse<OrderModel>>> getOrdersByUser({
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _orderProvider.getOrdersByUser(params: params);

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final orders =
            (data['orders'] as List)
                .map((json) => OrderModel.fromJson(json))
                .toList();

        final paginatedResponse = PaginatedResponse<OrderModel>(
          data: orders,
          totalItems: data['totalItems'] ?? 0,
          totalPages: data['totalPages'] ?? 0,
          currentPage: data['currentPage'] ?? 1,
          limit: params?['limit'] ?? 10,
        );

        return Result.success(paginatedResponse);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch orders',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<PaginatedResponse<OrderModel>>> getOrdersByStore({
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _orderProvider.getOrdersByStore(params: params);

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final orders =
            (data['orders'] as List)
                .map((json) => OrderModel.fromJson(json))
                .toList();

        final paginatedResponse = PaginatedResponse<OrderModel>(
          data: orders,
          totalItems: data['totalItems'] ?? 0,
          totalPages: data['totalPages'] ?? 0,
          currentPage: data['currentPage'] ?? 1,
          limit: params?['limit'] ?? 10,
        );

        return Result.success(paginatedResponse);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch store orders',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<OrderModel>> getOrderDetail(int orderId) async {
    try {
      final response = await _orderProvider.getOrderDetail(orderId);

      if (response.statusCode == 200) {
        final order = OrderModel.fromJson(response.data['data']);
        return Result.success(order);
      } else {
        return Result.failure(response.data['message'] ?? 'Order not found');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<OrderModel>> updateOrderStatus(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _orderProvider.updateOrderStatus(data);

      if (response.statusCode == 200) {
        final order = OrderModel.fromJson(response.data['data']);
        return Result.success(order);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to update order status',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<OrderModel>> processOrder(
    int orderId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _orderProvider.processOrder(orderId, data);

      if (response.statusCode == 200) {
        final order = OrderModel.fromJson(response.data['data']);
        return Result.success(order);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to process order',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<OrderModel>> cancelOrder(int orderId) async {
    try {
      final response = await _orderProvider.cancelOrder(orderId);

      if (response.statusCode == 200) {
        final order = OrderModel.fromJson(response.data['data']);
        return Result.success(order);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to cancel order',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> createReview(Map<String, dynamic> data) async {
    try {
      final response = await _orderProvider.createReview(data);

      if (response.statusCode == 201) {
        return Result.success(null);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to create review',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
