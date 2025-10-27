import 'package:sqflite/sqflite.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../utils/constants.dart';
import 'database_helper.dart';
import 'recipe_repository.dart';

class DatabaseSeeder {
  static final DatabaseSeeder _instance = DatabaseSeeder._internal();
  factory DatabaseSeeder() => _instance;
  DatabaseSeeder._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final RecipeRepository _recipeRepository = RecipeRepository();

  Future<void> seedDatabaseIfEmpty() async {
    try {
      final recipes = await _recipeRepository.getAllRecipes();
      
      if (recipes.isEmpty) {
        await _seedSampleRecipes();
      }
    } catch (e) {
      print('Error checking/seeding database: $e');
    }
  }

  Future<void> _seedSampleRecipes() async {
    try {
      for (final recipeData in SampleRecipes.recipes) {
        final recipe = _createRecipeFromData(recipeData);
        await _recipeRepository.insertRecipe(recipe);
      }
      print('Successfully seeded ${SampleRecipes.recipes.length} sample recipes');
    } catch (e) {
      print('Error seeding sample recipes: $e');
    }
  }

  Recipe _createRecipeFromData(Map<String, dynamic> data) {
    final ingredients = (data['ingredients'] as List)
        .map((ingredientData) => Ingredient(
              id: DateTime.now().millisecondsSinceEpoch.toString() + '_${ingredientData['name']}',
              name: ingredientData['name'],
              quantity: ingredientData['quantity'],
              unit: ingredientData['unit'],
              category: ingredientData['category'],
            ))
        .toList();

    return Recipe(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      prepTime: data['prepTime'],
      cookTime: data['cookTime'],
      servings: data['servings'],
      difficulty: data['difficulty'],
      category: data['category'],
      dietaryTags: List<String>.from(data['dietaryTags']),
      ingredients: ingredients,
      instructions: List<String>.from(data['instructions']),
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> clearAllData() async {
    try {
      await _databaseHelper.clearAllTables();
      print('All data cleared from database');
    } catch (e) {
      print('Error clearing database: $e');
    }
  }

  Future<void> reseedDatabase() async {
    try {
      await clearAllData();
      await _seedSampleRecipes();
      print('Database reseeded successfully');
    } catch (e) {
      print('Error reseeding database: $e');
    }
  }
}
