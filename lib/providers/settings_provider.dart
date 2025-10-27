import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  Set<String> _dietaryPreferences = {};
  bool _isMetric = true;

  Set<String> get dietaryPreferences => _dietaryPreferences;
  bool get isMetric => _isMetric;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final dietaryPrefs = prefs.getStringList('dietaryPreferences') ?? [];
      _dietaryPreferences = dietaryPrefs.toSet();
      
      _isMetric = prefs.getBool('isMetric') ?? true;
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading settings: $e');
      }
    }
  }

  Future<void> toggleDietaryPreference(String preference) async {
    try {
      if (_dietaryPreferences.contains(preference)) {
        _dietaryPreferences.remove(preference);
      } else {
        _dietaryPreferences.add(preference);
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('dietaryPreferences', _dietaryPreferences.toList());
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling dietary preference: $e');
      }
    }
  }

  Future<void> setDietaryPreferences(Set<String> preferences) async {
    try {
      _dietaryPreferences = preferences;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('dietaryPreferences', _dietaryPreferences.toList());
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error setting dietary preferences: $e');
      }
    }
  }

  Future<void> toggleUnitSystem() async {
    try {
      _isMetric = !_isMetric;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isMetric', _isMetric);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling unit system: $e');
      }
    }
  }

  Future<void> setUnitSystem(bool isMetric) async {
    try {
      _isMetric = isMetric;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isMetric', _isMetric);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error setting unit system: $e');
      }
    }
  }

  bool hasDietaryPreference(String preference) {
    return _dietaryPreferences.contains(preference);
  }

  List<String> getAvailableDietaryPreferences() {
    return [
      'vegetarian',
      'vegan',
      'gluten-free',
      'dairy-free',
      'nut-free',
      'keto',
      'paleo',
      'low-carb',
      'low-fat',
      'high-protein',
    ];
  }

  Future<void> resetToDefaults() async {
    try {
      _dietaryPreferences.clear();
      _isMetric = true;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('dietaryPreferences');
      await prefs.setBool('isMetric', _isMetric);
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting settings: $e');
      }
    }
  }
}
