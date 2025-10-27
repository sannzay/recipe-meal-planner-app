import 'package:flutter/foundation.dart';
import '../models/meal_plan_model.dart';
import '../database/meal_plan_repository.dart';

class MealPlanProvider with ChangeNotifier {
  final MealPlanRepository _mealPlanRepository = MealPlanRepository();
  
  Map<DateTime, List<MealPlan>> _weeklyPlans = {};
  DateTime _selectedDate = DateTime.now();

  Map<DateTime, List<MealPlan>> get weeklyPlans => _weeklyPlans;
  DateTime get selectedDate => _selectedDate;

  List<DateTime> getWeekDates() {
    final startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  Future<void> loadWeeklyPlan() async {
    try {
      final weekDates = getWeekDates();
      final startDate = weekDates.first;
      final endDate = weekDates.last;
      
      final mealPlans = await _mealPlanRepository.getMealPlansByDateRange(startDate, endDate);
      
      _weeklyPlans.clear();
      for (final mealPlan in mealPlans) {
        final date = DateTime(mealPlan.date.year, mealPlan.date.month, mealPlan.date.day);
        if (!_weeklyPlans.containsKey(date)) {
          _weeklyPlans[date] = [];
        }
        _weeklyPlans[date]!.add(mealPlan);
      }
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading weekly plan: $e');
      }
    }
  }

  Future<void> addMealToPlan(DateTime date, String mealType, String recipeId) async {
    try {
      final mealPlan = MealPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: date,
        mealType: mealType,
        recipeId: recipeId,
      );
      
      await _mealPlanRepository.insertMealPlan(mealPlan);
      
      final normalizedDate = DateTime(date.year, date.month, date.day);
      if (!_weeklyPlans.containsKey(normalizedDate)) {
        _weeklyPlans[normalizedDate] = [];
      }
      _weeklyPlans[normalizedDate]!.add(mealPlan);
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding meal to plan: $e');
      }
    }
  }

  Future<void> removeMealFromPlan(DateTime date, String mealType) async {
    try {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final existingMeals = _weeklyPlans[normalizedDate] ?? [];
      
      final mealToRemove = existingMeals.firstWhere(
        (meal) => meal.mealType == mealType,
        orElse: () => MealPlan(
          id: '',
          date: date,
          mealType: mealType,
          recipeId: '',
        ),
      );
      
      if (mealToRemove.id.isNotEmpty) {
        await _mealPlanRepository.deleteMealPlan(mealToRemove.id);
        _weeklyPlans[normalizedDate]!.removeWhere((meal) => meal.id == mealToRemove.id);
        
        if (_weeklyPlans[normalizedDate]!.isEmpty) {
          _weeklyPlans.remove(normalizedDate);
        }
        
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing meal from plan: $e');
      }
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void navigateToPreviousWeek() {
    _selectedDate = _selectedDate.subtract(const Duration(days: 7));
    loadWeeklyPlan();
  }

  void navigateToNextWeek() {
    _selectedDate = _selectedDate.add(const Duration(days: 7));
    loadWeeklyPlan();
  }

  void navigateToCurrentWeek() {
    _selectedDate = DateTime.now();
    loadWeeklyPlan();
  }

  List<MealPlan> getMealsForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _weeklyPlans[normalizedDate] ?? [];
  }

  MealPlan? getMealForDateAndType(DateTime date, String mealType) {
    final meals = getMealsForDate(date);
    try {
      return meals.firstWhere((meal) => meal.mealType == mealType);
    } catch (e) {
      return null;
    }
  }

  bool hasMealForDateAndType(DateTime date, String mealType) {
    return getMealForDateAndType(date, mealType) != null;
  }

  Future<void> clearWeekPlan() async {
    try {
      final weekDates = getWeekDates();
      final startDate = weekDates.first;
      final endDate = weekDates.last;
      
      await _mealPlanRepository.deleteMealPlansByDateRange(startDate, endDate);
      _weeklyPlans.clear();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing week plan: $e');
      }
    }
  }

  int getTotalMealsForWeek() {
    return _weeklyPlans.values.fold(0, (total, meals) => total + meals.length);
  }

  List<String> getMealTypes() {
    return ['breakfast', 'lunch', 'dinner', 'snack'];
  }
}
