import 'package:share_plus/share_plus.dart';
import '../models/recipe_model.dart';
import '../models/grocery_item_model.dart';

class ShareService {
  static Future<void> shareRecipe(Recipe recipe) async {
    final String shareText = _formatRecipeForSharing(recipe);
    
    await Share.share(
      shareText,
      subject: 'Check out this recipe: ${recipe.name}',
    );
  }

  static Future<void> shareGroceryList(List<GroceryItem> items) async {
    final String shareText = _formatGroceryListForSharing(items);
    
    await Share.share(
      shareText,
      subject: 'My Grocery List',
    );
  }

  static String _formatRecipeForSharing(Recipe recipe) {
    final StringBuffer buffer = StringBuffer();
    
    buffer.writeln('🍽️ ${recipe.name}');
    buffer.writeln('');
    
    if (recipe.description.isNotEmpty) {
      buffer.writeln('📝 Description:');
      buffer.writeln(recipe.description);
      buffer.writeln('');
    }
    
    buffer.writeln('⏱️ Cooking Info:');
    buffer.writeln('• Prep Time: ${recipe.prepTime} minutes');
    buffer.writeln('• Cook Time: ${recipe.cookTime} minutes');
    buffer.writeln('• Total Time: ${recipe.prepTime + recipe.cookTime} minutes');
    buffer.writeln('• Servings: ${recipe.servings}');
    buffer.writeln('• Difficulty: ${recipe.difficulty}');
    buffer.writeln('');
    
    if (recipe.dietaryTags.isNotEmpty) {
      buffer.writeln('🏷️ Dietary Tags:');
      buffer.writeln(recipe.dietaryTags.map((tag) => '• $tag').join('\n'));
      buffer.writeln('');
    }
    
    if (recipe.ingredients.isNotEmpty) {
      buffer.writeln('🥘 Ingredients:');
      for (int i = 0; i < recipe.ingredients.length; i++) {
        final ingredient = recipe.ingredients[i];
        buffer.writeln('${i + 1}. ${ingredient.name}${ingredient.quantity.isNotEmpty ? ' - ${ingredient.quantity}' : ''}');
      }
      buffer.writeln('');
    }
    
    if (recipe.instructions.isNotEmpty) {
      buffer.writeln('👨‍🍳 Instructions:');
      for (int i = 0; i < recipe.instructions.length; i++) {
        buffer.writeln('${i + 1}. ${recipe.instructions[i]}');
        buffer.writeln('');
      }
    }
    
    buffer.writeln('📱 Shared from Recipe & Meal Planner App');
    
    return buffer.toString();
  }

  static String _formatGroceryListForSharing(List<GroceryItem> items) {
    if (items.isEmpty) {
      return '🛒 My Grocery List\n\nNo items yet!\n\n📱 Shared from Recipe & Meal Planner App';
    }

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('🛒 My Grocery List');
    buffer.writeln('');
    
    final Map<String, List<GroceryItem>> groupedItems = _groupItemsByCategory(items);
    final List<String> categories = groupedItems.keys.toList()..sort();
    
    int totalItems = 0;
    int checkedItems = 0;
    
    for (final category in categories) {
      final categoryItems = groupedItems[category]!;
      final categoryChecked = categoryItems.where((item) => item.isChecked).length;
      
      buffer.writeln('📦 ${category.toUpperCase()}');
      buffer.writeln('Progress: $categoryChecked/${categoryItems.length}');
      
      for (final item in categoryItems) {
        final checkmark = item.isChecked ? '✅' : '⬜';
        final quantity = item.quantity.isNotEmpty ? ' (${item.quantity})' : '';
        buffer.writeln('$checkmark ${item.name}$quantity');
        
        totalItems++;
        if (item.isChecked) checkedItems++;
      }
      
      buffer.writeln('');
    }
    
    buffer.writeln('📊 Summary:');
    buffer.writeln('• Total Items: $totalItems');
    buffer.writeln('• Completed: $checkedItems');
    buffer.writeln('• Remaining: ${totalItems - checkedItems}');
    buffer.writeln('');
    buffer.writeln('📱 Shared from Recipe & Meal Planner App');
    
    return buffer.toString();
  }

  static Map<String, List<GroceryItem>> _groupItemsByCategory(List<GroceryItem> items) {
    final Map<String, List<GroceryItem>> grouped = {};
    
    for (final item in items) {
      final category = item.category.isNotEmpty ? item.category : 'Other';
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(item);
    }
    
    return grouped;
  }

  static String formatRecipeAsText(Recipe recipe) {
    return _formatRecipeForSharing(recipe);
  }

  static String formatGroceryListAsText(List<GroceryItem> items) {
    return _formatGroceryListForSharing(items);
  }

  static Future<void> shareText(String text, {String? subject}) async {
    await Share.share(
      text,
      subject: subject,
    );
  }

  static Future<void> shareFile(String filePath, {String? text, String? subject}) async {
    await Share.shareXFiles(
      [XFile(filePath)],
      text: text,
      subject: subject,
    );
  }
}