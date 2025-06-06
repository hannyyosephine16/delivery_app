// import 'package:get/get.dart' as getx;
// import 'package:delivery_app/core/services/local/storage_service.dart';
// import 'package:delivery_app/core/constants/app_constants.dart';
//
// class CacheService extends getx.GetxService {
//   final StorageService _storageService = getx.Get.find<StorageService>();
//
//   // Cache keys
//   static const String _storesKey = 'cached_stores';
//   static const String _menuItemsKey = 'cached_menu_items';
//   static const String _ordersKey = 'cached_orders';
//   static const String _userKey = 'cached_user';
//   static const String _categoriesKey = 'cached_categories';
//
//   // Cache with expiration
//   Future<void> cacheWithExpiration<T>(
//     String key,
//     T data,
//     Duration expiration,
//   ) async {
//     await _storageService.writeWithExpiration(key, data, expiration);
//   }
//
//   // Get cached data with expiration check
//   T? getCachedData<T>(String key) {
//     return _storageService.readWithExpiration<T>(key);
//   }
//
//   // Store-specific cache methods
//   Future<void> cacheStores(List<Map<String, dynamic>> stores) async {
//     await cacheWithExpiration(
//       _storesKey,
//       stores,
//       const Duration(minutes: AppConstants.mediumCacheDuration),
//     );
//   }
//
//   List<Map<String, dynamic>>? getCachedStores() {
//     final cached = getCachedData<List<dynamic>>(_storesKey);
//     return cached?.cast<Map<String, dynamic>>();
//   }
//
//   Future<void> cacheStoreDetail(int storeId, Map<String, dynamic> store) async {
//     await cacheWithExpiration(
//       '${_storesKey}_detail_$storeId',
//       store,
//       const Duration(minutes: AppConstants.shortCacheDuration),
//     );
//   }
//
//   Map<String, dynamic>? getCachedStoreDetail(int storeId) {
//     return getCachedData<Map<String, dynamic>>('${_storesKey}_detail_$storeId');
//   }
//
//   // Menu items cache methods
//   Future<void> cacheMenuItems(
//     int storeId,
//     List<Map<String, dynamic>> menuItems,
//   ) async {
//     await cacheWithExpiration(
//       '${_menuItemsKey}_$storeId',
//       menuItems,
//       const Duration(minutes: AppConstants.mediumCacheDuration),
//     );
//   }
//
//   List<Map<String, dynamic>>? getCachedMenuItems(int storeId) {
//     final cached = getCachedData<List<dynamic>>('${_menuItemsKey}_$storeId');
//     return cached?.cast<Map<String, dynamic>>();
//   }
//
//   Future<void> cacheMenuItemDetail(
//     int menuItemId,
//     Map<String, dynamic> menuItem,
//   ) async {
//     await cacheWithExpiration(
//       '${_menuItemsKey}_detail_$menuItemId',
//       menuItem,
//       const Duration(minutes: AppConstants.shortCacheDuration),
//     );
//   }
//
//   Map<String, dynamic>? getCachedMenuItemDetail(int menuItemId) {
//     return getCachedData<Map<String, dynamic>>(
//       '${_menuItemsKey}_detail_$menuItemId',
//     );
//   }
//
//   // Orders cache methods
//   Future<void> cacheOrders(List<Map<String, dynamic>> orders) async {
//     await cacheWithExpiration(
//       _ordersKey,
//       orders,
//       const Duration(minutes: AppConstants.shortCacheDuration),
//     );
//   }
//
//   List<Map<String, dynamic>>? getCachedOrders() {
//     final cached = getCachedData<List<dynamic>>(_ordersKey);
//     return cached?.cast<Map<String, dynamic>>();
//   }
//
//   Future<void> cacheOrderDetail(int orderId, Map<String, dynamic> order) async {
//     await cacheWithExpiration(
//       '${_ordersKey}_detail_$orderId',
//       order,
//       const Duration(minutes: AppConstants.shortCacheDuration),
//     );
//   }
//
//   Map<String, dynamic>? getCachedOrderDetail(int orderId) {
//     return getCachedData<Map<String, dynamic>>('${_ordersKey}_detail_$orderId');
//   }
//
//   // User cache methods
//   Future<void> cacheUser(Map<String, dynamic> user) async {
//     await cacheWithExpiration(
//       _userKey,
//       user,
//       const Duration(hours: AppConstants.longCacheDuration),
//     );
//   }
//
//   Map<String, dynamic>? getCachedUser() {
//     return getCachedData<Map<String, dynamic>>(_userKey);
//   }
//
//   // Categories cache methods
//   Future<void> cacheCategories(List<Map<String, dynamic>> categories) async {
//     await cacheWithExpiration(
//       _categoriesKey,
//       categories,
//       const Duration(hours: AppConstants.verylongCacheDuration),
//     );
//   }
//
//   List<Map<String, dynamic>>? getCachedCategories() {
//     final cached = getCachedData<List<dynamic>>(_categoriesKey);
//     return cached?.cast<Map<String, dynamic>>();
//   }
//
//   // Search results cache
//   Future<void> cacheSearchResults(
//     String query,
//     List<Map<String, dynamic>> results,
//   ) async {
//     await cacheWithExpiration(
//       'search_$query',
//       results,
//       const Duration(minutes: AppConstants.shortCacheDuration),
//     );
//   }
//
//   List<Map<String, dynamic>>? getCachedSearchResults(String query) {
//     final cached = getCachedData<List<dynamic>>('search_$query');
//     return cached?.cast<Map<String, dynamic>>();
//   }
//
//   // Location-based cache
//   Future<void> cacheLocationBasedStores(
//     double latitude,
//     double longitude,
//     List<Map<String, dynamic>> stores,
//   ) async {
//     final locationKey =
//         'stores_${latitude.toStringAsFixed(2)}_${longitude.toStringAsFixed(2)}';
//     await cacheWithExpiration(
//       locationKey,
//       stores,
//       const Duration(minutes: AppConstants.mediumCacheDuration),
//     );
//   }
//
//   List<Map<String, dynamic>>? getCachedLocationBasedStores(
//     double latitude,
//     double longitude,
//   ) {
//     final locationKey =
//         'stores_${latitude.toStringAsFixed(2)}_${longitude.toStringAsFixed(2)}';
//     final cached = getCachedData<List<dynamic>>(locationKey);
//     return cached?.cast<Map<String, dynamic>>();
//   }
//
//   // Recent searches cache
//   Future<void> cacheRecentSearch(String query) async {
//     List<String> recentSearches = getCachedRecentSearches() ?? [];
//
//     // Remove if already exists
//     recentSearches.removeWhere(
//       (search) => search.toLowerCase() == query.toLowerCase(),
//     );
//
//     // Add to beginning
//     recentSearches.insert(0, query);
//
//     // Keep only last 10 searches
//     if (recentSearches.length > 10) {
//       recentSearches = recentSearches.take(10).toList();
//     }
//
//     await cacheWithExpiration(
//       'recent_searches',
//       recentSearches,
//       const Duration(days: AppConstants.verylongCacheDuration),
//     );
//   }
//
//   List<String>? getCachedRecentSearches() {
//     final cached = getCachedData<List<dynamic>>('recent_searches');
//     return cached?.cast<String>();
//   }
//
//   Future<void> clearRecentSearches() async {
//     await _storageService.remove('recent_searches');
//   }
//
//   // Filter preferences cache
//   Future<void> cacheFilterPreferences(Map<String, dynamic> filters) async {
//     await cacheWithExpiration(
//       'filter_preferences',
//       filters,
//       const Duration(days: AppConstants.verylongCacheDuration),
//     );
//   }
//
//   Map<String, dynamic>? getCachedFilterPreferences() {
//     return getCachedData<Map<String, dynamic>>('filter_preferences');
//   }
//
//   // Favorites cache
//   Future<void> cacheFavoriteStores(List<int> storeIds) async {
//     await cacheWithExpiration(
//       'favorite_stores',
//       storeIds,
//       const Duration(days: AppConstants.verylongCacheDuration),
//     );
//   }
//
//   List<int>? getCachedFavoriteStores() {
//     final cached = getCachedData<List<dynamic>>('favorite_stores');
//     return cached?.cast<int>();
//   }
//
//   Future<void> cacheFavoriteMenuItems(List<int> menuItemIds) async {
//     await cacheWithExpiration(
//       'favorite_menu_items',
//       menuItemIds,
//       const Duration(days: AppConstants.verylongCacheDuration),
//     );
//   }
//
//   List<int>? getCachedFavoriteMenuItems() {
//     final cached = getCachedData<List<dynamic>>('favorite_menu_items');
//     return cached?.cast<int>();
//   }
//
//   // Delivery addresses cache
//   Future<void> cacheDeliveryAddresses(
//     List<Map<String, dynamic>> addresses,
//   ) async {
//     await cacheWithExpiration(
//       'delivery_addresses',
//       addresses,
//       const Duration(days: AppConstants.verylongCacheDuration),
//     );
//   }
//
//   List<Map<String, dynamic>>? getCachedDeliveryAddresses() {
//     final cached = getCachedData<List<dynamic>>('delivery_addresses');
//     return cached?.cast<Map<String, dynamic>>();
//   }
//
//   // Cart cache
//   Future<void> cacheCart(Map<String, dynamic> cart) async {
//     await _storageService.writeJson('cart_data', cart);
//   }
//
//   Map<String, dynamic>? getCachedCart() {
//     return _storageService.readJson('cart_data');
//   }
//
//   Future<void> clearCartCache() async {
//     await _storageService.remove('cart_data');
//   }
//
//   // Image cache metadata
//   Future<void> cacheImageMetadata(
//     String url,
//     Map<String, dynamic> metadata,
//   ) async {
//     await cacheWithExpiration(
//       'image_${url.hashCode}',
//       metadata,
//       const Duration(days: AppConstants.verylongCacheDuration),
//     );
//   }
//
//   Map<String, dynamic>? getCachedImageMetadata(String url) {
//     return getCachedData<Map<String, dynamic>>('image_${url.hashCode}');
//   }
//
//   // Cache validation
//   bool isCacheValid(String key) {
//     return _storageService.isCacheValid(key);
//   }
//
//   // Cache size management
//   Future<void> clearExpiredCache() async {
//     await _storageService.clearExpiredCache();
//   }
//
//   Future<void> clearAllCache() async {
//     final keys = [
//       _storesKey,
//       _menuItemsKey,
//       _ordersKey,
//       _userKey,
//       _categoriesKey,
//       'recent_searches',
//       'filter_preferences',
//       'favorite_stores',
//       'favorite_menu_items',
//       'delivery_addresses',
//       'cart_data',
//     ];
//
//     for (final key in keys) {
//       await _storageService.remove(key);
//     }
//
//     // Clear all store detail caches
//     final allKeys = _storageService.getKeys();
//     for (final key in allKeys) {
//       if (key.contains('_detail_') ||
//           key.startsWith('search_') ||
//           key.startsWith('stores_') ||
//           key.startsWith('image_')) {
//         await _storageService.remove(key);
//       }
//     }
//   }
//
//   Future<void> clearSpecificCache(String cacheType) async {
//     switch (cacheType) {
//       case 'stores':
//         await _storageService.remove(_storesKey);
//         final allKeys = _storageService.getKeys();
//         for (final key in allKeys) {
//           if (key.contains('${_storesKey}_detail_') ||
//               key.startsWith('stores_')) {
//             await _storageService.remove(key);
//           }
//         }
//         break;
//       case 'menu_items':
//         final allKeys = _storageService.getKeys();
//         for (final key in allKeys) {
//           if (key.startsWith(_menuItemsKey)) {
//             await _storageService.remove(key);
//           }
//         }
//         break;
//       case 'orders':
//         await _storageService.remove(_ordersKey);
//         final allKeys = _storageService.getKeys();
//         for (final key in allKeys) {
//           if (key.contains('${_ordersKey}_detail_')) {
//             await _storageService.remove(key);
//           }
//         }
//         break;
//       case 'user':
//         await _storageService.remove(_userKey);
//         break;
//       case 'search':
//         await _storageService.remove('recent_searches');
//         final allKeys = _storageService.getKeys();
//         for (final key in allKeys) {
//           if (key.startsWith('search_')) {
//             await _storageService.remove(key);
//           }
//         }
//         break;
//     }
//   }
//
//   // Cache statistics
//   Map<String, dynamic> getCacheStatistics() {
//     final allKeys = _storageService.getKeys().toList();
//     int totalItems = allKeys.length;
//     int expiredItems = 0;
//
//     for (final key in allKeys) {
//       if (!_storageService.isCacheValid(key)) {
//         expiredItems++;
//       }
//     }
//
//     return {
//       'totalItems': totalItems,
//       'validItems': totalItems - expiredItems,
//       'expiredItems': expiredItems,
//       'cacheHitRate':
//           totalItems > 0 ? (totalItems - expiredItems) / totalItems : 0.0,
//     };
//   }
// }
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CacheService extends GetxService {
  late GetStorage _box;

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init('cache');
    _box = GetStorage('cache');
  }

  void put(String key, dynamic value, {Duration? duration}) {
    if (duration != null) {
      final expiry = DateTime.now().add(duration).millisecondsSinceEpoch;
      _box.write('${key}_expiry', expiry);
    }
    _box.write(key, value);
  }

  T? get<T>(String key) {
    final expiryKey = '${key}_expiry';
    if (_box.hasData(expiryKey)) {
      final expiry = _box.read(expiryKey);
      if (DateTime.now().millisecondsSinceEpoch > expiry) {
        remove(key);
        return null;
      }
    }
    return _box.read<T>(key);
  }

  void remove(String key) {
    _box.remove(key);
    _box.remove('${key}_expiry');
  }

  void clear() {
    _box.erase();
  }
}
