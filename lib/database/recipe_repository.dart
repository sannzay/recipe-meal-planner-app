import 'package:sqflite/sqflite.dart';
import '../models/recipe_model.dart';
import 'database_helper.dart';

class RecipeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await _databaseHelper.database;
    return await db.insert('recipes', recipe.toMap());
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
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
    
    return Recipe.fromMap(recipeMaps.first);
  }

  Future<List<Recipe>> getAllRecipes() async {
    final db = await _databaseHelper.database;
    final recipeMaps = await db.query('recipes', orderBy: 'createdAt DESC');
    return recipeMaps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<List<Recipe>> getRecipesByDietaryTags(List<String> tags) async {
    if (tags.isEmpty) return getAllRecipes();
    
    final db = await _databaseHelper.database;
    final List<Recipe> recipes = [];
    
    for (final tag in tags) {
      final recipeMaps = await db.query(
        'recipes',
        where: 'dietaryTags LIKE ?',
        whereArgs: ['%$tag%'],
        orderBy: 'createdAt DESC',
      );
      
      for (final recipeMap in recipeMaps) {
        final recipe = Recipe.fromMap(recipeMap);
        if (!recipes.any((r) => r.id == recipe.id)) {
          recipes.add(recipe);
        }
      }
    }
    
    return recipes;
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    final db = await _databaseHelper.database;
    
    final recipeMaps = await db.query(
      'recipes',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );
    
    return recipeMaps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<int> toggleFavorite(String id) async {
    final db = await _databaseHelper.database;
    
    final recipe = await getRecipeById(id);
    if (recipe == null) return 0;
    
    return await db.update(
      'recipes',
      {'isFavorite': recipe.isFavorite ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    if (query.isEmpty) return getAllRecipes();
    
    final db = await _databaseHelper.database;
    
    final recipeMaps = await db.query(
      'recipes',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    
    return recipeMaps.map((map) => Recipe.fromMap(map)).toList();
  }
}
