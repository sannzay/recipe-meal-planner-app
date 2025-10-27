import 'package:sqflite/sqflite.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import 'database_helper.dart';

class RecipeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await _databaseHelper.database;
    
    await db.transaction((txn) async {
      await txn.insert('recipes', recipe.toMap());
      
      for (final ingredient in recipe.ingredients) {
        await txn.insert('ingredients', {
          ...ingredient.toMap(),
          'recipe_id': recipe.id,
        });
      }
    });
    
    return 1;
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await _databaseHelper.database;
    
    await db.transaction((txn) async {
      await txn.update(
        'recipes',
        recipe.toMap(),
        where: 'id = ?',
        whereArgs: [recipe.id],
      );
      
      await txn.delete(
        'ingredients',
        where: 'recipe_id = ?',
        whereArgs: [recipe.id],
      );
      
      for (final ingredient in recipe.ingredients) {
        await txn.insert('ingredients', {
          ...ingredient.toMap(),
          'recipe_id': recipe.id,
        });
      }
    });
    
    return 1;
  }

  Future<int> deleteRecipe(String id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Recipe?> getRecipeById(String id) async {
    final db = await _databaseHelper.database;
    
    final recipeMaps = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (recipeMaps.isEmpty) return null;
    
    final ingredientMaps = await db.query(
      'ingredients',
      where: 'recipe_id = ?',
      whereArgs: [id],
    );
    
    final recipe = Recipe.fromMap(recipeMaps.first);
    final ingredients = ingredientMaps.map((map) => Ingredient.fromMap(map)).toList();
    
    return recipe.copyWith(ingredients: ingredients);
  }

  Future<List<Recipe>> getAllRecipes() async {
    final db = await _databaseHelper.database;
    
    final recipeMaps = await db.query('recipes', orderBy: 'created_at DESC');
    final List<Recipe> recipes = [];
    
    for (final recipeMap in recipeMaps) {
      final recipe = Recipe.fromMap(recipeMap);
      final ingredientMaps = await db.query(
        'ingredients',
        where: 'recipe_id = ?',
        whereArgs: [recipe.id],
      );
      final ingredients = ingredientMaps.map((map) => Ingredient.fromMap(map)).toList();
      recipes.add(recipe.copyWith(ingredients: ingredients));
    }
    
    return recipes;
  }

  Future<List<Recipe>> getRecipesByDietaryTags(List<String> tags) async {
    if (tags.isEmpty) return getAllRecipes();
    
    final db = await _databaseHelper.database;
    final List<Recipe> recipes = [];
    
    for (final tag in tags) {
      final recipeMaps = await db.query(
        'recipes',
        where: 'dietary_tags LIKE ?',
        whereArgs: ['%$tag%'],
        orderBy: 'created_at DESC',
      );
      
      for (final recipeMap in recipeMaps) {
        final recipe = Recipe.fromMap(recipeMap);
        final ingredientMaps = await db.query(
          'ingredients',
          where: 'recipe_id = ?',
          whereArgs: [recipe.id],
        );
        final ingredients = ingredientMaps.map((map) => Ingredient.fromMap(map)).toList();
        
        if (!recipes.any((r) => r.id == recipe.id)) {
          recipes.add(recipe.copyWith(ingredients: ingredients));
        }
      }
    }
    
    return recipes;
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    final db = await _databaseHelper.database;
    
    final recipeMaps = await db.query(
      'recipes',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    
    final List<Recipe> recipes = [];
    
    for (final recipeMap in recipeMaps) {
      final recipe = Recipe.fromMap(recipeMap);
      final ingredientMaps = await db.query(
        'ingredients',
        where: 'recipe_id = ?',
        whereArgs: [recipe.id],
      );
      final ingredients = ingredientMaps.map((map) => Ingredient.fromMap(map)).toList();
      recipes.add(recipe.copyWith(ingredients: ingredients));
    }
    
    return recipes;
  }

  Future<int> toggleFavorite(String id) async {
    final db = await _databaseHelper.database;
    
    final recipe = await getRecipeById(id);
    if (recipe == null) return 0;
    
    return await db.update(
      'recipes',
      {'is_favorite': recipe.isFavorite ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    if (query.isEmpty) return getAllRecipes();
    
    final db = await _databaseHelper.database;
    
    final recipeMaps = await db.query(
      'recipes',
      where: 'name LIKE ? OR description LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
    
    final List<Recipe> recipes = [];
    
    for (final recipeMap in recipeMaps) {
      final recipe = Recipe.fromMap(recipeMap);
      final ingredientMaps = await db.query(
        'ingredients',
        where: 'recipe_id = ?',
        whereArgs: [recipe.id],
      );
      final ingredients = ingredientMaps.map((map) => Ingredient.fromMap(map)).toList();
      recipes.add(recipe.copyWith(ingredients: ingredients));
    }
    
    return recipes;
  }
}
