import 'package:sqflite/sqflite.dart';
import '../models/grocery_item_model.dart';
import '../models/meal_plan_model.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import 'database_helper.dart';
import 'meal_plan_repository.dart';
import 'recipe_repository.dart';

class GroceryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final MealPlanRepository _mealPlanRepository = MealPlanRepository();
  final RecipeRepository _recipeRepository = RecipeRepository();

  Future<int> insertGroceryItem(GroceryItem item) async {
    final db = await _databaseHelper.database;
    return await db.insert('grocery_items', item.toMap());
  }

  Future<int> updateGroceryItem(GroceryItem item) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'grocery_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteGroceryItem(String id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'grocery_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<GroceryItem?> getGroceryItemById(String id) async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'grocery_items',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return GroceryItem.fromMap(maps.first);
  }

  Future<List<GroceryItem>> getAllGroceryItems() async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query('grocery_items', orderBy: 'category ASC, name ASC');
    return maps.map((map) => GroceryItem.fromMap(map)).toList();
  }

  Future<List<GroceryItem>> getGroceryItemsByCategory(String category) async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'grocery_items',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );
    
    return maps.map((map) => GroceryItem.fromMap(map)).toList();
  }

  Future<List<GroceryItem>> getUncheckedGroceryItems() async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'grocery_items',
      where: 'is_checked = ?',
      whereArgs: [0],
      orderBy: 'category ASC, name ASC',
    );
    
    return maps.map((map) => GroceryItem.fromMap(map)).toList();
  }

  Future<List<GroceryItem>> getCheckedGroceryItems() async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'grocery_items',
      where: 'is_checked = ?',
      whereArgs: [1],
      orderBy: 'category ASC, name ASC',
    );
    
    return maps.map((map) => GroceryItem.fromMap(map)).toList();
  }

  Future<int> toggleGroceryItemChecked(String id) async {
    final db = await _databaseHelper.database;
    
    final item = await getGroceryItemById(id);
    if (item == null) return 0;
    
    return await db.update(
      'grocery_items',
      {'is_checked': item.isChecked ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearCheckedItems() async {
    final db = await _databaseHelper.database;
    
    // First, let's see how many checked items exist
    final checkedItems = await db.query(
      'grocery_items',
      where: 'is_checked = ?',
      whereArgs: [1],
    );
    
    print('Found ${checkedItems.length} checked items in database');
    for (final item in checkedItems) {
      print('Checked item: ${item['name']} (id: ${item['id']})');
    }
    
    final result = await db.delete(
      'grocery_items',
      where: 'is_checked = ?',
      whereArgs: [1],
    );
    
    print('Database delete operation completed. Rows affected: $result');
    return result;
  }

  Future<int> clearAllItems() async {
    final db = await _databaseHelper.database;
    return await db.delete('grocery_items');
  }

  Future<List<GroceryItem>> generateFromMealPlan(DateTime startDate, DateTime endDate) async {
    final mealPlans = await _mealPlanRepository.getMealPlansByDateRange(startDate, endDate);
    final Map<String, GroceryItem> combinedItems = {};
    
    for (final mealPlan in mealPlans) {
      final recipe = await _recipeRepository.getRecipeById(mealPlan.recipeId);
      if (recipe != null) {
        for (final ingredient in recipe.ingredients) {
          final key = '${ingredient.name.toLowerCase()}_${ingredient.category}';
          
          if (combinedItems.containsKey(key)) {
            final existingItem = combinedItems[key]!;
            final newQuantity = _combineQuantities(existingItem.quantity, existingItem.unit, ingredient.quantity, ingredient.unit);
            combinedItems[key] = existingItem.copyWith(
              quantity: newQuantity,
              fromRecipeId: '${existingItem.fromRecipeId},${recipe.id}',
            );
          } else {
            combinedItems[key] = GroceryItem(
              id: DateTime.now().millisecondsSinceEpoch.toString() + '_${ingredient.name}',
              name: ingredient.name,
              quantity: ingredient.quantity,
              unit: ingredient.unit,
              category: ingredient.category,
              isChecked: false,
              fromRecipeId: recipe.id,
            );
          }
        }
      }
    }
    
    final List<GroceryItem> items = combinedItems.values.toList();
    
    for (final item in items) {
      final existingItem = await _findExistingItem(item.name, item.category);
      if (existingItem != null) {
        final combinedQuantity = _combineQuantities(existingItem.quantity, existingItem.unit, item.quantity, item.unit);
        await updateGroceryItem(existingItem.copyWith(
          quantity: combinedQuantity,
          fromRecipeId: '${existingItem.fromRecipeId},${item.fromRecipeId}',
        ));
      } else {
        await insertGroceryItem(item);
      }
    }
    
    return await getAllGroceryItems();
  }

  Future<GroceryItem?> _findExistingItem(String name, String category) async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'grocery_items',
      where: 'name = ? AND category = ?',
      whereArgs: [name, category],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return GroceryItem.fromMap(maps.first);
  }

  String _combineQuantities(String qty1, String unit1, String qty2, String unit2) {
    if (unit1 != unit2) {
      return '$qty1 $unit1 + $qty2 $unit2';
    }
    
    try {
      final num1 = double.parse(qty1);
      final num2 = double.parse(qty2);
      final combined = num1 + num2;
      
      if (combined == combined.toInt()) {
        return combined.toInt().toString();
      } else {
        return combined.toString();
      }
    } catch (e) {
      return '$qty1 + $qty2';
    }
  }

  Future<Map<String, List<GroceryItem>>> getGroceryItemsGroupedByCategory() async {
    final items = await getAllGroceryItems();
    final Map<String, List<GroceryItem>> grouped = {};
    
    for (final item in items) {
      if (!grouped.containsKey(item.category)) {
        grouped[item.category] = [];
      }
      grouped[item.category]!.add(item);
    }
    
    return grouped;
  }
}
