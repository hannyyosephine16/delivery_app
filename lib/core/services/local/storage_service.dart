import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' as getx;

class StorageService extends getx.GetxService {
  late GetStorage _box;

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _box = GetStorage();
  }

  // Basic storage operations

  /// Write data to storage
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Read data from storage
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Read data with default value
  T readWithDefault<T>(String key, T defaultValue) {
    return _box.read<T>(key) ?? defaultValue;
  }

  /// Check if key exists
  bool hasData(String key) {
    return _box.hasData(key);
  }

  /// Remove specific key
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _box.erase();
  }

  /// Get all keys
  Iterable<String> getKeys() {
    return _box.getKeys().cast<String>();
  }

  /// Get all values
  Iterable<dynamic> getValues() {
    return _box.getValues();
  }

  // JSON operations

  /// Write JSON object to storage
  Future<void> writeJson(String key, Map<String, dynamic> json) async {
    await _box.write(key, jsonEncode(json));
  }

  /// Read JSON object from storage
  Map<String, dynamic>? readJson(String key) {
    final String? jsonString = _box.read<String>(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Write JSON list to storage
  Future<void> writeJsonList(
    String key,
    List<Map<String, dynamic>> jsonList,
  ) async {
    await _box.write(key, jsonEncode(jsonList));
  }

  /// Read JSON list from storage
  List<Map<String, dynamic>>? readJsonList(String key) {
    final String? jsonString = _box.read<String>(key);
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // List operations

  /// Write list to storage
  Future<void> writeList<T>(String key, List<T> list) async {
    await _box.write(key, list);
  }

  /// Read list from storage
  List<T>? readList<T>(String key) {
    final dynamic data = _box.read(key);
    if (data is List) {
      return data.cast<T>();
    }
    return null;
  }

  /// Add item to list
  Future<void> addToList<T>(String key, T item) async {
    List<T> list = readList<T>(key) ?? <T>[];
    list.add(item);
    await writeList<T>(key, list);
  }

  /// Remove item from list
  Future<void> removeFromList<T>(String key, T item) async {
    List<T> list = readList<T>(key) ?? <T>[];
    list.remove(item);
    await writeList<T>(key, list);
  }

  /// Clear list
  Future<void> clearList(String key) async {
    await _box.write(key, <dynamic>[]);
  }

  // Map operations

  /// Write map to storage
  Future<void> writeMap<K, V>(String key, Map<K, V> map) async {
    await _box.write(key, map);
  }

  /// Read map from storage
  Map<K, V>? readMap<K, V>(String key) {
    final dynamic data = _box.read(key);
    if (data is Map) {
      return data.cast<K, V>();
    }
    return null;
  }

  /// Add item to map
  Future<void> addToMap<K, V>(String key, K mapKey, V value) async {
    Map<K, V> map = readMap<K, V>(key) ?? <K, V>{};
    map[mapKey] = value;
    await writeMap<K, V>(key, map);
  }

  /// Remove item from map
  Future<void> removeFromMap<K, V>(String key, K mapKey) async {
    Map<K, V> map = readMap<K, V>(key) ?? <K, V>{};
    map.remove(mapKey);
    await writeMap<K, V>(key, map);
  }

  /// Clear map
  Future<void> clearMap(String key) async {
    await _box.write(key, <dynamic, dynamic>{});
  }

  // Convenience methods for common data types

  /// Write string
  Future<void> writeString(String key, String value) async {
    await _box.write(key, value);
  }

  /// Read string
  String? readString(String key) {
    return _box.read<String>(key);
  }

  /// Write boolean
  Future<void> writeBool(String key, bool value) async {
    await _box.write(key, value);
  }

  /// Read boolean
  bool? readBool(String key) {
    return _box.read<bool>(key);
  }

  /// Read boolean with default value
  bool readBoolWithDefault(String key, bool defaultValue) {
    return _box.read<bool>(key) ?? defaultValue;
  }

  /// Write integer
  Future<void> writeInt(String key, int value) async {
    await _box.write(key, value);
  }

  /// Read integer
  int? readInt(String key) {
    return _box.read<int>(key);
  }

  /// Read integer with default value
  int readIntWithDefault(String key, int defaultValue) {
    return _box.read<int>(key) ?? defaultValue;
  }

  /// Write double
  Future<void> writeDouble(String key, double value) async {
    await _box.write(key, value);
  }

  /// Read double
  double? readDouble(String key) {
    return _box.read<double>(key);
  }

  /// Read double with default value
  double readDoubleWithDefault(String key, double defaultValue) {
    return _box.read<double>(key) ?? defaultValue;
  }

  /// Write DateTime
  Future<void> writeDateTime(String key, DateTime value) async {
    await _box.write(key, value.toIso8601String());
  }

  /// Read DateTime
  DateTime? readDateTime(String key) {
    final String? dateString = _box.read<String>(key);
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Cache operations with expiration

  /// Write data with expiration
  Future<void> writeWithExpiration(
    String key,
    dynamic value,
    Duration expiration,
  ) async {
    final expirationTime = DateTime.now().add(expiration);
    final cacheData = {
      'value': value,
      'expiration': expirationTime.toIso8601String(),
    };
    await _box.write(key, jsonEncode(cacheData));
  }

  /// Read data with expiration check
  T? readWithExpiration<T>(String key) {
    final String? cacheString = _box.read<String>(key);
    if (cacheString != null) {
      try {
        final Map<String, dynamic> cacheData = jsonDecode(cacheString);
        final DateTime expiration = DateTime.parse(cacheData['expiration']);

        if (DateTime.now().isBefore(expiration)) {
          return cacheData['value'] as T;
        } else {
          // Data expired, remove it
          _box.remove(key);
          return null;
        }
      } catch (e) {
        // Invalid cache format, remove it
        _box.remove(key);
        return null;
      }
    }
    return null;
  }

  /// Check if cached data is still valid
  bool isCacheValid(String key) {
    final String? cacheString = _box.read<String>(key);
    if (cacheString != null) {
      try {
        final Map<String, dynamic> cacheData = jsonDecode(cacheString);
        final DateTime expiration = DateTime.parse(cacheData['expiration']);
        return DateTime.now().isBefore(expiration);
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    final keys = _box.getKeys().toList();
    for (final key in keys) {
      final String? cacheString = _box.read<String>(key as String);
      if (cacheString != null) {
        try {
          final Map<String, dynamic> cacheData = jsonDecode(cacheString);
          if (cacheData.containsKey('expiration')) {
            final DateTime expiration = DateTime.parse(cacheData['expiration']);
            if (DateTime.now().isAfter(expiration)) {
              await _box.remove(key);
            }
          }
        } catch (e) {
          // Invalid format, remove it
          await _box.remove(key);
        }
      }
    }
  }

  // Batch operations

  /// Write multiple key-value pairs
  Future<void> writeBatch(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      await _box.write(entry.key, entry.value);
    }
  }

  /// Read multiple keys
  Map<String, dynamic> readBatch(List<String> keys) {
    final Map<String, dynamic> result = {};
    for (final key in keys) {
      final value = _box.read(key);
      if (value != null) {
        result[key] = value;
      }
    }
    return result;
  }

  /// Remove multiple keys
  Future<void> removeBatch(List<String> keys) async {
    for (final key in keys) {
      await _box.remove(key);
    }
  }

  // Storage info

  /// Get storage size (approximate)
  int getStorageSize() {
    return _box.getKeys().length;
  }

  /// Check if storage is empty
  bool isEmpty() {
    return _box.getKeys().isEmpty;
  }

  /// Listen to storage changes
  void listenToKey(String key, Function(dynamic) callback) {
    _box.listenKey(key, callback);
  }

  /// Listen to all storage changes
  void listenToAll(Function() callback) {
    _box.listen(callback);
  }
}
