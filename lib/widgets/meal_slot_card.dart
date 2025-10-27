import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal_plan_model.dart';
import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../utils/app_theme.dart';

class MealSlotCard extends StatelessWidget {
  final String mealType;
  final MealPlan? mealPlan;
  final VoidCallback? onAddMeal;
  final VoidCallback? onViewRecipe;
  final VoidCallback? onRemoveMeal;

  const MealSlotCard({
    super.key,
    required this.mealType,
    this.mealPlan,
    this.onAddMeal,
    this.onViewRecipe,
    this.onRemoveMeal,
  });

  @override
  Widget build(BuildContext context) {
    final hasMeal = mealPlan != null && mealPlan!.recipeId.isNotEmpty;
    
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealType.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (hasMeal)
                    Consumer<RecipeProvider>(
                      builder: (context, recipeProvider, child) {
                        final recipe = recipeProvider.recipes.firstWhere(
                          (r) => r.id == mealPlan!.recipeId,
                          orElse: () => Recipe(
                            id: '',
                            name: 'Recipe not found',
                            description: '',
                            prepTime: 0,
                            cookTime: 0,
                            servings: 0,
                            difficulty: '',
                            category: '',
                            dietaryTags: [],
                            ingredients: [],
                            instructions: [],
                            isFavorite: false,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        );
                        
                        return Text(
                          recipe.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    )
                  else
                    Text(
                      'Add a recipe',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            if (hasMeal) ...[
              Expanded(
                flex: 1,
                child: Consumer<RecipeProvider>(
                  builder: (context, recipeProvider, child) {
                    final recipe = recipeProvider.recipes.firstWhere(
                      (r) => r.id == mealPlan!.recipeId,
                      orElse: () => Recipe(
                        id: '',
                        name: '',
                        description: '',
                        prepTime: 0,
                        cookTime: 0,
                        servings: 0,
                        difficulty: '',
                        category: '',
                        dietaryTags: [],
                        ingredients: [],
                        instructions: [],
                        isFavorite: false,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    );
                    
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                      ),
                      child: recipe.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: recipe.imageUrl!,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.restaurant,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.restaurant,
                              color: Colors.grey,
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onViewRecipe,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Details',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.medium,
                  ),
                ),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: onAddMeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.3),
                  foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Add',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
