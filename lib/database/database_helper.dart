import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../services/error_handling_service.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _databaseName = 'recipe_meal_planner.db';
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      _database = await _initDatabase();
      return _database!;
    } catch (e) {
      ErrorHandler.logError('Failed to initialize database', e);
      rethrow;
    }
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), _databaseName);
      
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: _onOpen,
        onConfigure: _onConfigure,
      );
    } catch (e) {
      ErrorHandler.logError('Database initialization failed', e);
      rethrow;
    }
  }

  Future<void> _onConfigure(Database db) async {
    try {
      // Simplified database configuration for better compatibility
      await db.execute('PRAGMA foreign_keys = ON');
      // Remove problematic PRAGMA statements that cause issues on some devices
    } catch (e) {
      ErrorHandler.logError('Database configuration failed', e);
      rethrow;
    }
  }

  Future<void> _onOpen(Database db) async {
    try {
      ErrorHandler.logInfo('Database opened successfully');
      // Database is already configured in _onConfigure
    } catch (e) {
      ErrorHandler.logError('Database open configuration failed', e);
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        image_url TEXT,
        prep_time INTEGER NOT NULL,
        cook_time INTEGER NOT NULL,
        servings INTEGER NOT NULL,
        difficulty TEXT NOT NULL,
        category TEXT NOT NULL,
        dietary_tags TEXT NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ingredients (
        id TEXT PRIMARY KEY,
        recipe_id TEXT NOT NULL,
        name TEXT NOT NULL,
        quantity TEXT NOT NULL,
        unit TEXT NOT NULL,
        category TEXT NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE meal_plans (
        id TEXT PRIMARY KEY,
        date INTEGER NOT NULL,
        meal_type TEXT NOT NULL,
        recipe_id TEXT NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE grocery_items (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        quantity TEXT NOT NULL,
        unit TEXT NOT NULL,
        category TEXT NOT NULL,
        is_checked INTEGER NOT NULL DEFAULT 0,
        from_recipe_id TEXT
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_ingredients_recipe_id ON ingredients(recipe_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_meal_plans_date ON meal_plans(date)
    ''');

    await db.execute('''
      CREATE INDEX idx_meal_plans_recipe_id ON meal_plans(recipe_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_grocery_items_category ON grocery_items(category)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS grocery_items');
      await db.execute('DROP TABLE IF EXISTS meal_plans');
      await db.execute('DROP TABLE IF EXISTS ingredients');
      await db.execute('DROP TABLE IF EXISTS recipes');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete('grocery_items');
    await db.delete('meal_plans');
    await db.delete('ingredients');
    await db.delete('recipes');
  }
}
