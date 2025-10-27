import 'package:share_plus/share_plus.dart';
import '../models/recipe_model.dart';
import '../models/grocery_item_model.dart';

class ShareService {
  Future<void> shareRecipe(Recipe recipe) async {
    final String shareText = _formatRecipeForSharing(recipe);
    
    try {
      await Share.share(shareText, subject: recipe.name);
    } catch (e) {
      print('Error sharing recipe: $e');
    }
  }

  Future<void> shareGroceryList(List<GroceryItem> items) async {
    final String shareText = _formatGroceryListForSharing(items);
    
    try {
      await Share.share(shareText, subject: 'Grocery List');
    } catch (e) {
      print('Error sharing grocery list: $e');
    }
  }

  String _formatRecipeForSharing(Recipe recipe) {
    final buffer = StringBuffer();
    
    buffer.writeln('🍽️ ${recipe.name}');
    buffer.writeln('');
    buffer.writeln('📝 Description:');
    buffer.writeln(recipe.description);
    buffer.writeln('');
    buffer.writeln('⏱️ Prep Time: ${recipe.prepTime} minutes');
    buffer.writeln('🔥 Cook Time: ${recipe.cookTime} minutes');
    buffer.writeln('👥 Servings: ${recipe.servings}');
    buffer.writeln('📊 Difficulty: ${recipe.difficulty.toUpperCase()}');
    buffer.writeln('');
    
    if (recipe.dietaryTags.isNotEmpty) {
      buffer.writeln('🏷️ Dietary Tags:');
      buffer.writeln(recipe.dietaryTags.map((tag) => '• $tag').join('\n'));
      buffer.writeln('');
    }
    
    buffer.writeln('🥘 Ingredients:');
    for (final ingredient in recipe.ingredients) {
      buffer.writeln('• ${ingredient.quantity} ${ingredient.unit} ${ingredient.name}');
    }
    buffer.writeln('');
    
    buffer.writeln('👨‍🍳 Instructions:');
    for (int i = 0; i < recipe.instructions.length; i++) {
      buffer.writeln('${i + 1}. ${recipe.instructions[i]}');
    }
    
    return buffer.toString();
  }

  String _formatGroceryListForSharing(List<GroceryItem> items) {
    final buffer = StringBuffer();
    
    buffer.writeln('🛒 Grocery List');
    buffer.writeln('');
    
    final groupedItems = <String, List<GroceryItem>>{};
    for (final item in items) {
      if (!groupedItems.containsKey(item.category)) {
        groupedItems[item.category] = [];
      }
      groupedItems[item.category]!.add(item);
    }
    
    for (final category in groupedItems.keys.toList()..sort()) {
      final categoryItems = groupedItems[category]!;
      buffer.writeln('📦 ${category.toUpperCase()}');
      
      for (final item in categoryItems) {
        final status = item.isChecked ? '✅' : '⬜';
        buffer.writeln('$status ${item.quantity} ${item.unit} ${item.name}');
      }
      buffer.writeln('');
    }
    
    return buffer.toString();
  }
}
