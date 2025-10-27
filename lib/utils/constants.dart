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
    // BREAKFAST RECIPES
    {
      'id': 'recipe_001',
      'name': 'Classic Pancakes',
      'description': 'Fluffy, golden pancakes perfect for a weekend breakfast.',
      'imageUrl': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=500',
      'prepTime': 10,
      'cookTime': 15,
      'servings': 4,
      'difficulty': 'easy',
      'category': 'american',
      'dietaryTags': ['vegetarian'],
      'ingredients': [
        {'name': 'All-purpose flour', 'quantity': '1', 'unit': 'cup', 'category': 'baking'},
        {'name': 'Sugar', 'quantity': '2', 'unit': 'tbsp', 'category': 'baking'},
        {'name': 'Baking powder', 'quantity': '2', 'unit': 'tsp', 'category': 'baking'},
        {'name': 'Salt', 'quantity': '1/2', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Milk', 'quantity': '1', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Egg', 'quantity': '1', 'unit': 'large', 'category': 'dairy'},
        {'name': 'Butter', 'quantity': '2', 'unit': 'tbsp', 'category': 'dairy'},
        {'name': 'Maple syrup', 'quantity': '1/4', 'unit': 'cup', 'category': 'condiments'},
      ],
      'instructions': [
        'Mix dry ingredients in a large bowl.',
        'Whisk wet ingredients in a separate bowl.',
        'Combine wet and dry ingredients until just mixed.',
        'Cook pancakes on a griddle until golden.',
        'Serve with maple syrup and butter.',
      ],
    },
    {
      'id': 'recipe_002',
      'name': 'Avocado Toast with Egg',
      'description': 'Simple and nutritious breakfast with creamy avocado and perfectly cooked egg.',
      'imageUrl': 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=500',
      'prepTime': 5,
      'cookTime': 5,
      'servings': 2,
      'difficulty': 'easy',
      'category': 'healthy',
      'dietaryTags': ['vegetarian', 'gluten-free'],
      'ingredients': [
        {'name': 'Sourdough bread', 'quantity': '2', 'unit': 'slices', 'category': 'pantry'},
        {'name': 'Avocado', 'quantity': '1', 'unit': 'ripe', 'category': 'produce'},
        {'name': 'Eggs', 'quantity': '2', 'unit': 'large', 'category': 'dairy'},
        {'name': 'Lemon juice', 'quantity': '1', 'unit': 'tbsp', 'category': 'produce'},
        {'name': 'Salt', 'quantity': '1/4', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Black pepper', 'quantity': '1/4', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Red pepper flakes', 'quantity': '1', 'unit': 'pinch', 'category': 'spices'},
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
      'id': 'recipe_003',
      'name': 'Greek Yogurt Parfait',
      'description': 'Layered parfait with Greek yogurt, berries, and granola.',
      'imageUrl': 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=500',
      'prepTime': 10,
      'cookTime': 0,
      'servings': 2,
      'difficulty': 'easy',
      'category': 'healthy',
      'dietaryTags': ['vegetarian', 'gluten-free'],
      'ingredients': [
        {'name': 'Greek yogurt', 'quantity': '1', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Mixed berries', 'quantity': '1', 'unit': 'cup', 'category': 'produce'},
        {'name': 'Granola', 'quantity': '1/2', 'unit': 'cup', 'category': 'pantry'},
        {'name': 'Honey', 'quantity': '2', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Chia seeds', 'quantity': '1', 'unit': 'tbsp', 'category': 'nuts'},
      ],
      'instructions': [
        'Layer half the yogurt in glasses.',
        'Add half the berries and granola.',
        'Repeat layers.',
        'Drizzle with honey and sprinkle chia seeds.',
        'Serve immediately.',
      ],
    },
    {
      'id': 'recipe_004',
      'name': 'French Toast',
      'description': 'Classic French toast with cinnamon and vanilla.',
      'imageUrl': 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=500',
      'prepTime': 10,
      'cookTime': 15,
      'servings': 4,
      'difficulty': 'easy',
      'category': 'american',
      'dietaryTags': ['vegetarian'],
      'ingredients': [
        {'name': 'Bread slices', 'quantity': '8', 'unit': 'thick', 'category': 'pantry'},
        {'name': 'Eggs', 'quantity': '4', 'unit': 'large', 'category': 'dairy'},
        {'name': 'Milk', 'quantity': '1', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Vanilla extract', 'quantity': '1', 'unit': 'tsp', 'category': 'baking'},
        {'name': 'Cinnamon', 'quantity': '1', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Butter', 'quantity': '2', 'unit': 'tbsp', 'category': 'dairy'},
        {'name': 'Maple syrup', 'quantity': '1/4', 'unit': 'cup', 'category': 'condiments'},
      ],
      'instructions': [
        'Whisk eggs, milk, vanilla, and cinnamon.',
        'Dip bread slices in egg mixture.',
        'Cook in buttered pan until golden.',
        'Flip and cook other side.',
        'Serve with maple syrup.',
      ],
    },

    // LUNCH RECIPES
    {
      'id': 'recipe_005',
      'name': 'Chicken Caesar Salad',
      'description': 'Classic Caesar salad with grilled chicken and homemade dressing.',
      'imageUrl': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=500',
      'prepTime': 20,
      'cookTime': 15,
      'servings': 4,
      'difficulty': 'easy',
      'category': 'american',
      'dietaryTags': [DietaryTags.meat, 'gluten-free'],
      'ingredients': [
        {'name': 'Chicken breast', 'quantity': '2', 'unit': 'lbs', 'category': 'meat'},
        {'name': 'Romaine lettuce', 'quantity': '2', 'unit': 'heads', 'category': 'produce'},
        {'name': 'Parmesan cheese', 'quantity': '1/2', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Croutons', 'quantity': '1', 'unit': 'cup', 'category': 'pantry'},
        {'name': 'Anchovy fillets', 'quantity': '3', 'unit': 'pieces', 'category': 'canned'},
        {'name': 'Garlic', 'quantity': '2', 'unit': 'cloves', 'category': 'produce'},
        {'name': 'Dijon mustard', 'quantity': '1', 'unit': 'tsp', 'category': 'condiments'},
        {'name': 'Lemon juice', 'quantity': '2', 'unit': 'tbsp', 'category': 'produce'},
        {'name': 'Olive oil', 'quantity': '1/2', 'unit': 'cup', 'category': 'oils'},
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
      'name': 'Mediterranean Quinoa Bowl',
      'description': 'Nutritious quinoa bowl with Mediterranean flavors and fresh vegetables.',
      'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500',
      'prepTime': 15,
      'cookTime': 20,
      'servings': 4,
      'difficulty': 'easy',
      'category': 'mediterranean',
      'dietaryTags': ['vegetarian', 'vegan', 'gluten-free'],
      'ingredients': [
        {'name': 'Quinoa', 'quantity': '1', 'unit': 'cup', 'category': 'grains'},
        {'name': 'Cherry tomatoes', 'quantity': '1', 'unit': 'cup', 'category': 'produce'},
        {'name': 'Cucumber', 'quantity': '1', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Red onion', 'quantity': '1/2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Kalamata olives', 'quantity': '1/2', 'unit': 'cup', 'category': 'canned'},
        {'name': 'Feta cheese', 'quantity': '4', 'unit': 'oz', 'category': 'dairy'},
        {'name': 'Olive oil', 'quantity': '3', 'unit': 'tbsp', 'category': 'oils'},
        {'name': 'Lemon juice', 'quantity': '2', 'unit': 'tbsp', 'category': 'produce'},
        {'name': 'Fresh herbs', 'quantity': '1/4', 'unit': 'cup', 'category': 'produce'},
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
      'id': 'recipe_007',
      'name': 'Turkey Club Sandwich',
      'description': 'Classic triple-decker sandwich with turkey, bacon, and avocado.',
      'imageUrl': 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=500',
      'prepTime': 15,
      'cookTime': 10,
      'servings': 2,
      'difficulty': 'easy',
      'category': 'american',
      'dietaryTags': ['meat'],
      'ingredients': [
        {'name': 'Bread slices', 'quantity': '6', 'unit': 'slices', 'category': 'pantry'},
        {'name': 'Turkey breast', 'quantity': '8', 'unit': 'oz', 'category': 'meat'},
        {'name': 'Bacon', 'quantity': '4', 'unit': 'strips', 'category': 'meat'},
        {'name': 'Avocado', 'quantity': '1', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Tomato', 'quantity': '1', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Lettuce', 'quantity': '4', 'unit': 'leaves', 'category': 'produce'},
        {'name': 'Mayonnaise', 'quantity': '2', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Salt', 'quantity': '1/4', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Black pepper', 'quantity': '1/4', 'unit': 'tsp', 'category': 'spices'},
      ],
      'instructions': [
        'Cook bacon until crispy.',
        'Toast bread slices.',
        'Spread mayonnaise on bread.',
        'Layer turkey, bacon, avocado, tomato, and lettuce.',
        'Season with salt and pepper.',
        'Cut diagonally and serve.',
      ],
    },

    // DINNER RECIPES
    {
      'id': 'recipe_008',
      'name': 'Classic Lasagna',
      'description': 'A hearty Italian classic with layers of pasta, meat sauce, and cheese.',
      'imageUrl': 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=500',
      'prepTime': 30,
      'cookTime': 45,
      'servings': 8,
      'difficulty': 'medium',
      'category': 'italian',
      'dietaryTags': ['meat'],
      'ingredients': [
        {'name': 'Lasagna noodles', 'quantity': '12', 'unit': 'sheets', 'category': 'pantry'},
        {'name': 'Ground beef', 'quantity': '1', 'unit': 'lb', 'category': 'meat'},
        {'name': 'Ricotta cheese', 'quantity': '15', 'unit': 'oz', 'category': 'dairy'},
        {'name': 'Mozzarella cheese', 'quantity': '2', 'unit': 'cups', 'category': 'dairy'},
        {'name': 'Parmesan cheese', 'quantity': '1/2', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Tomato sauce', 'quantity': '24', 'unit': 'oz', 'category': 'canned'},
        {'name': 'Onion', 'quantity': '1', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Garlic', 'quantity': '3', 'unit': 'cloves', 'category': 'produce'},
        {'name': 'Egg', 'quantity': '1', 'unit': 'large', 'category': 'dairy'},
        {'name': 'Basil', 'quantity': '2', 'unit': 'tbsp', 'category': 'spices'},
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
      'id': 'recipe_009',
      'name': 'Spicy Thai Green Curry',
      'description': 'Aromatic Thai curry with vegetables and coconut milk.',
      'imageUrl': 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=500',
      'prepTime': 15,
      'cookTime': 25,
      'servings': 4,
      'difficulty': 'medium',
      'category': 'thai',
      'dietaryTags': ['vegetarian', 'gluten-free'],
      'ingredients': [
        {'name': 'Green curry paste', 'quantity': '3', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Coconut milk', 'quantity': '14', 'unit': 'oz', 'category': 'canned'},
        {'name': 'Bell peppers', 'quantity': '2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Eggplant', 'quantity': '1', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Bamboo shoots', 'quantity': '8', 'unit': 'oz', 'category': 'canned'},
        {'name': 'Thai basil', 'quantity': '1/2', 'unit': 'cup', 'category': 'produce'},
        {'name': 'Fish sauce', 'quantity': '2', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Brown sugar', 'quantity': '1', 'unit': 'tbsp', 'category': 'pantry'},
        {'name': 'Jasmine rice', 'quantity': '2', 'unit': 'cups', 'category': 'grains'},
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
      'id': 'recipe_010',
      'name': 'Beef Stir Fry',
      'description': 'Quick and flavorful beef stir fry with vegetables and savory sauce.',
      'imageUrl': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500',
      'prepTime': 20,
      'cookTime': 10,
      'servings': 4,
      'difficulty': 'easy',
      'category': 'asian',
      'dietaryTags': [DietaryTags.meat, 'gluten-free'],
      'ingredients': [
        {'name': 'Beef sirloin', 'quantity': '1', 'unit': 'lb', 'category': 'meat'},
        {'name': 'Broccoli', 'quantity': '2', 'unit': 'cups', 'category': 'produce'},
        {'name': 'Bell peppers', 'quantity': '2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Carrots', 'quantity': '2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Garlic', 'quantity': '3', 'unit': 'cloves', 'category': 'produce'},
        {'name': 'Ginger', 'quantity': '1', 'unit': 'tbsp', 'category': 'produce'},
        {'name': 'Soy sauce', 'quantity': '3', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Sesame oil', 'quantity': '1', 'unit': 'tbsp', 'category': 'oils'},
        {'name': 'Cornstarch', 'quantity': '1', 'unit': 'tbsp', 'category': 'baking'},
        {'name': 'Rice', 'quantity': '2', 'unit': 'cups', 'category': 'grains'},
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
      'id': 'recipe_011',
      'name': 'Fish Tacos',
      'description': 'Fresh fish tacos with cabbage slaw and creamy sauce.',
      'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500',
      'prepTime': 25,
      'cookTime': 10,
      'servings': 6,
      'difficulty': 'medium',
      'category': 'mexican',
      'dietaryTags': ['seafood', 'gluten-free'],
      'ingredients': [
        {'name': 'White fish fillets', 'quantity': '1', 'unit': 'lb', 'category': 'seafood'},
        {'name': 'Corn tortillas', 'quantity': '12', 'unit': 'small', 'category': 'grains'},
        {'name': 'Cabbage', 'quantity': '2', 'unit': 'cups', 'category': 'produce'},
        {'name': 'Lime', 'quantity': '2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Cilantro', 'quantity': '1/2', 'unit': 'cup', 'category': 'produce'},
        {'name': 'Sour cream', 'quantity': '1/2', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Cumin', 'quantity': '1', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Paprika', 'quantity': '1', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Avocado', 'quantity': '1', 'unit': 'medium', 'category': 'produce'},
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
      'id': 'recipe_012',
      'name': 'Vegetarian Chili',
      'description': 'Hearty vegetarian chili with beans, vegetables, and warming spices.',
      'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=500',
      'prepTime': 20,
      'cookTime': 45,
      'servings': 6,
      'difficulty': 'easy',
      'category': 'american',
      'dietaryTags': ['vegetarian', 'vegan', 'gluten-free'],
      'ingredients': [
        {'name': 'Black beans', 'quantity': '2', 'unit': 'cans', 'category': 'canned'},
        {'name': 'Kidney beans', 'quantity': '1', 'unit': 'can', 'category': 'canned'},
        {'name': 'Diced tomatoes', 'quantity': '28', 'unit': 'oz', 'category': 'canned'},
        {'name': 'Onion', 'quantity': '1', 'unit': 'large', 'category': 'produce'},
        {'name': 'Bell peppers', 'quantity': '2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Garlic', 'quantity': '4', 'unit': 'cloves', 'category': 'produce'},
        {'name': 'Chili powder', 'quantity': '2', 'unit': 'tbsp', 'category': 'spices'},
        {'name': 'Cumin', 'quantity': '1', 'unit': 'tbsp', 'category': 'spices'},
        {'name': 'Vegetable broth', 'quantity': '2', 'unit': 'cups', 'category': 'beverages'},
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
    {
      'id': 'recipe_013',
      'name': 'Chicken Parmesan',
      'description': 'Crispy breaded chicken topped with marinara sauce and melted cheese.',
      'imageUrl': 'https://images.unsplash.com/photo-1562967914-608f82629710?w=500',
      'prepTime': 25,
      'cookTime': 30,
      'servings': 4,
      'difficulty': 'medium',
      'category': 'italian',
      'dietaryTags': ['meat'],
      'ingredients': [
        {'name': 'Chicken breasts', 'quantity': '4', 'unit': 'large', 'category': 'meat'},
        {'name': 'Breadcrumbs', 'quantity': '1', 'unit': 'cup', 'category': 'pantry'},
        {'name': 'Parmesan cheese', 'quantity': '1/2', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Eggs', 'quantity': '2', 'unit': 'large', 'category': 'dairy'},
        {'name': 'Marinara sauce', 'quantity': '2', 'unit': 'cups', 'category': 'canned'},
        {'name': 'Mozzarella cheese', 'quantity': '1', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Flour', 'quantity': '1/2', 'unit': 'cup', 'category': 'baking'},
        {'name': 'Olive oil', 'quantity': '1/4', 'unit': 'cup', 'category': 'oils'},
        {'name': 'Basil', 'quantity': '2', 'unit': 'tbsp', 'category': 'spices'},
      ],
      'instructions': [
        'Preheat oven to 400°F (200°C).',
        'Pound chicken breasts to even thickness.',
        'Dredge in flour, egg, then breadcrumb mixture.',
        'Pan-fry until golden brown.',
        'Top with marinara sauce and mozzarella.',
        'Bake until cheese is melted and bubbly.',
        'Garnish with fresh basil.',
      ],
    },

    // SNACKS & DESSERTS
    {
      'id': 'recipe_014',
      'name': 'Chocolate Chip Cookies',
      'description': 'Soft and chewy chocolate chip cookies that are perfect for any occasion.',
      'imageUrl': 'https://images.unsplash.com/photo-1499636136210-6f4ee6a84529?w=500',
      'prepTime': 15,
      'cookTime': 12,
      'servings': 24,
      'difficulty': 'easy',
      'category': 'dessert',
      'dietaryTags': ['vegetarian'],
      'ingredients': [
        {'name': 'All-purpose flour', 'quantity': '2', 'unit': 'cups', 'category': 'baking'},
        {'name': 'Baking soda', 'quantity': '1', 'unit': 'tsp', 'category': 'baking'},
        {'name': 'Salt', 'quantity': '1', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Butter', 'quantity': '1', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Brown sugar', 'quantity': '3/4', 'unit': 'cup', 'category': 'baking'},
        {'name': 'White sugar', 'quantity': '1/2', 'unit': 'cup', 'category': 'baking'},
        {'name': 'Eggs', 'quantity': '2', 'unit': 'large', 'category': 'dairy'},
        {'name': 'Vanilla extract', 'quantity': '2', 'unit': 'tsp', 'category': 'baking'},
        {'name': 'Chocolate chips', 'quantity': '2', 'unit': 'cups', 'category': 'baking'},
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
      'id': 'recipe_015',
      'name': 'Hummus',
      'description': 'Creamy homemade hummus with tahini and lemon.',
      'imageUrl': 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=500',
      'prepTime': 15,
      'cookTime': 0,
      'servings': 6,
      'difficulty': 'easy',
      'category': 'mediterranean',
      'dietaryTags': ['vegetarian', 'vegan', 'gluten-free'],
      'ingredients': [
        {'name': 'Chickpeas', 'quantity': '2', 'unit': 'cans', 'category': 'canned'},
        {'name': 'Tahini', 'quantity': '1/4', 'unit': 'cup', 'category': 'condiments'},
        {'name': 'Lemon juice', 'quantity': '3', 'unit': 'tbsp', 'category': 'produce'},
        {'name': 'Garlic', 'quantity': '2', 'unit': 'cloves', 'category': 'produce'},
        {'name': 'Olive oil', 'quantity': '2', 'unit': 'tbsp', 'category': 'oils'},
        {'name': 'Cumin', 'quantity': '1', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Salt', 'quantity': '1/2', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Paprika', 'quantity': '1', 'unit': 'tsp', 'category': 'spices'},
      ],
      'instructions': [
        'Drain and rinse chickpeas.',
        'Combine all ingredients in food processor.',
        'Process until smooth and creamy.',
        'Add water if needed for consistency.',
        'Garnish with olive oil and paprika.',
        'Serve with pita bread or vegetables.',
      ],
    },
    {
      'id': 'recipe_016',
      'name': 'Energy Balls',
      'description': 'No-bake energy balls with dates, nuts, and cocoa powder.',
      'imageUrl': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500',
      'prepTime': 20,
      'cookTime': 0,
      'servings': 16,
      'difficulty': 'easy',
      'category': 'healthy',
      'dietaryTags': ['vegetarian', 'vegan', 'gluten-free'],
      'ingredients': [
        {'name': 'Dates', 'quantity': '1', 'unit': 'cup', 'category': 'produce'},
        {'name': 'Almonds', 'quantity': '1/2', 'unit': 'cup', 'category': 'nuts'},
        {'name': 'Cashews', 'quantity': '1/2', 'unit': 'cup', 'category': 'nuts'},
        {'name': 'Cocoa powder', 'quantity': '2', 'unit': 'tbsp', 'category': 'baking'},
        {'name': 'Coconut oil', 'quantity': '1', 'unit': 'tbsp', 'category': 'oils'},
        {'name': 'Vanilla extract', 'quantity': '1', 'unit': 'tsp', 'category': 'baking'},
        {'name': 'Salt', 'quantity': '1/4', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Shredded coconut', 'quantity': '1/4', 'unit': 'cup', 'category': 'nuts'},
      ],
      'instructions': [
        'Soak dates in warm water for 10 minutes.',
        'Process nuts in food processor until fine.',
        'Add dates, cocoa powder, and other ingredients.',
        'Process until mixture forms a ball.',
        'Roll into 16 small balls.',
        'Roll in shredded coconut if desired.',
        'Refrigerate for 30 minutes before serving.',
      ],
    },

    // INTERNATIONAL CUISINES
    {
      'id': 'recipe_017',
      'name': 'Japanese Ramen',
      'description': 'Rich and flavorful ramen with soft-boiled egg and vegetables.',
      'imageUrl': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500',
      'prepTime': 30,
      'cookTime': 45,
      'servings': 4,
      'difficulty': 'hard',
      'category': 'japanese',
      'dietaryTags': ['meat'],
      'ingredients': [
        {'name': 'Ramen noodles', 'quantity': '4', 'unit': 'servings', 'category': 'pantry'},
        {'name': 'Pork belly', 'quantity': '1', 'unit': 'lb', 'category': 'meat'},
        {'name': 'Soft-boiled eggs', 'quantity': '4', 'unit': 'large', 'category': 'dairy'},
        {'name': 'Green onions', 'quantity': '4', 'unit': 'stalks', 'category': 'produce'},
        {'name': 'Nori sheets', 'quantity': '4', 'unit': 'sheets', 'category': 'seafood'},
        {'name': 'Miso paste', 'quantity': '3', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Soy sauce', 'quantity': '2', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Sesame oil', 'quantity': '1', 'unit': 'tbsp', 'category': 'oils'},
        {'name': 'Garlic', 'quantity': '3', 'unit': 'cloves', 'category': 'produce'},
      ],
      'instructions': [
        'Cook pork belly until tender.',
        'Make rich broth with miso and soy sauce.',
        'Cook ramen noodles according to package.',
        'Soft-boil eggs for 6 minutes.',
        'Slice green onions and nori.',
        'Assemble bowls with noodles, broth, and toppings.',
        'Garnish with nori and green onions.',
      ],
    },
    {
      'id': 'recipe_018',
      'name': 'Indian Butter Chicken',
      'description': 'Creamy tomato-based curry with tender chicken and aromatic spices.',
      'imageUrl': 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=500',
      'prepTime': 25,
      'cookTime': 35,
      'servings': 6,
      'difficulty': 'medium',
      'category': 'indian',
      'dietaryTags': [DietaryTags.meat, 'gluten-free'],
      'ingredients': [
        {'name': 'Chicken thighs', 'quantity': '2', 'unit': 'lbs', 'category': 'meat'},
        {'name': 'Tomato sauce', 'quantity': '28', 'unit': 'oz', 'category': 'canned'},
        {'name': 'Heavy cream', 'quantity': '1', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Butter', 'quantity': '4', 'unit': 'tbsp', 'category': 'dairy'},
        {'name': 'Onion', 'quantity': '1', 'unit': 'large', 'category': 'produce'},
        {'name': 'Garlic', 'quantity': '4', 'unit': 'cloves', 'category': 'produce'},
        {'name': 'Ginger', 'quantity': '2', 'unit': 'tbsp', 'category': 'produce'},
        {'name': 'Garam masala', 'quantity': '2', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Turmeric', 'quantity': '1', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Basmati rice', 'quantity': '2', 'unit': 'cups', 'category': 'grains'},
      ],
      'instructions': [
        'Marinate chicken with yogurt and spices.',
        'Cook chicken until golden brown.',
        'Sauté onions, garlic, and ginger.',
        'Add tomato sauce and spices.',
        'Simmer until sauce thickens.',
        'Add cream and cooked chicken.',
        'Serve over basmati rice.',
      ],
    },
    {
      'id': 'recipe_019',
      'name': 'French Ratatouille',
      'description': 'Traditional French vegetable stew with eggplant, zucchini, and tomatoes.',
      'imageUrl': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=500',
      'prepTime': 30,
      'cookTime': 60,
      'servings': 6,
      'difficulty': 'medium',
      'category': 'french',
      'dietaryTags': ['vegetarian', 'vegan', 'gluten-free'],
      'ingredients': [
        {'name': 'Eggplant', 'quantity': '1', 'unit': 'large', 'category': 'produce'},
        {'name': 'Zucchini', 'quantity': '2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Yellow squash', 'quantity': '2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Tomatoes', 'quantity': '4', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Onion', 'quantity': '1', 'unit': 'large', 'category': 'produce'},
        {'name': 'Bell peppers', 'quantity': '2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Garlic', 'quantity': '4', 'unit': 'cloves', 'category': 'produce'},
        {'name': 'Herbes de Provence', 'quantity': '2', 'unit': 'tbsp', 'category': 'spices'},
        {'name': 'Olive oil', 'quantity': '1/4', 'unit': 'cup', 'category': 'oils'},
      ],
      'instructions': [
        'Slice all vegetables into rounds.',
        'Sauté onions and peppers until soft.',
        'Layer vegetables in a baking dish.',
        'Drizzle with olive oil and herbs.',
        'Bake at 375°F for 45-60 minutes.',
        'Serve warm or at room temperature.',
      ],
    },
    {
      'id': 'recipe_020',
      'name': 'Chinese Fried Rice',
      'description': 'Classic Chinese fried rice with eggs, vegetables, and soy sauce.',
      'imageUrl': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500',
      'prepTime': 15,
      'cookTime': 15,
      'servings': 4,
      'difficulty': 'easy',
      'category': 'chinese',
      'dietaryTags': ['vegetarian'],
      'ingredients': [
        {'name': 'Cooked rice', 'quantity': '3', 'unit': 'cups', 'category': 'grains'},
        {'name': 'Eggs', 'quantity': '3', 'unit': 'large', 'category': 'dairy'},
        {'name': 'Peas', 'quantity': '1', 'unit': 'cup', 'category': 'produce'},
        {'name': 'Carrots', 'quantity': '1', 'unit': 'cup', 'category': 'produce'},
        {'name': 'Green onions', 'quantity': '4', 'unit': 'stalks', 'category': 'produce'},
        {'name': 'Soy sauce', 'quantity': '3', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Sesame oil', 'quantity': '1', 'unit': 'tbsp', 'category': 'oils'},
        {'name': 'Garlic', 'quantity': '2', 'unit': 'cloves', 'category': 'produce'},
        {'name': 'Ginger', 'quantity': '1', 'unit': 'tbsp', 'category': 'produce'},
      ],
      'instructions': [
        'Scramble eggs and set aside.',
        'Sauté vegetables until tender.',
        'Add rice and break up clumps.',
        'Stir in soy sauce and sesame oil.',
        'Add scrambled eggs and green onions.',
        'Toss everything together and serve hot.',
      ],
    },
    {
      'id': 'recipe_021',
      'name': 'Mexican Street Corn',
      'description': 'Grilled corn on the cob with mayo, cheese, and chili powder.',
      'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=500',
      'prepTime': 10,
      'cookTime': 15,
      'servings': 4,
      'difficulty': 'easy',
      'category': 'mexican',
      'dietaryTags': ['vegetarian', 'gluten-free'],
      'ingredients': [
        {'name': 'Corn on the cob', 'quantity': '4', 'unit': 'ears', 'category': 'produce'},
        {'name': 'Mayonnaise', 'quantity': '1/4', 'unit': 'cup', 'category': 'condiments'},
        {'name': 'Cotija cheese', 'quantity': '1/2', 'unit': 'cup', 'category': 'dairy'},
        {'name': 'Chili powder', 'quantity': '1', 'unit': 'tsp', 'category': 'spices'},
        {'name': 'Lime', 'quantity': '2', 'unit': 'medium', 'category': 'produce'},
        {'name': 'Cilantro', 'quantity': '2', 'unit': 'tbsp', 'category': 'produce'},
        {'name': 'Salt', 'quantity': '1/2', 'unit': 'tsp', 'category': 'spices'},
      ],
      'instructions': [
        'Grill corn until charred and tender.',
        'Brush with mayonnaise.',
        'Sprinkle with cotija cheese.',
        'Dust with chili powder.',
        'Squeeze lime juice over corn.',
        'Garnish with cilantro.',
        'Serve immediately.',
      ],
    },
    {
      'id': 'recipe_022',
      'name': 'Korean Bibimbap',
      'description': 'Korean rice bowl with vegetables, meat, and spicy gochujang sauce.',
      'imageUrl': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500',
      'prepTime': 40,
      'cookTime': 20,
      'servings': 4,
      'difficulty': 'medium',
      'category': 'asian',
      'dietaryTags': [DietaryTags.meat, 'gluten-free'],
      'ingredients': [
        {'name': 'Short-grain rice', 'quantity': '2', 'unit': 'cups', 'category': 'grains'},
        {'name': 'Beef', 'quantity': '1', 'unit': 'lb', 'category': 'meat'},
        {'name': 'Spinach', 'quantity': '2', 'unit': 'cups', 'category': 'produce'},
        {'name': 'Carrots', 'quantity': '1', 'unit': 'cup', 'category': 'produce'},
        {'name': 'Bean sprouts', 'quantity': '1', 'unit': 'cup', 'category': 'produce'},
        {'name': 'Gochujang', 'quantity': '3', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Sesame oil', 'quantity': '2', 'unit': 'tbsp', 'category': 'oils'},
        {'name': 'Soy sauce', 'quantity': '2', 'unit': 'tbsp', 'category': 'condiments'},
        {'name': 'Fried egg', 'quantity': '4', 'unit': 'large', 'category': 'dairy'},
      ],
      'instructions': [
        'Cook rice according to package directions.',
        'Marinate beef with soy sauce and sesame oil.',
        'Sauté vegetables separately.',
        'Cook beef until done.',
        'Fry eggs sunny-side up.',
        'Arrange rice in bowls with vegetables and beef.',
        'Top with fried egg and gochujang.',
        'Mix everything together before eating.',
      ],
    },
  ];
}
