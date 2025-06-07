// lib/data/repositories/tracking_repository.dart
import 'package:del_pick/data/providers/tracking_provider.dart';
import 'package:del_pick/data/models/tracking/tracking_info_model.dart';
import 'package:del_pick/core/utils/result.dart';

class TrackingRepository {
  final TrackingProvider _trackingProvider;

  TrackingRepository(this._trackingProvider);

  Future<Result<TrackingInfoModel>> getTrackingInfo(int orderId) async {
    try {
      final response = await _trackingProvider.getTrackingInfo(orderId);

      if (response.statusCode == 200) {
        final trackingInfo = TrackingInfoModel.fromJson(response.data['data']);
        return Result.success(trackingInfo);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to get tracking info',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> startDelivery(int orderId) async {
    try {
      final response = await _trackingProvider.startDelivery(orderId);

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to start delivery',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> completeDelivery(int orderId) async {
    try {
      final response = await _trackingProvider.completeDelivery(orderId);

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to complete delivery',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
