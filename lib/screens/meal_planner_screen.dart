import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/meal_plan_provider.dart';
import '../providers/recipe_provider.dart';
import '../models/meal_plan_model.dart';
import '../models/recipe_model.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'recipe_detail_screen.dart';
import '../widgets/meal_selection_dialog.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealPlanProvider>().loadWeeklyPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<MealPlanProvider>(
        builder: (context, mealPlanProvider, child) {
          return Column(
            children: [
              _buildHeader(mealPlanProvider),
              _buildDaySelector(mealPlanProvider),
              Expanded(
                child: _buildMealSlots(mealPlanProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(MealPlanProvider mealPlanProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: mealPlanProvider.navigateToPreviousWeek,
          ),
          Expanded(
            child: Center(
              child: Text(
                'Weekly Plan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: mealPlanProvider.navigateToNextWeek,
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector(MealPlanProvider mealPlanProvider) {
    final weekDates = mealPlanProvider.getWeekDates();
    final selectedDate = mealPlanProvider.selectedDate;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: weekDates.map((date) {
            final isSelected = _isSameDay(date, selectedDate);
            final dayName = _getDayName(date.weekday);
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => mealPlanProvider.setSelectedDate(date),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    dayName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.medium,
                      color: isSelected 
                          ? AppTheme.primaryColor 
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMealSlots(MealPlanProvider mealPlanProvider) {
    final selectedDate = mealPlanProvider.selectedDate;
    final meals = mealPlanProvider.getMealsForDate(selectedDate);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getDayName(selectedDate.weekday),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: MealTypes.allTypes.take(3).map((mealType) {
                final mealPlan = meals.firstWhere(
                  (meal) => meal.mealType == mealType,
                  orElse: () => MealPlan(
                    id: '',
                    date: selectedDate,
                    mealType: mealType,
                    recipeId: '',
                  ),
                );
                
                return _buildMealSlot(mealType, mealPlan, mealPlanProvider);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSlot(String mealType, MealPlan mealPlan, MealPlanProvider mealPlanProvider) {
    final hasMeal = mealPlan.id.isNotEmpty;
    
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
                          (r) => r.id == mealPlan.recipeId,
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
                      (r) => r.id == mealPlan.recipeId,
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
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
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
                onPressed: () => _showMealOptions(mealType, mealPlan, mealPlanProvider),
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
                onPressed: () => _addMealToPlan(mealType, mealPlanProvider),
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

  void _addMealToPlan(String mealType, MealPlanProvider mealPlanProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MealSelectionDialog(
        recipe: Recipe(
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
        onMealSelected: (selectedMealType, date, recipeId) {
          mealPlanProvider.addMealToPlan(date, selectedMealType, recipeId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added to $selectedMealType'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  void _showMealOptions(String mealType, MealPlan mealPlan, MealPlanProvider mealPlanProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('View Recipe'),
              onTap: () {
                Navigator.pop(context);
                _viewRecipe(mealPlan.recipeId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove from Plan'),
              onTap: () {
                Navigator.pop(context);
                mealPlanProvider.removeMealFromPlan(mealPlanProvider.selectedDate, mealType);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed from $mealType'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewRecipe(String recipeId) {
    if (recipeId.isNotEmpty) {
      final recipeProvider = context.read<RecipeProvider>();
      final recipe = recipeProvider.recipes.firstWhere(
        (r) => r.id == recipeId,
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
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(recipe: recipe),
        ),
      );
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
