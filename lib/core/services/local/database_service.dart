import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart' as getx;
import 'package:del_pick/app/config/database_config.dart';

class DatabaseService extends getx.GetxService {
  Database? _database;

  Database? get database => _database;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initDatabase();
  }

  @override
  void onClose() {
    _database?.close();
    super.onClose();
  }

  Future<void> _initDatabase() async {
    _database = await DatabaseConfig.database;
  }

  // User operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await DatabaseConfig.database;
    return await db.insert(DatabaseConfig.userTable, user);
  }

  Future<Map<String, dynamic>?> getUser(int id) async {
    final db = await DatabaseConfig.database;
    final results = await db.query(
      DatabaseConfig.userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await DatabaseConfig.database;
    return await db.update(
      DatabaseConfig.userTable,
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await DatabaseConfig.database;
    return await db.delete(
      DatabaseConfig.userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cart operations
  Future<int> insertCartItem(Map<String, dynamic> cartItem) async {
    final db = await DatabaseConfig.database;
    return await db.insert(DatabaseConfig.cartTable, cartItem);
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await DatabaseConfig.database;
    return await db.query(DatabaseConfig.cartTable, orderBy: 'created_at DESC');
  }

  Future<List<Map<String, dynamic>>> getCartItemsByStore(int storeId) async {
    final db = await DatabaseConfig.database;
    return await db.query(
      DatabaseConfig.cartTable,
      where: 'store_id = ?',
      whereArgs: [storeId],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> updateCartItem(int id, Map<String, dynamic> cartItem) async {
    final db = await DatabaseConfig.database;
    return await db.update(
      DatabaseConfig.cartTable,
      cartItem,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateCartItemQuantity(int id, int quantity) async {
    final db = await DatabaseConfig.database;
    return await db.update(
      DatabaseConfig.cartTable,
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItem(int id) async {
    final db = await DatabaseConfig.database;
    return await db.delete(
      DatabaseConfig.cartTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearCart() async {
    final db = await DatabaseConfig.database;
    return await db.delete(DatabaseConfig.cartTable);
  }

  Future<int> clearCartByStore(int storeId) async {
    final db = await DatabaseConfig.database;
    return await db.delete(
      DatabaseConfig.cartTable,
      where: 'store_id = ?',
      whereArgs: [storeId],
    );
  }

  Future<Map<String, dynamic>?> getCartItemByMenuId(int menuItemId) async {
    final db = await DatabaseConfig.database;
    final results = await db.query(
      DatabaseConfig.cartTable,
      where: 'menu_item_id = ?',
      whereArgs: [menuItemId],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<double> getCartTotal() async {
    final db = await DatabaseConfig.database;
    final result = await db.rawQuery(
      'SELECT SUM(price * quantity) as total FROM ${DatabaseConfig.cartTable}',
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<int> getCartItemCount() async {
    final db = await DatabaseConfig.database;
    final result = await db.rawQuery(
      'SELECT SUM(quantity) as count FROM ${DatabaseConfig.cartTable}',
    );
    return result.first['count'] as int? ?? 0;
  }

  // Favorites operations
  Future<int> insertFavorite(Map<String, dynamic> favorite) async {
    final db = await DatabaseConfig.database;
    return await db.insert(DatabaseConfig.favoritesTable, favorite);
  }

  Future<List<Map<String, dynamic>>> getFavoriteStores() async {
    final db = await DatabaseConfig.database;
    return await db.query(
      DatabaseConfig.favoritesTable,
      where: 'type = ?',
      whereArgs: ['store'],
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteMenuItems() async {
    final db = await DatabaseConfig.database;
    return await db.query(
      DatabaseConfig.favoritesTable,
      where: 'type = ?',
      whereArgs: ['menu_item'],
      orderBy: 'created_at DESC',
    );
  }

  Future<bool> isFavoriteStore(int storeId) async {
    final db = await DatabaseConfig.database;
    final results = await db.query(
      DatabaseConfig.favoritesTable,
      where: 'store_id = ? AND type = ?',
      whereArgs: [storeId, 'store'],
    );
    return results.isNotEmpty;
  }

  Future<bool> isFavoriteMenuItem(int menuItemId) async {
    final db = await DatabaseConfig.database;
    final results = await db.query(
      DatabaseConfig.favoritesTable,
      where: 'menu_item_id = ? AND type = ?',
      whereArgs: [menuItemId, 'menu_item'],
    );
    return results.isNotEmpty;
  }

  Future<int> removeFavoriteStore(int storeId) async {
    final db = await DatabaseConfig.database;
    return await db.delete(
      DatabaseConfig.favoritesTable,
      where: 'store_id = ? AND type = ?',
      whereArgs: [storeId, 'store'],
    );
  }

  Future<int> removeFavoriteMenuItem(int menuItemId) async {
    final db = await DatabaseConfig.database;
    return await db.delete(
      DatabaseConfig.favoritesTable,
      where: 'menu_item_id = ? AND type = ?',
      whereArgs: [menuItemId, 'menu_item'],
    );
  }

  // Orders operations (for offline support)
  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await DatabaseConfig.database;
    return await db.insert(DatabaseConfig.ordersTable, order);
  }

  Future<List<Map<String, dynamic>>> getOfflineOrders() async {
    final db = await DatabaseConfig.database;
    return await db.query(
      DatabaseConfig.ordersTable,
      where: 'synced = ?',
      whereArgs: [0],
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await DatabaseConfig.database;
    return await db.query(
      DatabaseConfig.ordersTable,
      orderBy: 'created_at DESC',
    );
  }

  Future<int> markOrderAsSynced(int orderId, int serverId) async {
    final db = await DatabaseConfig.database;
    return await db.update(
      DatabaseConfig.ordersTable,
      {'synced': 1, 'server_id': serverId},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future<int> deleteOrder(int id) async {
    final db = await DatabaseConfig.database;
    return await db.delete(
      DatabaseConfig.ordersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Addresses operations
  Future<int> insertAddress(Map<String, dynamic> address) async {
    final db = await DatabaseConfig.database;
    return await db.insert(DatabaseConfig.addressesTable, address);
  }

  Future<List<Map<String, dynamic>>> getAddresses() async {
    final db = await DatabaseConfig.database;
    return await db.query(
      DatabaseConfig.addressesTable,
      orderBy: 'is_default DESC, created_at DESC',
    );
  }

  Future<Map<String, dynamic>?> getDefaultAddress() async {
    final db = await DatabaseConfig.database;
    final results = await db.query(
      DatabaseConfig.addressesTable,
      where: 'is_default = ?',
      whereArgs: [1],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateAddress(int id, Map<String, dynamic> address) async {
    final db = await DatabaseConfig.database;
    return await db.update(
      DatabaseConfig.addressesTable,
      address,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> setDefaultAddress(int id) async {
    final db = await DatabaseConfig.database;

    // First, unset all default addresses
    await db.update(DatabaseConfig.addressesTable, {'is_default': 0});

    // Then set the selected address as default
    return await db.update(
      DatabaseConfig.addressesTable,
      {'is_default': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAddress(int id) async {
    final db = await DatabaseConfig.database;
    return await db.delete(
      DatabaseConfig.addressesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Notifications operations
  Future<int> insertNotification(Map<String, dynamic> notification) async {
    final db = await DatabaseConfig.database;
    return await db.insert(DatabaseConfig.notificationsTable, notification);
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await DatabaseConfig.database;
    return await db.query(
      DatabaseConfig.notificationsTable,
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getUnreadNotifications() async {
    final db = await DatabaseConfig.database;
    return await db.query(
      DatabaseConfig.notificationsTable,
      where: 'is_read = ?',
      whereArgs: [0],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> markNotificationAsRead(int id) async {
    final db = await DatabaseConfig.database;
    return await db.update(
      DatabaseConfig.notificationsTable,
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> markAllNotificationsAsRead() async {
    final db = await DatabaseConfig.database;
    return await db.update(DatabaseConfig.notificationsTable, {'is_read': 1});
  }

  Future<int> deleteNotification(int id) async {
    final db = await DatabaseConfig.database;
    return await db.delete(
      DatabaseConfig.notificationsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getUnreadNotificationCount() async {
    final db = await DatabaseConfig.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConfig.notificationsTable} WHERE is_read = 0',
    );
    return result.first['count'] as int? ?? 0;
  }

  // Utility operations
  Future<void> clearAllData() async {
    await DatabaseConfig.clearDatabase();
  }

  Future<Map<String, int>> getDatabaseStats() async {
    final db = await DatabaseConfig.database;

    final cartCount = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConfig.cartTable}',
    );
    final favoritesCount = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConfig.favoritesTable}',
    );
    final ordersCount = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConfig.ordersTable}',
    );
    final addressesCount = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConfig.addressesTable}',
    );
    final notificationsCount = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConfig.notificationsTable}',
    );

    return {
      'cartItems': cartCount.first['count'] as int,
      'favorites': favoritesCount.first['count'] as int,
      'orders': ordersCount.first['count'] as int,
      'addresses': addressesCount.first['count'] as int,
      'notifications': notificationsCount.first['count'] as int,
    };
  }
}
