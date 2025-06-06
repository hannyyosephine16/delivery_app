// lib/app/config/database_config.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConfig {
  static const String _dbName = 'delpick.db';
  static const int _dbVersion = 1;

  // Table names
  static const String userTable = 'users';
  static const String cartTable = 'cart_items';
  static const String favoritesTable = 'favorites';
  static const String ordersTable = 'orders';
  static const String addressesTable = 'addresses';
  static const String notificationsTable = 'notifications';

  static Database? _database;

  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE $userTable (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        role TEXT NOT NULL,
        avatar TEXT,
        created_at TEXT
      )
    ''');

    // Cart items table
    await db.execute('''
      CREATE TABLE $cartTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        menu_item_id INTEGER NOT NULL,
        store_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        image_url TEXT,
        notes TEXT,
        created_at TEXT
      )
    ''');

    // Favorites table
    await db.execute('''
      CREATE TABLE $favoritesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        store_id INTEGER,
        menu_item_id INTEGER,
        type TEXT NOT NULL,
        created_at TEXT
      )
    ''');

    // Orders table (for offline support)
    await db.execute('''
      CREATE TABLE $ordersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id INTEGER,
        data TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');

    // Addresses table
    await db.execute('''
      CREATE TABLE $addressesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        address TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        is_default INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');

    // Notifications table
    await db.execute('''
      CREATE TABLE $notificationsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        payload TEXT,
        is_read INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');
  }

  static Future<void> clearDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    await deleteDatabase(path);
    _database = null;
  }
}
