import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../models/ai_models.dart';
import '../services/recipe_ai_service.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';
import 'package:uuid/uuid.dart';

class AISuggestionScreen extends StatefulWidget {
  const AISuggestionScreen({super.key});

  @override
  State<AISuggestionScreen> createState() => _AISuggestionScreenState();
}

class _AISuggestionScreenState extends State<AISuggestionScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _selectedIngredients = [];
  final List<String> _selectedDietary = [];
  String _selectedCuisine = 'any';
  double _maxCookingTime = 60;
  
  bool _isLoading = false;
  AIRecipeResponse? _response;
  String? _errorMessage;

  final RecipeAIService _aiService = RecipeAIService();

  @override
  void dispose() {
    _ingredientController.dispose();
    _aiService.dispose();
    super.dispose();
  }

  Future<void> _getSuggestions() async {
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one ingredient'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _response = null;
    });

    try {
      final request = AIRecipeRequest(
        availableIngredients: _selectedIngredients,
        dietaryRestrictions: _selectedDietary,
        cuisinePreference: _selectedCuisine,
        maxCookingTime: _maxCookingTime.toInt(),
        numberOfSuggestions: 3,
      );

      final response = await _aiService.getSuggestions(request);

      setState(() {
        _response = response;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Generated ${response.suggestions.length} recipe suggestions!'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _addIngredient() {
    final ingredient = _ingredientController.text.trim();
    if (ingredient.isNotEmpty && !_selectedIngredients.contains(ingredient)) {
      setState(() {
        _selectedIngredients.add(ingredient);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
    });
  }

  void _toggleDietary(String dietary) {
    setState(() {
      if (_selectedDietary.contains(dietary)) {
        _selectedDietary.remove(dietary);
      } else {
        _selectedDietary.add(dietary);
      }
    });
  }

  Recipe _convertAISuggestionToRecipe(AIRecipeSuggestion suggestion) {
    final uuid = const Uuid();
    return Recipe(
      id: uuid.v4(),
      name: suggestion.name,
      description: suggestion.description,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      prepTime: suggestion.prepTime,
      cookTime: suggestion.cookTime,
      servings: suggestion.servings,
      difficulty: suggestion.difficulty,
      category: suggestion.cuisine,
      dietaryTags: suggestion.dietaryTags,
      ingredients: suggestion.ingredients
          .map((ai) => Ingredient(
                id: uuid.v4(),
                name: ai.name,
                quantity: ai.quantity,
                unit: ai.unit,
                category: IngredientCategories.pantry,
              ))
          .toList(),
      instructions: suggestion.instructions,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Recipe Suggestions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _response != null ? _buildResults() : _buildInputForm(),
      floatingActionButton: _response != null
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _response = null;
                  _errorMessage = null;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('New Search'),
              backgroundColor: AppTheme.primaryColor,
            )
          : null,
    );
  }

  Widget _buildInputForm() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Available Ingredients', Icons.kitchen),
          const SizedBox(height: 8),
          Text(
            'Add ingredients you have on hand',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ingredientController,
                  decoration: InputDecoration(
                    hintText: 'e.g., chicken, tomatoes',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle, color: AppTheme.primaryColor),
                      onPressed: _addIngredient,
                    ),
                  ),
                  onSubmitted: (_) => _addIngredient(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedIngredients.map((ingredient) {
              return Chip(
                label: Text(ingredient),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeIngredient(ingredient),
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Dietary Restrictions', Icons.restaurant_menu),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              DietaryTags.vegetarian,
              DietaryTags.vegan,
              DietaryTags.glutenFree,
              DietaryTags.dairyFree,
              DietaryTags.nutFree,
            ].map((dietary) {
              final isSelected = _selectedDietary.contains(dietary);
              return FilterChip(
                label: Text(dietary),
                selected: isSelected,
                onSelected: (_) => _toggleDietary(dietary),
                selectedColor: AppTheme.primaryColor,
                checkmarkColor: Colors.white,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Cuisine Preference', Icons.public),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedCuisine,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              'any',
              'italian',
              'asian',
              'mexican',
              'american',
              'indian',
              'french',
              'mediterranean',
              'japanese',
              'chinese',
            ].map((cuisine) {
              return DropdownMenuItem(
                value: cuisine,
                child: Text(cuisine == 'any' ? 'Any Cuisine' : cuisine[0].toUpperCase() + cuisine.substring(1)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCuisine = value);
              }
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Max Cooking Time', Icons.timer),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _maxCookingTime,
                  min: 15,
                  max: 120,
                  divisions: 21,
                  label: '${_maxCookingTime.toInt()} min',
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() => _maxCookingTime = value);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_maxCookingTime.toInt()} min',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _getSuggestions,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                _isLoading ? 'Generating...' : 'Get AI Suggestions',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_response == null) return const SizedBox();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_response!.reasoning.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Reasoning',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _response!.reasoning,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            'Suggested Recipes',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            _response!.suggestions.length,
            (index) => _buildRecipeCard(_response!.suggestions[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(AIRecipeSuggestion suggestion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          final recipe = _convertAISuggestionToRecipe(suggestion);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      suggestion.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.auto_awesome,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                suggestion.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    Icons.restaurant,
                    suggestion.cuisine,
                  ),
                  _buildInfoChip(
                    Icons.timer,
                    '${suggestion.prepTime + suggestion.cookTime} min',
                  ),
                  _buildInfoChip(
                    Icons.people,
                    '${suggestion.servings} servings',
                  ),
                  _buildInfoChip(
                    Icons.bar_chart,
                    suggestion.difficulty,
                  ),
                ],
              ),
              if (suggestion.dietaryTags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: suggestion.dietaryTags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final recipe = _convertAISuggestionToRecipe(suggestion);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Recipe'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
