class AppConstants {
  static const String appName = 'Recipe Meal Planner';
  static const String appVersion = '1.0.0';

  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 12.0;
  static const double borderRadiusXL = 16.0;
  static const double borderRadiusFull = 999.0;

  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 3);
}

class DietaryTags {
  static const String vegetarian = 'vegetarian';
  static const String vegan = 'vegan';
  static const String glutenFree = 'gluten-free';
  static const String dairyFree = 'dairy-free';
  static const String nutFree = 'nut-free';
  static const String keto = 'keto';
  static const String paleo = 'paleo';
  static const String lowCarb = 'low-carb';
  static const String lowFat = 'low-fat';
  static const String highProtein = 'high-protein';
  static const String sugarFree = 'sugar-free';
  static const String halal = 'halal';
  static const String kosher = 'kosher';

  static const List<String> allTags = [
    vegetarian,
    vegan,
    glutenFree,
    dairyFree,
    nutFree,
    keto,
    paleo,
    lowCarb,
    lowFat,
    highProtein,
    sugarFree,
    halal,
    kosher,
  ];
}

class MealTypes {
  static const String breakfast = 'breakfast';
  static const String lunch = 'lunch';
  static const String dinner = 'dinner';
  static const String snack = 'snack';
  static const String dessert = 'dessert';
  static const String appetizer = 'appetizer';
  static const String side = 'side';

  static const List<String> allTypes = [
    breakfast,
    lunch,
    dinner,
    snack,
    dessert,
    appetizer,
    side,
  ];
}

class DifficultyLevels {
  static const String easy = 'easy';
  static const String medium = 'medium';
  static const String hard = 'hard';

  static const List<String> allLevels = [
    easy,
    medium,
    hard,
  ];
}

class IngredientCategories {
  static const String produce = 'produce';
  static const String dairy = 'dairy';
  static const String meat = 'meat';
  static const String seafood = 'seafood';
  static const String pantry = 'pantry';
  static const String spices = 'spices';
  static const String baking = 'baking';
  static const String frozen = 'frozen';
  static const String canned = 'canned';
  static const String beverages = 'beverages';
  static const String condiments = 'condiments';
  static const String grains = 'grains';
  static const String nuts = 'nuts';
  static const String oils = 'oils';

  static const List<String> allCategories = [
    produce,
    dairy,
    meat,
    seafood,
    pantry,
    spices,
    baking,
    frozen,
    canned,
    beverages,
    condiments,
    grains,
    nuts,
    oils,
  ];
}

class RecipeCategories {
  static const String italian = 'italian';
  static const String asian = 'asian';
  static const String mexican = 'mexican';
  static const String american = 'american';
  static const String mediterranean = 'mediterranean';
  static const String indian = 'indian';
  static const String chinese = 'chinese';
  static const String japanese = 'japanese';
  static const String thai = 'thai';
  static const String french = 'french';
  static const String comfort = 'comfort';
  static const String healthy = 'healthy';
  static const String quick = 'quick';
  static const String dessert = 'dessert';

  static const List<String> allCategories = [
    italian,
    asian,
    mexican,
    american,
    mediterranean,
    indian,
    chinese,
    japanese,
    thai,
    french,
    comfort,
    healthy,
    quick,
    dessert,
  ];
}

class SampleRecipes {
  static const List<Map<String, dynamic>> recipes = [
    {
      'id': 'recipe_001',
      'name': 'Classic Lasagna',
      'description': 'A hearty Italian classic with layers of pasta, meat sauce, and cheese.',
      'imageUrl': 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=500',
      'prepTime': 30,
      'cookTime': 45,
      'servings': 8,
      'difficulty': DifficultyLevels.medium,
      'category': RecipeCategories.italian,
      'dietaryTags': [DietaryTags.meat],
      'ingredients': [
        {'name': 'Lasagna noodles', 'quantity': '12', 'unit': 'sheets', 'category': IngredientCategories.pantry},
        {'name': 'Ground beef', 'quantity': '1', 'unit': 'lb', 'category': IngredientCategories.meat},
        {'name': 'Ricotta cheese', 'quantity': '15', 'unit': 'oz', 'category': IngredientCategories.dairy},
        {'name': 'Mozzarella cheese', 'quantity': '2', 'unit': 'cups', 'category': IngredientCategories.dairy},
        {'name': 'Parmesan cheese', 'quantity': '1/2', 'unit': 'cup', 'category': IngredientCategories.dairy},
        {'name': 'Tomato sauce', 'quantity': '24', 'unit': 'oz', 'category': IngredientCategories.canned},
        {'name': 'Onion', 'quantity': '1', 'unit': 'medium', 'category': IngredientCategories.produce},
        {'name': 'Garlic', 'quantity': '3', 'unit': 'cloves', 'category': IngredientCategories.produce},
        {'name': 'Egg', 'quantity': '1', 'unit': 'large', 'category': IngredientCategories.dairy},
        {'name': 'Basil', 'quantity': '2', 'unit': 'tbsp', 'category': IngredientCategories.spices},
      ],
      'instructions': [
        'Preheat oven to 375°F (190°C).',
        'Cook lasagna noodles according to package directions.',
        'Brown ground beef with chopped onion and garlic.',
        'Mix ricotta cheese with egg and basil.',
        'Layer noodles, meat sauce, ricotta mixture, and mozzarella.',
        'Repeat layers and top with Parmesan cheese.',
        'Bake for 45 minutes until bubbly and golden.',
      ],
    },
    {
      'id': 'recipe_002',
      'name': 'Spicy Thai Green Curry',
      'description': 'Aromatic Thai curry with vegetables and coconut milk.',
      'imageUrl': 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=500',
      'prepTime': 15,
      'cookTime': 25,
      'servings': 4,
      'difficulty': DifficultyLevels.medium,
      'category': RecipeCategories.thai,
      'dietaryTags': [DietaryTags.vegetarian, DietaryTags.glutenFree],
      'ingredients': [
        {'name': 'Green curry paste', 'quantity': '3', 'unit': 'tbsp', 'category': IngredientCategories.condiments},
        {'name': 'Coconut milk', 'quantity': '14', 'unit': 'oz', 'category': IngredientCategories.canned},
        {'name': 'Bell peppers', 'quantity': '2', 'unit': 'medium', 'category': IngredientCategories.produce},
        {'name': 'Eggplant', 'quantity': '1', 'unit': 'medium', 'category': IngredientCategories.produce},
        {'name': 'Bamboo shoots', 'quantity': '8', 'unit': 'oz', 'category': IngredientCategories.canned},
        {'name': 'Thai basil', 'quantity': '1/2', 'unit': 'cup', 'category': IngredientCategories.produce},
        {'name': 'Fish sauce', 'quantity': '2', 'unit': 'tbsp', 'category': IngredientCategories.condiments},
        {'name': 'Brown sugar', 'quantity': '1', 'unit': 'tbsp', 'category': IngredientCategories.pantry},
        {'name': 'Jasmine rice', 'quantity': '2', 'unit': 'cups', 'category': IngredientCategories.grains},
      ],
      'instructions': [
        'Cook jasmine rice according to package directions.',
        'Heat coconut milk in a large pot over medium heat.',
        'Add green curry paste and stir until fragrant.',
        'Add vegetables and cook until tender.',
        'Season with fish sauce and brown sugar.',
        'Garnish with Thai basil and serve over rice.',
      ],
    },
    {
      'id': 'recipe_003',
      'name': 'Fluffy Blueberry Pancakes',
      'description': 'Light and fluffy pancakes bursting with fresh blueberries.',
      'imageUrl': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=500',
      'prepTime': 10,
      'cookTime': 15,
      'servings': 4,
      'difficulty': DifficultyLevels.easy,
      'category': RecipeCategories.american,
      'dietaryTags': [DietaryTags.vegetarian],
      'ingredients': [
        {'name': 'All-purpose flour', 'quantity': '1', 'unit': 'cup', 'category': IngredientCategories.baking},
        {'name': 'Sugar', 'quantity': '2', 'unit': 'tbsp', 'category': IngredientCategories.baking},
        {'name': 'Baking powder', 'quantity': '2', 'unit': 'tsp', 'category': IngredientCategories.baking},
        {'name': 'Salt', 'quantity': '1/2', 'unit': 'tsp', 'category': IngredientCategories.spices},
        {'name': 'Milk', 'quantity': '1', 'unit': 'cup', 'category': IngredientCategories.dairy},
        {'name': 'Egg', 'quantity': '1', 'unit': 'large', 'category': IngredientCategories.dairy},
        {'name': 'Butter', 'quantity': '2', 'unit': 'tbsp', 'category': IngredientCategories.dairy},
        {'name': 'Blueberries', 'quantity': '1', 'unit': 'cup', 'category': IngredientCategories.produce},
        {'name': 'Maple syrup', 'quantity': '1/4', 'unit': 'cup', 'category': IngredientCategories.condiments},
      ],
      'instructions': [
        'Mix dry ingredients in a large bowl.',
        'Whisk wet ingredients in a separate bowl.',
        'Combine wet and dry ingredients until just mixed.',
        'Gently fold in blueberries.',
        'Cook pancakes on a griddle until golden.',
        'Serve with maple syrup.',
      ],
    },
    {
      'id': 'recipe_004',
      'name': 'Avocado Toast with Egg',
      'description': 'Simple and nutritious breakfast with creamy avocado and perfectly cooked egg.',
      'imageUrl': 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=500',
      'prepTime': 5,
      'cookTime': 5,
      'servings': 2,
      'difficulty': DifficultyLevels.easy,
      'category': RecipeCategories.healthy,
      'dietaryTags': [DietaryTags.vegetarian, DietaryTags.glutenFree],
      'ingredients': [
        {'name': 'Sourdough bread', 'quantity': '2', 'unit': 'slices', 'category': IngredientCategories.pantry},
        {'name': 'Avocado', 'quantity': '1', 'unit': 'ripe', 'category': IngredientCategories.produce},
        {'name': 'Eggs', 'quantity': '2', 'unit': 'large', 'category': IngredientCategories.dairy},
        {'name': 'Lemon juice', 'quantity': '1', 'unit': 'tbsp', 'category': IngredientCategories.produce},
        {'name': 'Salt', 'quantity': '1/4', 'unit': 'tsp', 'category': IngredientCategories.spices},
        {'name': 'Black pepper', 'quantity': '1/4', 'unit': 'tsp', 'category': IngredientCategories.spices},
        {'name': 'Red pepper flakes', 'quantity': '1', 'unit': 'pinch', 'category': IngredientCategories.spices},
      ],
      'instructions': [
        'Toast bread slices until golden.',
        'Mash avocado with lemon juice, salt, and pepper.',
        'Cook eggs sunny-side up or poached.',
        'Spread avocado mixture on toast.',
        'Top with cooked egg and red pepper flakes.',
        'Serve immediately.',
      ],
    },
    {
      'id': 'recipe_005',
      'name': 'Chicken Caesar Salad',
      'description': 'Classic Caesar salad with grilled chicken and homemade dressing.',
      'imageUrl': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=500',
      'prepTime': 20,
      'cookTime': 15,
      'servings': 4,
      'difficulty': DifficultyLevels.easy,
      'category': RecipeCategories.american,
      'dietaryTags': [DietaryTags.meat, DietaryTags.glutenFree],
      'ingredients': [
        {'name': 'Chicken breast', 'quantity': '2', 'unit': 'lbs', 'category': IngredientCategories.meat},
        {'name': 'Romaine lettuce', 'quantity': '2', 'unit': 'heads', 'category': IngredientCategories.produce},
        {'name': 'Parmesan cheese', 'quantity': '1/2', 'unit': 'cup', 'category': IngredientCategories.dairy},
        {'name': 'Croutons', 'quantity': '1', 'unit': 'cup', 'category': IngredientCategories.pantry},
        {'name': 'Anchovy fillets', 'quantity': '3', 'unit': 'pieces', 'category': IngredientCategories.canned},
        {'name': 'Garlic', 'quantity': '2', 'unit': 'cloves', 'category': IngredientCategories.produce},
        {'name': 'Dijon mustard', 'quantity': '1', 'unit': 'tsp', 'category': IngredientCategories.condiments},
        {'name': 'Worcestershire sauce', 'quantity': '1', 'unit': 'tsp', 'category': IngredientCategories.condiments},
        {'name': 'Lemon juice', 'quantity': '2', 'unit': 'tbsp', 'category': IngredientCategories.produce},
        {'name': 'Olive oil', 'quantity': '1/2', 'unit': 'cup', 'category': IngredientCategories.oils},
      ],
      'instructions': [
        'Season and grill chicken breast until cooked through.',
        'Make Caesar dressing with anchovies, garlic, mustard, and lemon.',
        'Toss lettuce with dressing and Parmesan cheese.',
        'Slice chicken and arrange on salad.',
        'Top with croutons and additional Parmesan.',
        'Serve immediately.',
      ],
    },
    {
      'id': 'recipe_006',
      'name': 'Chocolate Chip Cookies',
      'description': 'Soft and chewy chocolate chip cookies that are perfect for any occasion.',
      'imageUrl': 'https://images.unsplash.com/photo-1499636136210-6f4ee6a84529?w=500',
      'prepTime': 15,
      'cookTime': 12,
      'servings': 24,
      'difficulty': DifficultyLevels.easy,
      'category': RecipeCategories.dessert,
      'dietaryTags': [DietaryTags.vegetarian],
      'ingredients': [
        {'name': 'All-purpose flour', 'quantity': '2', 'unit': 'cups', 'category': IngredientCategories.baking},
        {'name': 'Baking soda', 'quantity': '1', 'unit': 'tsp', 'category': IngredientCategories.baking},
        {'name': 'Salt', 'quantity': '1', 'unit': 'tsp', 'category': IngredientCategories.spices},
        {'name': 'Butter', 'quantity': '1', 'unit': 'cup', 'category': IngredientCategories.dairy},
        {'name': 'Brown sugar', 'quantity': '3/4', 'unit': 'cup', 'category': IngredientCategories.baking},
        {'name': 'White sugar', 'quantity': '1/2', 'unit': 'cup', 'category': IngredientCategories.baking},
        {'name': 'Eggs', 'quantity': '2', 'unit': 'large', 'category': IngredientCategories.dairy},
        {'name': 'Vanilla extract', 'quantity': '2', 'unit': 'tsp', 'category': IngredientCategories.baking},
        {'name': 'Chocolate chips', 'quantity': '2', 'unit': 'cups', 'category': IngredientCategories.baking},
      ],
      'instructions': [
        'Preheat oven to 375°F (190°C).',
        'Mix flour, baking soda, and salt in a bowl.',
        'Cream butter and sugars until fluffy.',
        'Beat in eggs and vanilla extract.',
        'Gradually mix in flour mixture.',
        'Fold in chocolate chips.',
        'Drop rounded tablespoons onto baking sheets.',
        'Bake for 9-11 minutes until golden.',
      ],
    },
    {
      'id': 'recipe_007',
      'name': 'Beef Stir Fry',
      'description': 'Quick and flavorful beef stir fry with vegetables and savory sauce.',
      'imageUrl': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500',
      'prepTime': 20,
      'cookTime': 10,
      'servings': 4,
      'difficulty': DifficultyLevels.easy,
      'category': RecipeCategories.asian,
      'dietaryTags': [DietaryTags.meat, DietaryTags.glutenFree],
      'ingredients': [
        {'name': 'Beef sirloin', 'quantity': '1', 'unit': 'lb', 'category': IngredientCategories.meat},
        {'name': 'Broccoli', 'quantity': '2', 'unit': 'cups', 'category': IngredientCategories.produce},
        {'name': 'Bell peppers', 'quantity': '2', 'unit': 'medium', 'category': IngredientCategories.produce},
        {'name': 'Carrots', 'quantity': '2', 'unit': 'medium', 'category': IngredientCategories.produce},
        {'name': 'Garlic', 'quantity': '3', 'unit': 'cloves', 'category': IngredientCategories.produce},
        {'name': 'Ginger', 'quantity': '1', 'unit': 'tbsp', 'category': IngredientCategories.produce},
        {'name': 'Soy sauce', 'quantity': '3', 'unit': 'tbsp', 'category': IngredientCategories.condiments},
        {'name': 'Sesame oil', 'quantity': '1', 'unit': 'tbsp', 'category': IngredientCategories.oils},
        {'name': 'Cornstarch', 'quantity': '1', 'unit': 'tbsp', 'category': IngredientCategories.baking},
        {'name': 'Rice', 'quantity': '2', 'unit': 'cups', 'category': IngredientCategories.grains},
      ],
      'instructions': [
        'Slice beef thinly against the grain.',
        'Cut vegetables into bite-sized pieces.',
        'Mix soy sauce, sesame oil, and cornstarch for sauce.',
        'Stir-fry beef until browned, then remove.',
        'Cook vegetables until crisp-tender.',
        'Return beef to pan and add sauce.',
        'Serve over steamed rice.',
      ],
    },
    {
      'id': 'recipe_008',
      'name': 'Mediterranean Quinoa Bowl',
      'description': 'Nutritious quinoa bowl with Mediterranean flavors and fresh vegetables.',
      'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500',
      'prepTime': 15,
      'cookTime': 20,
      'servings': 4,
      'difficulty': DifficultyLevels.easy,
      'category': RecipeCategories.mediterranean,
      'dietaryTags': [DietaryTags.vegetarian, DietaryTags.vegan, DietaryTags.glutenFree],
      'ingredients': [
        {'name': 'Quinoa', 'quantity': '1', 'unit': 'cup', 'category': IngredientCategories.grains},
        {'name': 'Cherry tomatoes', 'quantity': '1', 'unit': 'cup', 'category': IngredientCategories.produce},
        {'name': 'Cucumber', 'quantity': '1', 'unit': 'medium', 'category': IngredientCategories.produce},
        {'name': 'Red onion', 'quantity': '1/2', 'unit': 'medium', 'category': IngredientCategories.produce},
        {'name': 'Kalamata olives', 'quantity': '1/2', 'unit': 'cup', 'category': IngredientCategories.canned},
        {'name': 'Feta cheese', 'quantity': '4', 'unit': 'oz', 'category': IngredientCategories.dairy},
        {'name': 'Olive oil', 'quantity': '3', 'unit': 'tbsp', 'category': IngredientCategories.oils},
        {'name': 'Lemon juice', 'quantity': '2', 'unit': 'tbsp', 'category': IngredientCategories.produce},
        {'name': 'Fresh herbs', 'quantity': '1/4', 'unit': 'cup', 'category': IngredientCategories.produce},
      ],
      'instructions': [
        'Cook quinoa according to package directions.',
        'Chop vegetables into bite-sized pieces.',
        'Make dressing with olive oil and lemon juice.',
        'Combine quinoa with vegetables and olives.',
        'Toss with dressing and fresh herbs.',
        'Top with crumbled feta cheese.',
        'Serve at room temperature.',
      ],
    },
    {
      'id': 'recipe_009',
      'name': 'Fish Tacos',
      'description': 'Fresh fish tacos with cabbage slaw and creamy sauce.',
      'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500',
      'prepTime': 25,
      'cookTime': 10,
      'servings': 6,
      'difficulty': DifficultyLevels.medium,
      'category': RecipeCategories.mexican,
      'dietaryTags': [DietaryTags.seafood, DietaryTags.glutenFree],
      'ingredients': [
        {'name': 'White fish fillets', 'quantity': '1', 'unit': 'lb', 'category': IngredientCategories.seafood},
        {'name': 'Corn tortillas', 'quantity': '12', 'unit': 'small', 'category': IngredientCategories.grains},
        {'name': 'Cabbage', 'quantity': '2', 'unit': 'cups', 'category': IngredientCategories.produce},
        {'name': 'Lime', 'quantity': '2', 'unit': 'medium', 'category': IngredientCategories.produce},
        {'name': 'Cilantro', 'quantity': '1/2', 'unit': 'cup', 'category': IngredientCategories.produce},
        {'name': 'Sour cream', 'quantity': '1/2', 'unit': 'cup', 'category': IngredientCategories.dairy},
        {'name': 'Cumin', 'quantity': '1', 'unit': 'tsp', 'category': IngredientCategories.spices},
        {'name': 'Paprika', 'quantity': '1', 'unit': 'tsp', 'category': IngredientCategories.spices},
        {'name': 'Avocado', 'quantity': '1', 'unit': 'medium', 'category': IngredientCategories.produce},
      ],
      'instructions': [
        'Season fish with cumin, paprika, salt, and pepper.',
        'Cook fish until flaky and golden.',
        'Make slaw with cabbage, lime juice, and cilantro.',
        'Mix sour cream with lime juice for sauce.',
        'Warm tortillas and assemble tacos.',
        'Top with fish, slaw, and avocado.',
        'Serve with lime wedges.',
      ],
    },
    {
      'id': 'recipe_010',
      'name': 'Vegetarian Chili',
      'description': 'Hearty vegetarian chili with beans, vegetables, and warming spices.',
      'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=500',
      'prepTime': 20,
      'cookTime': 45,
      'servings': 6,
      'difficulty': DifficultyLevels.easy,
      'category': RecipeCategories.american,
      'dietaryTags': [DietaryTags.vegetarian, DietaryTags.vegan, DietaryTags.glutenFree],
      'ingredients': [
        {'name': 'Black beans', 'quantity': '2', 'unit': 'cans', 'category': IngredientCategories.canned},
        {'name': 'Kidney beans', 'quantity': '1', 'unit': 'can', 'category': IngredientCategories.canned},
        {'name': 'Diced tomatoes', 'quantity': '28', 'unit': 'oz', 'category': IngredientCategories.canned},
        {'name': 'Onion', 'quantity': '1', 'unit': 'large', 'category': IngredientCategories.produce},
        {'name': 'Bell peppers', 'quantity': '2', 'unit': 'medium', 'category': IngredientCategories.produce},
        {'name': 'Garlic', 'quantity': '4', 'unit': 'cloves', 'category': IngredientCategories.produce},
        {'name': 'Chili powder', 'quantity': '2', 'unit': 'tbsp', 'category': IngredientCategories.spices},
        {'name': 'Cumin', 'quantity': '1', 'unit': 'tbsp', 'category': IngredientCategories.spices},
        {'name': 'Vegetable broth', 'quantity': '2', 'unit': 'cups', 'category': IngredientCategories.beverages},
      ],
      'instructions': [
        'Sauté onions and peppers until softened.',
        'Add garlic and spices, cook until fragrant.',
        'Add beans, tomatoes, and vegetable broth.',
        'Simmer for 30-45 minutes until thickened.',
        'Season with salt and pepper to taste.',
        'Serve with toppings like cheese and sour cream.',
      ],
    },
  ];
}
