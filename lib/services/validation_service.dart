import 'package:flutter/material.dart';
import '../services/error_handling_service.dart';

class FormValidator {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }
    return null;
  }

  static String? validateRange(int? value, int min, int max, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    if (value < min || value > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }

  static String? validatePositiveNumber(int? value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    if (value <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }

  static String? validateNonNegativeNumber(int? value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    if (value < 0) {
      return '$fieldName cannot be negative';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL is optional
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null || (!uri.hasScheme || (!uri.scheme.startsWith('http')))) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    if (!RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateRecipeName(String? value) {
    return ValidationHelper.validateRecipeName(value);
  }

  static String? validateRecipeDescription(String? value) {
    return ValidationHelper.validateRecipeDescription(value);
  }

  static String? validateTime(int? value, String fieldName) {
    return ValidationHelper.validateTime(value, fieldName);
  }

  static String? validateServings(int? value) {
    return ValidationHelper.validateServings(value);
  }

  static String? validateIngredientName(String? value) {
    return ValidationHelper.validateIngredientName(value);
  }

  static String? validateQuantity(String? value) {
    return ValidationHelper.validateQuantity(value);
  }

  static String? validateGroceryItemName(String? value) {
    return ValidationHelper.validateGroceryItemName(value);
  }

  static String? validateSearchQuery(String? value) {
    return ValidationHelper.validateSearchQuery(value);
  }

  static bool isValidRecipeData(Map<String, dynamic> data) {
    try {
      if (data['name'] == null || data['name'].toString().trim().isEmpty) {
        return false;
      }
      if (data['description'] == null || data['description'].toString().trim().isEmpty) {
        return false;
      }
      if (data['prep_time'] == null || data['cook_time'] == null) {
        return false;
      }
      if (data['servings'] == null || data['servings'] < 1) {
        return false;
      }
      if (data['difficulty'] == null || data['difficulty'].toString().trim().isEmpty) {
        return false;
      }
      if (data['category'] == null || data['category'].toString().trim().isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      ErrorHandler.logError('Error validating recipe data', e);
      return false;
    }
  }

  static bool isValidIngredientData(Map<String, dynamic> data) {
    try {
      if (data['name'] == null || data['name'].toString().trim().isEmpty) {
        return false;
      }
      if (data['quantity'] == null || data['quantity'].toString().trim().isEmpty) {
        return false;
      }
      if (data['unit'] == null || data['unit'].toString().trim().isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      ErrorHandler.logError('Error validating ingredient data', e);
      return false;
    }
  }

  static bool isValidMealPlanData(Map<String, dynamic> data) {
    try {
      if (data['date'] == null) {
        return false;
      }
      if (data['meal_type'] == null || data['meal_type'].toString().trim().isEmpty) {
        return false;
      }
      if (data['recipe_id'] == null || data['recipe_id'].toString().trim().isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      ErrorHandler.logError('Error validating meal plan data', e);
      return false;
    }
  }

  static bool isValidGroceryItemData(Map<String, dynamic> data) {
    try {
      if (data['name'] == null || data['name'].toString().trim().isEmpty) {
        return false;
      }
      if (data['category'] == null || data['category'].toString().trim().isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      ErrorHandler.logError('Error validating grocery item data', e);
      return false;
    }
  }
}

class InputValidator {
  static String? validateAndSanitizeInput(String? value, {
    required String fieldName,
    bool required = true,
    int? minLength,
    int? maxLength,
    String? pattern,
    String? patternErrorMessage,
  }) {
    if (required && (value == null || value.trim().isEmpty)) {
      return '$fieldName is required';
    }

    if (value != null && value.trim().isNotEmpty) {
      final sanitizedValue = value.trim();

      if (minLength != null && sanitizedValue.length < minLength) {
        return '$fieldName must be at least $minLength characters';
      }

      if (maxLength != null && sanitizedValue.length > maxLength) {
        return '$fieldName must be less than $maxLength characters';
      }

      if (pattern != null && !RegExp(pattern).hasMatch(sanitizedValue)) {
        return patternErrorMessage ?? '$fieldName format is invalid';
      }
    }

    return null;
  }

  static String sanitizeInput(String? value) {
    if (value == null) return '';
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String sanitizeSearchQuery(String? value) {
    if (value == null) return '';
    return value.trim().replaceAll(RegExp(r'[^\w\s]'), '');
  }

  static String sanitizeUrl(String? value) {
    if (value == null) return '';
    return value.trim().toLowerCase();
  }

  static String sanitizeEmail(String? value) {
    if (value == null) return '';
    return value.trim().toLowerCase();
  }
}

class DataSanitizer {
  static Map<String, dynamic> sanitizeRecipeData(Map<String, dynamic> data) {
    try {
      final sanitized = Map<String, dynamic>.from(data);
      
      if (sanitized['name'] != null) {
        sanitized['name'] = InputValidator.sanitizeInput(sanitized['name'].toString());
      }
      
      if (sanitized['description'] != null) {
        sanitized['description'] = InputValidator.sanitizeInput(sanitized['description'].toString());
      }
      
      if (sanitized['category'] != null) {
        sanitized['category'] = InputValidator.sanitizeInput(sanitized['category'].toString());
      }
      
      if (sanitized['difficulty'] != null) {
        sanitized['difficulty'] = InputValidator.sanitizeInput(sanitized['difficulty'].toString());
      }
      
      if (sanitized['image_url'] != null) {
        sanitized['image_url'] = InputValidator.sanitizeUrl(sanitized['image_url'].toString());
      }
      
      return sanitized;
    } catch (e) {
      ErrorHandler.logError('Error sanitizing recipe data', e);
      return data;
    }
  }

  static Map<String, dynamic> sanitizeIngredientData(Map<String, dynamic> data) {
    try {
      final sanitized = Map<String, dynamic>.from(data);
      
      if (sanitized['name'] != null) {
        sanitized['name'] = InputValidator.sanitizeInput(sanitized['name'].toString());
      }
      
      if (sanitized['quantity'] != null) {
        sanitized['quantity'] = InputValidator.sanitizeInput(sanitized['quantity'].toString());
      }
      
      if (sanitized['unit'] != null) {
        sanitized['unit'] = InputValidator.sanitizeInput(sanitized['unit'].toString());
      }
      
      if (sanitized['category'] != null) {
        sanitized['category'] = InputValidator.sanitizeInput(sanitized['category'].toString());
      }
      
      return sanitized;
    } catch (e) {
      ErrorHandler.logError('Error sanitizing ingredient data', e);
      return data;
    }
  }

  static Map<String, dynamic> sanitizeGroceryItemData(Map<String, dynamic> data) {
    try {
      final sanitized = Map<String, dynamic>.from(data);
      
      if (sanitized['name'] != null) {
        sanitized['name'] = InputValidator.sanitizeInput(sanitized['name'].toString());
      }
      
      if (sanitized['quantity'] != null) {
        sanitized['quantity'] = InputValidator.sanitizeInput(sanitized['quantity'].toString());
      }
      
      if (sanitized['unit'] != null) {
        sanitized['unit'] = InputValidator.sanitizeInput(sanitized['unit'].toString());
      }
      
      if (sanitized['category'] != null) {
        sanitized['category'] = InputValidator.sanitizeInput(sanitized['category'].toString());
      }
      
      return sanitized;
    } catch (e) {
      ErrorHandler.logError('Error sanitizing grocery item data', e);
      return data;
    }
  }
}
