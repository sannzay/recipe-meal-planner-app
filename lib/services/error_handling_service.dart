import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../widgets/error_widgets.dart';

class ErrorHandler {
  static const String _tag = 'ErrorHandler';

  static void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[$_tag] ERROR: $message');
      if (error != null) {
        print('[$_tag] Error details: $error');
      }
      if (stackTrace != null) {
        print('[$_tag] Stack trace: $stackTrace');
      }
    }
  }

  static void logInfo(String message) {
    if (kDebugMode) {
      print('[$_tag] INFO: $message');
    }
  }

  static void logWarning(String message) {
    if (kDebugMode) {
      print('[$_tag] WARNING: $message');
    }
  }

  static String getErrorMessage(dynamic error) {
    if (error is DatabaseException) {
      return _getDatabaseErrorMessage(error);
    } else if (error is FormatException) {
      return 'Invalid data format. Please check your input.';
    } else if (error is ArgumentError) {
      return 'Invalid argument provided.';
    } else if (error is StateError) {
      return 'Application state error. Please restart the app.';
    } else if (error is Exception) {
      return 'An unexpected error occurred: ${error.toString()}';
    } else {
      return 'An unknown error occurred. Please try again.';
    }
  }

  static String _getDatabaseErrorMessage(DatabaseException error) {
    switch (error.resultCode) {
      case DatabaseException.sqliteConstraint:
        return 'Data constraint violation. Please check your input.';
      case DatabaseException.sqliteCorrupt:
        return 'Database corruption detected. Please restart the app.';
      case DatabaseException.sqliteFull:
        return 'Database is full. Please free up some space.';
      case DatabaseException.sqliteNotFound:
        return 'Database not found. Please reinstall the app.';
      case DatabaseException.sqliteNotADatabase:
        return 'Invalid database file. Please reinstall the app.';
      case DatabaseException.sqliteBusy:
        return 'Database is busy. Please try again.';
      case DatabaseException.sqliteLocked:
        return 'Database is locked. Please try again.';
      case DatabaseException.sqliteReadOnly:
        return 'Database is read-only. Please check permissions.';
      case DatabaseException.sqliteInterrupt:
        return 'Database operation interrupted. Please try again.';
      case DatabaseException.sqliteIOErr:
        return 'Database I/O error. Please check storage.';
      case DatabaseException.sqlitePerm:
        return 'Database permission denied. Please check permissions.';
      case DatabaseException.sqliteAbort:
        return 'Database operation aborted. Please try again.';
      case DatabaseException.sqliteTooBig:
        return 'Data too large for database. Please reduce size.';
      case DatabaseException.sqliteMisuse:
        return 'Database misuse error. Please restart the app.';
      default:
        return 'Database error occurred. Please try again.';
    }
  }

  static Future<T> handleDatabaseOperation<T>(
    Future<T> Function() operation, {
    T? fallbackValue,
    String? operationName,
  }) async {
    try {
      logInfo('Starting database operation: ${operationName ?? 'Unknown'}');
      final result = await operation();
      logInfo('Database operation completed successfully: ${operationName ?? 'Unknown'}');
      return result;
    } on DatabaseException catch (e, stackTrace) {
      logError('Database operation failed: ${operationName ?? 'Unknown'}', e, stackTrace);
      if (fallbackValue != null) {
        return fallbackValue;
      }
      rethrow;
    } catch (e, stackTrace) {
      logError('Unexpected error in database operation: ${operationName ?? 'Unknown'}', e, stackTrace);
      if (fallbackValue != null) {
        return fallbackValue;
      }
      rethrow;
    }
  }

  static Future<void> handleAsyncOperation(
    Future<void> Function() operation, {
    String? operationName,
    VoidCallback? onError,
  }) async {
    try {
      logInfo('Starting async operation: ${operationName ?? 'Unknown'}');
      await operation();
      logInfo('Async operation completed successfully: ${operationName ?? 'Unknown'}');
    } catch (e, stackTrace) {
      logError('Async operation failed: ${operationName ?? 'Unknown'}', e, stackTrace);
      onError?.call();
      rethrow;
    }
  }

  static T handleSyncOperation<T>(
    T Function() operation, {
    T? fallbackValue,
    String? operationName,
  }) {
    try {
      logInfo('Starting sync operation: ${operationName ?? 'Unknown'}');
      final result = operation();
      logInfo('Sync operation completed successfully: ${operationName ?? 'Unknown'}');
      return result;
    } catch (e, stackTrace) {
      logError('Sync operation failed: ${operationName ?? 'Unknown'}', e, stackTrace);
      if (fallbackValue != null) {
        return fallbackValue;
      }
      rethrow;
    }
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ErrorHandler.logError('Showing error snackbar: $message');
    ErrorHandler.showErrorSnackBar(context, message);
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ErrorHandler.logInfo('Showing success snackbar: $message');
    ErrorHandler.showSuccessSnackBar(context, message);
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ErrorHandler.logInfo('Showing info snackbar: $message');
    ErrorHandler.showInfoSnackBar(context, message);
  }

  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) {
    ErrorHandler.logInfo('Showing confirm dialog: $title');
    return ErrorHandler.showConfirmDialog(
      context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmColor: confirmColor,
    );
  }

  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    ErrorHandler.logError('Showing error dialog: $title');
    ErrorHandler.showErrorDialog(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
    );
  }
}

class ValidationHelper {
  static String? validateRecipeName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Recipe name is required';
    }
    if (value.trim().length < 2) {
      return 'Recipe name must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Recipe name must be less than 100 characters';
    }
    return null;
  }

  static String? validateRecipeDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Recipe description is required';
    }
    if (value.trim().length < 10) {
      return 'Recipe description must be at least 10 characters';
    }
    if (value.trim().length > 500) {
      return 'Recipe description must be less than 500 characters';
    }
    return null;
  }

  static String? validateTime(int? value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    if (value < 0) {
      return '$fieldName cannot be negative';
    }
    if (value > 600) {
      return '$fieldName cannot exceed 600 minutes';
    }
    return null;
  }

  static String? validateServings(int? value) {
    if (value == null) {
      return 'Servings is required';
    }
    if (value < 1) {
      return 'Servings must be at least 1';
    }
    if (value > 20) {
      return 'Servings cannot exceed 20';
    }
    return null;
  }

  static String? validateIngredientName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingredient name is required';
    }
    if (value.trim().length < 2) {
      return 'Ingredient name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Ingredient name must be less than 50 characters';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    if (value.trim().length > 20) {
      return 'Quantity must be less than 20 characters';
    }
    return null;
  }

  static String? validateGroceryItemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Item name is required';
    }
    if (value.trim().length < 2) {
      return 'Item name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Item name must be less than 50 characters';
    }
    return null;
  }

  static String? validateSearchQuery(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Search query is required';
    }
    if (value.trim().length < 2) {
      return 'Search query must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Search query must be less than 100 characters';
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

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }
    if (!isValidEmail(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}

class NetworkErrorHandler {
  static String getNetworkErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (error.toString().contains('HandshakeException')) {
      return 'Network security error. Please check your connection.';
    } else if (error.toString().contains('FormatException')) {
      return 'Invalid data received from server.';
    } else {
      return 'Network error occurred. Please try again.';
    }
  }

  static bool isNetworkError(dynamic error) {
    return error.toString().contains('SocketException') ||
           error.toString().contains('TimeoutException') ||
           error.toString().contains('HandshakeException') ||
           error.toString().contains('FormatException');
  }
}

class DataIntegrityHelper {
  static bool isValidRecipe(Map<String, dynamic> data) {
    try {
      // Check required fields
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

  static bool isValidIngredient(Map<String, dynamic> data) {
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

  static bool isValidMealPlan(Map<String, dynamic> data) {
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

  static bool isValidGroceryItem(Map<String, dynamic> data) {
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
