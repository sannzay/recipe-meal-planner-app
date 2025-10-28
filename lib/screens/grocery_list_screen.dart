import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/grocery_provider.dart';
import '../providers/meal_plan_provider.dart';
import '../models/grocery_item_model.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../services/share_service.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroceryProvider>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Grocery List',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareGroceryList,
          ),
        ],
      ),
      body: Consumer<GroceryProvider>(
        builder: (context, groceryProvider, child) {
          final groupedItems = groceryProvider.getGroupedItems();
          
          if (groupedItems.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              _buildGenerateButton(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupedItems.length,
                  itemBuilder: (context, index) {
                    final category = groupedItems.keys.elementAt(index);
                    final items = groupedItems[category]!;
                    
                    return _buildCategorySection(category, items);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_grocery_fab",
        onPressed: _showAddItemDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your grocery list is empty',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate from your meal plan or add items manually',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _generateFromMealPlan,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Generate from Meal Plan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _generateFromMealPlan,
              icon: const Icon(Icons.auto_awesome),
              label: Text(
                'Generate from Meal Plan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _clearCompletedItems,
            icon: const Icon(Icons.clear_all),
            label: Text(
              'Clear Done',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, List<GroceryItem> items) {
    final completedCount = items.where((item) => item.isChecked).length;
    final totalCount = items.length;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  category.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '$completedCount/$totalCount',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildGroceryItem(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroceryItem(GroceryItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.isChecked,
            onChanged: (value) {
              context.read<GroceryProvider>().toggleChecked(item.id);
            },
            activeColor: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: item.isChecked 
                        ? TextDecoration.lineThrough 
                        : TextDecoration.none,
                    color: item.isChecked 
                        ? Colors.grey[500] 
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                if (item.quantity.isNotEmpty)
                  Text(
                    item.quantity,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                      decoration: item.isChecked 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _deleteItem(item),
            color: Colors.red[400],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'produce':
        return Icons.local_florist;
      case 'dairy':
        return Icons.local_drink;
      case 'meat':
        return Icons.restaurant;
      case 'seafood':
        return Icons.set_meal;
      case 'pantry':
        return Icons.kitchen;
      case 'spices':
        return Icons.spa;
      case 'beverages':
        return Icons.local_cafe;
      case 'frozen':
        return Icons.ac_unit;
      default:
        return Icons.shopping_basket;
    }
  }

  void _generateFromMealPlan() {
    context.read<GroceryProvider>().generateFromMealPlan();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Grocery list generated from meal plan'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _clearCompletedItems() {
    context.read<GroceryProvider>().clearCheckedItems();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Completed items cleared'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _deleteItem(GroceryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<GroceryProvider>().deleteItem(item.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted "${item.name}"'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _shareGroceryList() {
    final groceryProvider = context.read<GroceryProvider>();
    final items = groceryProvider.items;
    
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grocery list is empty'),
        ),
      );
      return;
    }

    ShareService.shareGroceryList(items);
  }

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    String selectedCategory = IngredientCategories.produce;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Item',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: IngredientCategories.allCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedCategory = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final item = GroceryItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  quantity: quantityController.text,
                  unit: '',
                  category: selectedCategory,
                  isChecked: false,
                );
                
                context.read<GroceryProvider>().addItem(item);
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added "${item.name}" to grocery list'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}