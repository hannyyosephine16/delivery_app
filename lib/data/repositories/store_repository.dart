import 'package:del_pick/data/providers/store_provider.dart';
import 'package:del_pick/data/models/store/store_model.dart';
import 'package:del_pick/core/utils/result.dart';

class StoreRepository {
  final StoreProvider _storeProvider;

  StoreRepository(this._storeProvider);

  Future<Result<List<StoreModel>>> getAllStores() async {
    try {
      final response = await _storeProvider.getAllStores();

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final stores = data.map((json) => StoreModel.fromJson(json)).toList();
        return Result.success(stores);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch stores',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<StoreModel>>> getNearbyStores({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _storeProvider.getNearbyStores(
        latitude: latitude,
        longitude: longitude,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final stores = data.map((json) => StoreModel.fromJson(json)).toList();
        return Result.success(stores);
      } else {
        return Result.failure(
          response.data['message'] ?? 'Failed to fetch nearby stores',
        );
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
