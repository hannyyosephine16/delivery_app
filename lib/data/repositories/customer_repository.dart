// lib/data/repositories/customer_repository.dart

import 'package:del_pick/data/providers/customer_provider.dart';
import 'package:del_pick/data/models/customer/customer_model.dart';
import 'package:del_pick/data/models/base/base_model.dart';
import 'package:del_pick/core/utils/result.dart';

class CustomerRepository {
  final CustomerProvider _customerProvider;

  CustomerRepository(this._customerProvider);

  Future<Result<PaginatedResponse<CustomerModel>>> getAllCustomers({
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _customerProvider.getAllCustomers(params: params);

      if (response.statusCode == 200) {
        final paginatedResponse = PaginatedResponse.fromJson(
          response.data,
          (json) => CustomerModel.fromJson(json),
        );
        return Result.success(paginatedResponse);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch customers',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<CustomerModel>> getCustomerById(int customerId) async {
    try {
      final response = await _customerProvider.getCustomerById(customerId);

      if (response.statusCode == 200) {
        final customer = CustomerModel.fromJson(response.data['data']);
        return Result.success(customer);
      } else {
        return Result.failure(response.data['message'] ?? 'Customer not found');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<CustomerModel>> createCustomer(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _customerProvider.createCustomer(data);

      if (response.statusCode == 201) {
        final customer = CustomerModel.fromJson(response.data['data']);
        return Result.success(customer);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to create customer',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<CustomerModel>> updateCustomer(
    int customerId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _customerProvider.updateCustomer(customerId, data);

      if (response.statusCode == 200) {
        final customer = CustomerModel.fromJson(response.data['data']);
        return Result.success(customer);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to update customer',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> deleteCustomer(int customerId) async {
    try {
      final response = await _customerProvider.deleteCustomer(customerId);

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to delete customer',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
