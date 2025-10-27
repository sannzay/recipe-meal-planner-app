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
      await db.execute('PRAGMA foreign_keys = ON');
      await db.execute('PRAGMA journal_mode = WAL');
      await db.execute('PRAGMA synchronous = NORMAL');
      await db.execute('PRAGMA cache_size = 1000');
      await db.execute('PRAGMA temp_store = MEMORY');
    } catch (e) {
      ErrorHandler.logError('Database configuration failed', e);
      rethrow;
    }
  }

  Future<void> _onOpen(Database db) async {
    try {
      ErrorHandler.logInfo('Database opened successfully');
      await db.execute('PRAGMA foreign_keys = ON');
    } catch (e) {
      ErrorHandler.logError('Database open configuration failed', e);
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      ErrorHandler.logInfo('Creating database tables');
      
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

      await db.execute('CREATE INDEX idx_ingredients_recipe_id ON ingredients(recipe_id)');
      await db.execute('CREATE INDEX idx_meal_plans_date ON meal_plans(date)');
      await db.execute('CREATE INDEX idx_meal_plans_recipe_id ON meal_plans(recipe_id)');
      await db.execute('CREATE INDEX idx_grocery_items_category ON grocery_items(category)');
      await db.execute('CREATE INDEX idx_grocery_items_checked ON grocery_items(is_checked)');
      
      ErrorHandler.logInfo('Database tables created successfully');
    } catch (e) {
      ErrorHandler.logError('Failed to create database tables', e);
      rethrow;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      ErrorHandler.logInfo('Upgrading database from version $oldVersion to $newVersion');
      
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE recipes ADD COLUMN notes TEXT');
        await db.execute('CREATE INDEX idx_recipes_category ON recipes(category)');
        await db.execute('CREATE INDEX idx_recipes_difficulty ON recipes(difficulty)');
      }
      
      ErrorHandler.logInfo('Database upgrade completed successfully');
    } catch (e) {
      ErrorHandler.logError('Database upgrade failed', e);
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
        ErrorHandler.logInfo('Database closed successfully');
      }
    } catch (e) {
      ErrorHandler.logError('Failed to close database', e);
      rethrow;
    }
  }

  Future<void> deleteDatabase() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
      }
      String path = join(await getDatabasesPath(), _databaseName);
      await databaseFactory.deleteDatabase(path);
      ErrorHandler.logInfo('Database deleted successfully');
    } catch (e) {
      ErrorHandler.logError('Failed to delete database', e);
      rethrow;
    }
  }

  Future<void> clearAllTables() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('grocery_items');
        await txn.delete('meal_plans');
        await txn.delete('ingredients');
        await txn.delete('recipes');
      });
      ErrorHandler.logInfo('All tables cleared successfully');
    } catch (e) {
      ErrorHandler.logError('Failed to clear all tables', e);
      rethrow;
    }
  }

  Future<bool> isDatabaseHealthy() async {
    try {
      final db = await database;
      final result = await db.rawQuery('SELECT 1');
      return result.isNotEmpty;
    } catch (e) {
      ErrorHandler.logError('Database health check failed', e);
      return false;
    }
  }

  Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      final db = await database;
      final tables = ['recipes', 'ingredients', 'meal_plans', 'grocery_items'];
      final Map<String, dynamic> info = {};
      
      for (final table in tables) {
        final result = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
        info[table] = result.first['count'];
      }
      
      return info;
    } catch (e) {
      ErrorHandler.logError('Failed to get database info', e);
      return {};
    }
  }

  Future<void> vacuumDatabase() async {
    try {
      final db = await database;
      await db.execute('VACUUM');
      ErrorHandler.logInfo('Database vacuum completed successfully');
    } catch (e) {
      ErrorHandler.logError('Database vacuum failed', e);
      rethrow;
    }
  }

  Future<void> analyzeDatabase() async {
    try {
      final db = await database;
      await db.execute('ANALYZE');
      ErrorHandler.logInfo('Database analysis completed successfully');
    } catch (e) {
      ErrorHandler.logError('Database analysis failed', e);
      rethrow;
    }
  }
}
