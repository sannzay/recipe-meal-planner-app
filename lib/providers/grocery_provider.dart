import 'package:flutter/foundation.dart';
import '../models/grocery_item_model.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../database/grocery_repository.dart';
import '../database/recipe_repository.dart';
import '../database/meal_plan_repository.dart';
import '../utils/constants.dart';

class GroceryProvider with ChangeNotifier {
  final GroceryRepository _groceryRepository = GroceryRepository();
  final RecipeRepository _recipeRepository = RecipeRepository();
  final MealPlanRepository _mealPlanRepository = MealPlanRepository();
  
  List<GroceryItem> _items = [];
  Map<String, List<GroceryItem>> _itemsByCategory = {};

  List<GroceryItem> get items => _items;
  Map<String, List<GroceryItem>> get itemsByCategory => _itemsByCategory;

  List<GroceryItem> get uncheckedItems => _items.where((item) => !item.isChecked).toList();
  List<GroceryItem> get checkedItems => _items.where((item) => item.isChecked).toList();

  Future<void> loadItems() async {
    try {
      _items = await _groceryRepository.getAllGroceryItems();
      _itemsByCategory = await _groceryRepository.getGroceryItemsGroupedByCategory();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading grocery items: $e');
      }
    }
  }

  Future<void> addItem(GroceryItem item) async {
    try {
      await _groceryRepository.insertGroceryItem(item);
      _items.add(item);
      _updateCategoryMap();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding grocery item: $e');
      }
    }
  }

  Future<void> updateItem(GroceryItem item) async {
    try {
      await _groceryRepository.updateGroceryItem(item);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
      }
      _updateCategoryMap();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating grocery item: $e');
      }
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await _groceryRepository.deleteGroceryItem(itemId);
      _items.removeWhere((item) => item.id == itemId);
      _updateCategoryMap();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting grocery item: $e');
      }
    }
  }

  Future<void> toggleChecked(String itemId) async {
    try {
      await _groceryRepository.toggleGroceryItemChecked(itemId);
      
      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = _items[index].copyWith(isChecked: !_items[index].isChecked);
      }
      
      _updateCategoryMap();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling grocery item: $e');
      }
    }
  }

  Future<void> generateFromMealPlan([DateTime? startDate, DateTime? endDate]) async {
    try {
      final weekStart = startDate ?? _getCurrentWeekStart();
      final weekEnd = endDate ?? _getCurrentWeekEnd();
      
      final mealPlans = await _mealPlanRepository.getMealPlansByDateRange(weekStart, weekEnd);
      
      if (mealPlans.isEmpty) {
        if (kDebugMode) {
          print('No meal plans found for the selected week');
        }
        return;
      }
      
      final recipeIds = mealPlans.map((plan) => plan.recipeId).where((id) => id.isNotEmpty).toSet();
      final recipes = <Recipe>[];
      
      for (final recipeId in recipeIds) {
        try {
          final recipe = await _recipeRepository.getRecipeById(recipeId);
          if (recipe != null) {
            recipes.add(recipe);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error fetching recipe $recipeId: $e');
          }
        }
      }
      
      final generatedItems = _generateGroceryItemsFromRecipes(recipes);
      await _mergeWithExistingItems(generatedItems);
      
      await loadItems();
      
      if (kDebugMode) {
        print('Generated ${generatedItems.length} grocery items from ${recipes.length} recipes');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error generating grocery list from meal plan: $e');
      }
    }
  }

  DateTime _getCurrentWeekStart() {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1));
  }

  DateTime _getCurrentWeekEnd() {
    final weekStart = _getCurrentWeekStart();
    return weekStart.add(const Duration(days: 6));
  }

  List<GroceryItem> _generateGroceryItemsFromRecipes(List<Recipe> recipes) {
    final ingredientMap = <String, List<Ingredient>>{};
    
    for (final recipe in recipes) {
      for (final ingredient in recipe.ingredients) {
        final key = _normalizeIngredientName(ingredient.name);
        if (!ingredientMap.containsKey(key)) {
          ingredientMap[key] = [];
        }
        ingredientMap[key]!.add(ingredient);
      }
    }
    
    final groceryItems = <GroceryItem>[];
    
    for (final entry in ingredientMap.entries) {
      final ingredients = entry.value;
      final firstIngredient = ingredients.first;
      
      final combinedQuantity = _combineQuantities(ingredients);
      final category = _determineCategory(firstIngredient.category, firstIngredient.name);
      
      final groceryItem = GroceryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_${entry.key.hashCode}',
        name: _formatIngredientName(firstIngredient.name),
        quantity: combinedQuantity,
        unit: firstIngredient.unit,
        category: category,
        isChecked: false,
        fromRecipeId: ingredients.map((i) => i.id).join(','),
      );
      
      groceryItems.add(groceryItem);
    }
    
    return groceryItems;
  }

  String _normalizeIngredientName(String name) {
    return name.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String _formatIngredientName(String name) {
    final words = name.toLowerCase().split(' ');
    if (words.isNotEmpty) {
      words[0] = words[0][0].toUpperCase() + words[0].substring(1);
    }
    return words.join(' ');
  }

  String _combineQuantities(List<Ingredient> ingredients) {
    if (ingredients.length == 1) {
      return ingredients.first.quantity;
    }
    
    final quantities = <String>[];
    final units = <String>{};
    
    for (final ingredient in ingredients) {
      quantities.add(ingredient.quantity);
      units.add(ingredient.unit.toLowerCase());
    }
    
    if (units.length == 1) {
      final unit = units.first;
      final totalAmount = _calculateTotalAmount(quantities);
      return totalAmount > 0 ? '$totalAmount $unit' : quantities.join(' + ');
    }
    
    return quantities.join(' + ');
  }

  double _calculateTotalAmount(List<String> quantities) {
    double total = 0.0;
    
    for (final quantity in quantities) {
      final amount = _parseQuantity(quantity);
      if (amount > 0) {
        total += amount;
      }
    }
    
    return total;
  }

  double _parseQuantity(String quantity) {
    final cleanQuantity = quantity.replaceAll(RegExp(r'[^\d.,/]'), '');
    
    if (cleanQuantity.contains('/')) {
      final parts = cleanQuantity.split('/');
      if (parts.length == 2) {
        final numerator = double.tryParse(parts[0]) ?? 0.0;
        final denominator = double.tryParse(parts[1]) ?? 1.0;
        return denominator != 0 ? numerator / denominator : 0.0;
      }
    }
    
    return double.tryParse(cleanQuantity) ?? 0.0;
  }

  String _determineCategory(String originalCategory, String ingredientName) {
    final name = ingredientName.toLowerCase();
    
    if (name.contains('milk') || name.contains('cheese') || name.contains('yogurt') || 
        name.contains('butter') || name.contains('cream')) {
      return IngredientCategories.dairy;
    }
    
    if (name.contains('chicken') || name.contains('beef') || name.contains('pork') || 
        name.contains('lamb') || name.contains('turkey')) {
      return IngredientCategories.meat;
    }
    
    if (name.contains('salmon') || name.contains('tuna') || name.contains('shrimp') || 
        name.contains('fish') || name.contains('crab')) {
      return IngredientCategories.seafood;
    }
    
    if (name.contains('apple') || name.contains('banana') || name.contains('orange') || 
        name.contains('tomato') || name.contains('onion') || name.contains('carrot') ||
        name.contains('lettuce') || name.contains('spinach') || name.contains('pepper')) {
      return IngredientCategories.produce;
    }
    
    if (name.contains('flour') || name.contains('sugar') || name.contains('rice') || 
        name.contains('pasta') || name.contains('bread') || name.contains('oil')) {
      return IngredientCategories.pantry;
    }
    
    if (name.contains('salt') || name.contains('pepper') || name.contains('garlic') || 
        name.contains('ginger') || name.contains('basil') || name.contains('oregano')) {
      return IngredientCategories.spices;
    }
    
    return originalCategory.isNotEmpty ? originalCategory : IngredientCategories.pantry;
  }

  Future<void> _mergeWithExistingItems(List<GroceryItem> newItems) async {
    final existingItems = await _groceryRepository.getAllGroceryItems();
    final mergedItems = <GroceryItem>[];
    
    for (final newItem in newItems) {
      final existingItem = existingItems.firstWhere(
        (item) => _normalizeIngredientName(item.name) == _normalizeIngredientName(newItem.name),
        orElse: () => GroceryItem(
          id: '',
          name: '',
          quantity: '',
          unit: '',
          category: '',
          isChecked: false,
        ),
      );
      
      if (existingItem.id.isNotEmpty) {
        final combinedQuantity = _combineQuantities([
          Ingredient(id: '', name: existingItem.name, quantity: existingItem.quantity, unit: existingItem.unit, category: existingItem.category),
          Ingredient(id: '', name: newItem.name, quantity: newItem.quantity, unit: newItem.unit, category: newItem.category),
        ]);
        
        final updatedItem = existingItem.copyWith(
          quantity: combinedQuantity,
          fromRecipeId: '${existingItem.fromRecipeId},${newItem.fromRecipeId}',
        );
        
        await _groceryRepository.updateGroceryItem(updatedItem);
        mergedItems.add(updatedItem);
      } else {
        await _groceryRepository.insertGroceryItem(newItem);
        mergedItems.add(newItem);
      }
    }
  }

  Future<void> clearCheckedItems() async {
    try {
      if (kDebugMode) {
        print('Starting clearCheckedItems - Current items count: ${_items.length}');
        print('Checked items count: ${checkedItems.length}');
        print('Checked items: ${checkedItems.map((item) => '${item.name} (${item.isChecked})').join(', ')}');
      }
      
      final deletedCount = await _groceryRepository.clearCheckedItems();
      
      if (kDebugMode) {
        print('Database delete operation returned: $deletedCount items deleted');
      }
      
      // Reload items from database to ensure UI is in sync
      await loadItems();
      
      if (kDebugMode) {
        print('After reload - Items count: ${_items.length}');
        print('After reload - Checked items count: ${checkedItems.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing checked items: $e');
      }
    }
  }

  Future<void> clearAllItems() async {
    try {
      await _groceryRepository.clearAllItems();
      // Reload items from database to ensure UI is in sync
      await loadItems();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing all items: $e');
      }
    }
  }

  void _updateCategoryMap() {
    _itemsByCategory.clear();
    for (final item in _items) {
      if (!_itemsByCategory.containsKey(item.category)) {
        _itemsByCategory[item.category] = [];
      }
      _itemsByCategory[item.category]!.add(item);
    }
  }

  List<String> getCategories() {
    return _itemsByCategory.keys.toList()..sort();
  }

  List<GroceryItem> getItemsByCategory(String category) {
    return _itemsByCategory[category] ?? [];
  }

  int getTotalItemsCount() {
    return _items.length;
  }

  int getCheckedItemsCount() {
    return checkedItems.length;
  }

  int getUncheckedItemsCount() {
    return uncheckedItems.length;
  }

  double getCompletionPercentage() {
    if (_items.isEmpty) return 0.0;
    return (checkedItems.length / _items.length) * 100;
  }

  List<GroceryItem> searchItems(String query) {
    if (query.isEmpty) return _items;
    
    return _items.where((item) =>
      item.name.toLowerCase().contains(query.toLowerCase()) ||
      item.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  Map<String, List<GroceryItem>> getGroupedItems() {
    return _itemsByCategory;
  }
}
