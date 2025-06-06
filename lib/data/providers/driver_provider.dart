import 'package:delivery_app/data/datasources/remote/driver_remote_datasource.dart';
import 'package:delivery_app/core/utils/result.dart';

class DriverProvider {
  final DriverRemoteDataSource remoteDataSource;

  DriverProvider({required this.remoteDataSource});

  Future<Result<Map<String, dynamic>>> getAllDrivers({
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await remoteDataSource.getAllDrivers(params: params);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch drivers',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> getDriverById(int driverId) async {
    try {
      final response = await remoteDataSource.getDriverById(driverId);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Driver not found',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> createDriver(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await remoteDataSource.createDriver(data);

      if (response.statusCode == 201) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to create driver',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> updateDriver(
    int driverId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await remoteDataSource.updateDriver(driverId, data);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to update driver',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> updateDriverProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await remoteDataSource.updateDriverProfile(data);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to update driver profile',
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
      final response = await remoteDataSource.updateDriverLocation(data);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to update driver location',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> getDriverLocation(int driverId) async {
    try {
      final response = await remoteDataSource.getDriverLocation(driverId);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to get driver location',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> updateDriverStatus(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await remoteDataSource.updateDriverStatus(data);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to update driver status',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> getDriverOrders({
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await remoteDataSource.getDriverOrders(params: params);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch driver orders',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> deleteDriver(int driverId) async {
    try {
      final response = await remoteDataSource.deleteDriver(driverId);

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to delete driver',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // Driver Requests
  Future<Result<Map<String, dynamic>>> getDriverRequests({
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await remoteDataSource.getDriverRequests(params: params);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch driver requests',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> getDriverRequestById(
    int requestId,
  ) async {
    try {
      final response = await remoteDataSource.getDriverRequestById(requestId);

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Driver request not found',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> respondToDriverRequest(
    int requestId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await remoteDataSource.respondToDriverRequest(
        requestId,
        data,
      );

      if (response.statusCode == 200) {
        return Result.success(response.data);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to respond to driver request',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
