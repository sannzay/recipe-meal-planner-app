import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/meal_plan_provider.dart';
import 'providers/grocery_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/settings_provider.dart';
import 'utils/app_theme.dart';
import 'database/database_helper.dart';
import 'database/seed_data.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize database with error handling
    await DatabaseHelper().database;
    await DatabaseSeeder().seedDatabaseIfEmpty();
  } catch (e) {
    // Log error but don't crash the app
    print('Database initialization failed: $e');
    print('App will continue with limited functionality');
  }
  
  runApp(const RecipeMealPlannerApp());
}

class RecipeMealPlannerApp extends StatelessWidget {
  const RecipeMealPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
        ChangeNotifierProvider(create: (_) => GroceryProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Recipe Meal Planner',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
