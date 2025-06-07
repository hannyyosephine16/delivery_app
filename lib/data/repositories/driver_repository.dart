import 'package:del_pick/data/providers/driver_provider.dart';
import 'package:del_pick/data/models/driver/driver_model.dart';
import 'package:del_pick/data/models/driver/driver_request_model.dart';
import 'package:del_pick/data/models/base/base_model.dart';
import 'package:del_pick/core/utils/result.dart';

class DriverRepository {
  final DriverProvider _driverProvider;

  DriverRepository(this._driverProvider);

  Future<Result<PaginatedResponse<DriverModel>>> getAllDrivers({
    Map<String, dynamic>? params,
  }) async {
    try {
      final result = await _driverProvider.getAllDrivers(params: params);

      if (result.isSuccess && result.data != null) {
        final data = result.data!['data'] as Map<String, dynamic>;
        final drivers = (data['drivers'] as List)
            .map((json) => DriverModel.fromJson(json))
            .toList();

        final paginatedResponse = PaginatedResponse<DriverModel>(
          data: drivers,
          totalItems: data['totalItems'] ?? 0,
          totalPages: data['totalPages'] ?? 0,
          currentPage: data['currentPage'] ?? 1,
          limit: params?['limit'] ?? 10,
        );

        return Result.success(paginatedResponse);
      } else {
        return Result.failure(result.message ?? 'Failed to fetch drivers');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DriverModel>> getDriverById(int driverId) async {
    try {
      final result = await _driverProvider.getDriverById(driverId);

      if (result.isSuccess && result.data != null) {
        final driver = DriverModel.fromJson(result.data!['data']);
        return Result.success(driver);
      } else {
        return Result.failure(result.message ?? 'Driver not found');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DriverModel>> createDriver(Map<String, dynamic> data) async {
    try {
      final result = await _driverProvider.createDriver(data);

      if (result.isSuccess && result.data != null) {
        final driver = DriverModel.fromJson(result.data!['data']);
        return Result.success(driver);
      } else {
        return Result.failure(result.message ?? 'Failed to create driver');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DriverModel>> updateDriver(
    int driverId,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _driverProvider.updateDriver(driverId, data);

      if (result.isSuccess && result.data != null) {
        final driver = DriverModel.fromJson(result.data!['data']);
        return Result.success(driver);
      } else {
        return Result.failure(result.message ?? 'Failed to update driver');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DriverModel>> updateDriverProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _driverProvider.updateDriverProfile(data);

      if (result.isSuccess && result.data != null) {
        final driver = DriverModel.fromJson(result.data!['data']);
        return Result.success(driver);
      } else {
        return Result.failure(
          result.message ?? 'Failed to update driver profile',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> updateDriverLocation(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _driverProvider.updateDriverLocation(data);

      if (result.isSuccess && result.data != null) {
        return Result.success(result.data!['data']);
      } else {
        return Result.failure(
          result.message ?? 'Failed to update driver location',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> getDriverLocation(int driverId) async {
    try {
      final result = await _driverProvider.getDriverLocation(driverId);

      if (result.isSuccess && result.data != null) {
        return Result.success(result.data!['data']);
      } else {
        return Result.failure(
          result.message ?? 'Failed to get driver location',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DriverModel>> updateDriverStatus(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _driverProvider.updateDriverStatus(data);

      if (result.isSuccess && result.data != null) {
        final driver = DriverModel.fromJson(result.data!['data']);
        return Result.success(driver);
      } else {
        return Result.failure(
          result.message ?? 'Failed to update driver status',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> deleteDriver(int driverId) async {
    try {
      final result = await _driverProvider.deleteDriver(driverId);

      if (result.isSuccess) {
        return Result.success(null);
      } else {
        return Result.failure(result.message ?? 'Failed to delete driver');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // Driver Requests
  Future<Result<List<DriverRequestModel>>> getDriverRequests({
    Map<String, dynamic>? params,
  }) async {
    try {
      final result = await _driverProvider.getDriverRequests(params: params);

      if (result.isSuccess && result.data != null) {
        final data = result.data!['data'] as List;
        final requests =
            data.map((json) => DriverRequestModel.fromJson(json)).toList();
        return Result.success(requests);
      } else {
        return Result.failure(
          result.message ?? 'Failed to fetch driver requests',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DriverRequestModel>> getDriverRequestById(
    int requestId,
  ) async {
    try {
      final result = await _driverProvider.getDriverRequestById(requestId);

      if (result.isSuccess && result.data != null) {
        final request = DriverRequestModel.fromJson(result.data!['data']);
        return Result.success(request);
      } else {
        return Result.failure(result.message ?? 'Driver request not found');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DriverRequestModel>> respondToDriverRequest(
    int requestId,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _driverProvider.respondToDriverRequest(
        requestId,
        data,
      );

      if (result.isSuccess && result.data != null) {
        final request = DriverRequestModel.fromJson(result.data!['data']);
        return Result.success(request);
      } else {
        return Result.failure(
          result.message ?? 'Failed to respond to driver request',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
