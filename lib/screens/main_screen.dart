import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';
import '../utils/ui_polish_constants.dart';
import '../utils/ui_helpers.dart';
import '../widgets/polished_widgets.dart';
import 'recipe_list_screen.dart';
import 'meal_planner_screen.dart';
import 'grocery_list_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RecipeListScreen(),
    const MealPlannerScreen(),
    const GroceryListScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month_outlined),
      activeIcon: Icon(Icons.calendar_month),
      label: 'Meal Plan',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart_outlined),
      activeIcon: Icon(Icons.shopping_cart),
      label: 'Grocery List',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite_outline),
      activeIcon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      activeIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return PolishedScaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                // Haptic feedback for better UX
                HapticFeedback.lightImpact();
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              selectedLabelStyle: GoogleFonts.plusJakartaSans(
                fontSize: UIPolishConstants.fontSizeS,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                fontSize: UIPolishConstants.fontSizeS,
                fontWeight: FontWeight.normal,
              ),
              items: _navItems.map((item) {
                return BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(UIPolishConstants.spacingS),
                    child: item.icon,
                  ),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(UIPolishConstants.spacingS),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(UIPolishConstants.radiusM),
                    ),
                    child: item.activeIcon,
                  ),
                  label: item.label,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
