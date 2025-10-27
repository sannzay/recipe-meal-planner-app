import 'dart:convert';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../database/recipe_repository.dart';
import '../database/database_helper.dart';
import '../utils/constants.dart';
import '../services/error_handling_service.dart';

class DatabaseSeeder {
  static final DatabaseSeeder _instance = DatabaseSeeder._internal();
  factory DatabaseSeeder() => _instance;
  DatabaseSeeder._internal();

  final RecipeRepository _recipeRepository = RecipeRepository();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> seedDatabaseIfEmpty() async {
    try {
      ErrorHandler.logInfo('Checking if database needs seeding...');
      
      final recipes = await _recipeRepository.getAllRecipes();
      
      if (recipes.isEmpty) {
        ErrorHandler.logInfo('Database is empty. Starting seeding process...');
        await _seedSampleRecipes();
        ErrorHandler.logInfo('Database seeding completed successfully!');
      } else {
        ErrorHandler.logInfo('Database already contains ${recipes.length} recipes. Skipping seeding.');
      }
    } catch (e) {
      ErrorHandler.logError('Error during database seeding', e);
      rethrow;
    }
  }

  Future<void> _seedSampleRecipes() async {
    try {
      final sampleRecipes = SampleRecipes.recipes;
      ErrorHandler.logInfo('Seeding ${sampleRecipes.length} sample recipes...');

      for (final recipeData in sampleRecipes) {
        try {
          final recipe = _createRecipeFromData(recipeData);
          await _recipeRepository.insertRecipe(recipe);
          ErrorHandler.logInfo('Seeded recipe: ${recipe.name}');
        } catch (e) {
          ErrorHandler.logError('Failed to seed recipe: ${recipeData['name']}', e);
        }
      }
    } catch (e) {
      ErrorHandler.logError('Error seeding sample recipes', e);
      rethrow;
    }
  }

  Recipe _createRecipeFromData(Map<String, dynamic> data) {
    try {
      final ingredients = <Ingredient>[];
      
      if (data['ingredients'] != null) {
        for (final ingredientData in data['ingredients']) {
          final ingredient = Ingredient(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '_${ingredientData['name'].hashCode}',
            name: ingredientData['name'] as String,
            quantity: ingredientData['quantity'] as String,
            unit: ingredientData['unit'] as String,
            category: ingredientData['category'] as String,
          );
          ingredients.add(ingredient);
        }
      }

      final instructions = <String>[];
      if (data['instructions'] != null) {
        instructions.addAll((data['instructions'] as List).cast<String>());
      }

      final dietaryTags = <String>[];
      if (data['dietaryTags'] != null) {
        dietaryTags.addAll((data['dietaryTags'] as List).cast<String>());
      }

      return Recipe(
        id: data['id'] as String,
        name: data['name'] as String,
        description: data['description'] as String,
        imageUrl: data['imageUrl'] as String?,
        prepTime: data['prepTime'] as int,
        cookTime: data['cookTime'] as int,
        servings: data['servings'] as int,
        difficulty: data['difficulty'] as String,
        category: data['category'] as String,
        dietaryTags: dietaryTags,
        ingredients: ingredients,
        instructions: instructions,
        isFavorite: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      ErrorHandler.logError('Error creating recipe from data: ${data['name']}', e);
      rethrow;
    }
  }

  Future<void> clearAllData() async {
    try {
      ErrorHandler.logInfo('Clearing all database data...');
      await _databaseHelper.clearAllTables();
      ErrorHandler.logInfo('All database data cleared successfully!');
    } catch (e) {
      ErrorHandler.logError('Error clearing database data', e);
      rethrow;
    }
  }

  Future<void> reseedDatabase() async {
    try {
      ErrorHandler.logInfo('Reseeding database...');
      await clearAllData();
      await _seedSampleRecipes();
      ErrorHandler.logInfo('Database reseeding completed successfully!');
    } catch (e) {
      ErrorHandler.logError('Error reseeding database', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final recipes = await _recipeRepository.getAllRecipes();
      final stats = <String, dynamic>{
        'totalRecipes': recipes.length,
        'categories': <String, int>{},
        'difficultyLevels': <String, int>{},
        'dietaryTags': <String, int>{},
        'totalIngredients': 0,
        'averagePrepTime': 0.0,
        'averageCookTime': 0.0,
        'averageServings': 0.0,
      };

      int totalPrepTime = 0;
      int totalCookTime = 0;
      int totalServings = 0;

      for (final recipe in recipes) {
        // Count categories
        stats['categories'][recipe.category] = (stats['categories'][recipe.category] ?? 0) + 1;
        
        // Count difficulty levels
        stats['difficultyLevels'][recipe.difficulty] = (stats['difficultyLevels'][recipe.difficulty] ?? 0) + 1;
        
        // Count dietary tags
        for (final tag in recipe.dietaryTags) {
          stats['dietaryTags'][tag] = (stats['dietaryTags'][tag] ?? 0) + 1;
        }
        
        // Count ingredients
        stats['totalIngredients'] += recipe.ingredients.length;
        
        // Calculate averages
        totalPrepTime += recipe.prepTime;
        totalCookTime += recipe.cookTime;
        totalServings += recipe.servings;
      }

      if (recipes.isNotEmpty) {
        stats['averagePrepTime'] = totalPrepTime / recipes.length;
        stats['averageCookTime'] = totalCookTime / recipes.length;
        stats['averageServings'] = totalServings / recipes.length;
      }

      return stats;
    } catch (e) {
      ErrorHandler.logError('Error getting database stats', e);
      return <String, dynamic>{};
    }
  }

  Future<bool> isDatabaseHealthy() async {
    try {
      return await _databaseHelper.isDatabaseHealthy();
    } catch (e) {
      ErrorHandler.logError('Error checking database health', e);
      return false;
    }
  }

  Future<void> optimizeDatabase() async {
    try {
      ErrorHandler.logInfo('Optimizing database...');
      await _databaseHelper.vacuumDatabase();
      await _databaseHelper.analyzeDatabase();
      ErrorHandler.logInfo('Database optimization completed successfully!');
    } catch (e) {
      ErrorHandler.logError('Error optimizing database', e);
      rethrow;
    }
  }

  Future<void> backupDatabase() async {
    try {
      ErrorHandler.logInfo('Backing up database...');
      final recipes = await _recipeRepository.getAllRecipes();
      final backupData = {
        'timestamp': DateTime.now().toIso8601String(),
        'version': '1.0.0',
        'recipes': recipes.map((recipe) => recipe.toMap()).toList(),
      };
      
      // In a real app, you would save this to a file or cloud storage
      ErrorHandler.logInfo('Database backup created with ${recipes.length} recipes');
    } catch (e) {
      ErrorHandler.logError('Error creating database backup', e);
      rethrow;
    }
  }

  Future<void> restoreFromBackup(Map<String, dynamic> backupData) async {
    try {
      ErrorHandler.logInfo('Restoring database from backup...');
      
      if (backupData['recipes'] == null) {
        throw Exception('Invalid backup data: missing recipes');
      }
      
      await clearAllData();
      
      final recipes = (backupData['recipes'] as List).map((recipeData) {
        return Recipe.fromMap(recipeData as Map<String, dynamic>);
      }).toList();
      
      for (final recipe in recipes) {
        await _recipeRepository.insertRecipe(recipe);
      }
      
      ErrorHandler.logInfo('Database restored successfully with ${recipes.length} recipes');
    } catch (e) {
      ErrorHandler.logError('Error restoring database from backup', e);
      rethrow;
    }
  }

  Future<List<String>> getAvailableCategories() async {
    try {
      final recipes = await _recipeRepository.getAllRecipes();
      final categories = recipes.map((recipe) => recipe.category).toSet().toList();
      categories.sort();
      return categories;
    } catch (e) {
      ErrorHandler.logError('Error getting available categories', e);
      return [];
    }
  }

  Future<List<String>> getAvailableDietaryTags() async {
    try {
      final recipes = await _recipeRepository.getAllRecipes();
      final tags = <String>{};
      
      for (final recipe in recipes) {
        tags.addAll(recipe.dietaryTags);
      }
      
      final tagList = tags.toList();
      tagList.sort();
      return tagList;
    } catch (e) {
      ErrorHandler.logError('Error getting available dietary tags', e);
      return [];
    }
  }

  Future<List<String>> getAvailableDifficultyLevels() async {
    try {
      final recipes = await _recipeRepository.getAllRecipes();
      final difficulties = recipes.map((recipe) => recipe.difficulty).toSet().toList();
      difficulties.sort();
      return difficulties;
    } catch (e) {
      ErrorHandler.logError('Error getting available difficulty levels', e);
      return [];
    }
  }
}