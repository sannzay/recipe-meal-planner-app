import 'package:flutter/foundation.dart';
import '../models/recipe_model.dart';
import '../database/recipe_repository.dart';
import '../services/error_handling_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeRepository _recipeRepository = RecipeRepository();
  
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  List<String> _activeFilters = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  List<Recipe> get filteredRecipes => _filteredRecipes;
  List<String> get activeFilters => _activeFilters;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  Future<void> loadRecipes() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _recipes = await ErrorHandler.handleDatabaseOperation(
        () => _recipeRepository.getAllRecipes(),
        operationName: 'loadRecipes',
        fallbackValue: <Recipe>[],
      );
      _applyFilters();
      ErrorHandler.logInfo('Recipes loaded successfully: ${_recipes.length} recipes');
    } catch (e) {
      ErrorHandler.logError('Failed to load recipes', e);
      _recipes = [];
      _filteredRecipes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterByDietary(List<String> tags) async {
    _activeFilters = List.from(tags);
    _applyFilters();
  }

  Future<void> searchRecipes(String query) async {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    List<Recipe> filtered = List.from(_recipes);
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((recipe) =>
        recipe.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        recipe.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        recipe.category.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_activeFilters.isNotEmpty) {
      filtered = filtered.where((recipe) {
        return _activeFilters.any((filter) =>
          recipe.dietaryTags.any((tag) => tag.toLowerCase() == filter.toLowerCase())
        );
      }).toList();
    }
    
    _filteredRecipes = filtered;
    notifyListeners();
  }

  Future<void> toggleFavorite(String recipeId) async {
    try {
      await ErrorHandler.handleDatabaseOperation(
        () => _recipeRepository.toggleFavorite(recipeId),
        operationName: 'toggleFavorite',
      );
      
      final recipeIndex = _recipes.indexWhere((r) => r.id == recipeId);
      if (recipeIndex != -1) {
        _recipes[recipeIndex] = _recipes[recipeIndex].copyWith(
          isFavorite: !_recipes[recipeIndex].isFavorite,
        );
      }
      
      final filteredIndex = _filteredRecipes.indexWhere((r) => r.id == recipeId);
      if (filteredIndex != -1) {
        _filteredRecipes[filteredIndex] = _filteredRecipes[filteredIndex].copyWith(
          isFavorite: !_filteredRecipes[filteredIndex].isFavorite,
        );
      }
      
      notifyListeners();
      ErrorHandler.logInfo('Recipe favorite toggled successfully: $recipeId');
    } catch (e) {
      ErrorHandler.logError('Failed to toggle favorite for recipe: $recipeId', e);
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _recipeRepository.insertRecipe(recipe);
      _recipes.insert(0, recipe);
      _applyFilters();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding recipe: $e');
      }
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _recipeRepository.updateRecipe(recipe);
      
      final index = _recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        _recipes[index] = recipe;
      }
      
      _applyFilters();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating recipe: $e');
      }
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _recipeRepository.deleteRecipe(recipeId);
      _recipes.removeWhere((r) => r.id == recipeId);
      _applyFilters();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting recipe: $e');
      }
    }
  }

  List<Recipe> getFavoriteRecipes() {
    return _recipes.where((recipe) => recipe.isFavorite).toList();
  }

  void clearFilters() {
    _activeFilters.clear();
    _searchQuery = '';
    _applyFilters();
  }
}
