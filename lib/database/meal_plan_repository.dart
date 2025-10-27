import 'package:sqflite/sqflite.dart';
import '../models/meal_plan_model.dart';
import 'database_helper.dart';

class MealPlanRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertMealPlan(MealPlan mealPlan) async {
    final db = await _databaseHelper.database;
    return await db.insert('meal_plans', mealPlan.toMap());
  }

  Future<int> updateMealPlan(MealPlan mealPlan) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'meal_plans',
      mealPlan.toMap(),
      where: 'id = ?',
      whereArgs: [mealPlan.id],
    );
  }

  Future<int> deleteMealPlan(String id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'meal_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<MealPlan?> getMealPlanById(String id) async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'meal_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return MealPlan.fromMap(maps.first);
  }

  Future<List<MealPlan>> getAllMealPlans() async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query('meal_plans', orderBy: 'date ASC');
    return maps.map((map) => MealPlan.fromMap(map)).toList();
  }

  Future<List<MealPlan>> getMealPlansByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await _databaseHelper.database;
    
    final startTimestamp = startDate.millisecondsSinceEpoch;
    final endTimestamp = endDate.millisecondsSinceEpoch;
    
    final maps = await db.query(
      'meal_plans',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startTimestamp, endTimestamp],
      orderBy: 'date ASC',
    );
    
    return maps.map((map) => MealPlan.fromMap(map)).toList();
  }

  Future<List<MealPlan>> getMealPlansByDate(DateTime date) async {
    final db = await _databaseHelper.database;
    
    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;
    
    final maps = await db.query(
      'meal_plans',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startOfDay, endOfDay],
      orderBy: 'meal_type ASC',
    );
    
    return maps.map((map) => MealPlan.fromMap(map)).toList();
  }

  Future<List<MealPlan>> getMealPlansByMealType(String mealType) async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'meal_plans',
      where: 'meal_type = ?',
      whereArgs: [mealType],
      orderBy: 'date ASC',
    );
    
    return maps.map((map) => MealPlan.fromMap(map)).toList();
  }

  Future<int> deleteMealPlansByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await _databaseHelper.database;
    
    final startTimestamp = startDate.millisecondsSinceEpoch;
    final endTimestamp = endDate.millisecondsSinceEpoch;
    
    return await db.delete(
      'meal_plans',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startTimestamp, endTimestamp],
    );
  }

  Future<int> deleteMealPlanByDateAndType(DateTime date, String mealType) async {
    final db = await _databaseHelper.database;
    
    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;
    
    return await db.delete(
      'meal_plans',
      where: 'date >= ? AND date <= ? AND meal_type = ?',
      whereArgs: [startOfDay, endOfDay, mealType],
    );
  }

  Future<bool> hasMealPlanForDateAndType(DateTime date, String mealType) async {
    final db = await _databaseHelper.database;
    
    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;
    
    final result = await db.query(
      'meal_plans',
      where: 'date >= ? AND date <= ? AND meal_type = ?',
      whereArgs: [startOfDay, endOfDay, mealType],
      limit: 1,
    );
    
    return result.isNotEmpty;
  }
}
