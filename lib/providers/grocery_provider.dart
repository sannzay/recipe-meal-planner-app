import 'package:flutter/foundation.dart';
import '../models/grocery_item_model.dart';
import '../database/grocery_repository.dart';

class GroceryProvider with ChangeNotifier {
  final GroceryRepository _groceryRepository = GroceryRepository();
  
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

  Future<void> generateFromMealPlan(DateTime startDate, DateTime endDate) async {
    try {
      await _groceryRepository.generateFromMealPlan(startDate, endDate);
      await loadItems();
    } catch (e) {
      if (kDebugMode) {
        print('Error generating grocery list from meal plan: $e');
      }
    }
  }

  Future<void> clearCheckedItems() async {
    try {
      await _groceryRepository.clearCheckedItems();
      _items.removeWhere((item) => item.isChecked);
      _updateCategoryMap();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing checked items: $e');
      }
    }
  }

  Future<void> clearAllItems() async {
    try {
      await _groceryRepository.clearAllItems();
      _items.clear();
      _itemsByCategory.clear();
      notifyListeners();
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
}
