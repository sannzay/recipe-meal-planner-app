import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/ai_models.dart';
import '../config/api_config.dart';
import 'openrouter_client.dart';

class RecipeAIService {
  final OpenRouterClient _client;
  
  RecipeAIService({OpenRouterClient? client}) 
      : _client = client ?? OpenRouterClient();

  Future<AIRecipeResponse> getSuggestions(AIRecipeRequest request) async {
    try {
      final prompt = _buildPrompt(request);
      
      if (kDebugMode) {
        print('[RecipeAI] Generating suggestions...');
        print('[RecipeAI] Ingredients: ${request.availableIngredients.join(", ")}');
      }

      final openRouterRequest = OpenRouterRequest(
        model: ApiConfig.defaultModel,
        messages: [
          Message(role: 'system', content: _getSystemPrompt()),
          Message(role: 'user', content: prompt),
        ],
        maxTokens: ApiConfig.maxTokens,
        temperature: ApiConfig.temperature,
      );

      final response = await _client.sendRequest(openRouterRequest);

      if (response.choices.isEmpty) {
        throw Exception('No response from AI');
      }

      final content = response.choices.first.message.content;
      
      if (kDebugMode) {
        print('[RecipeAI] Raw response received');
      }

      return _parseResponse(content);
    } on TimeoutException {
      throw Exception('Request timed out. Please check your internet connection and try again.');
    } on RateLimitException {
      throw Exception('Too many requests. Please wait a moment and try again.');
    } on AuthenticationException {
      throw Exception('API authentication failed. Please contact support.');
    } on InsufficientCreditsException {
      throw Exception('API credits exhausted. Please contact support.');
    } on NetworkException catch (e) {
      throw Exception('Network error: Please check your internet connection.');
    } catch (e) {
      if (kDebugMode) {
        print('[RecipeAI] Error: $e');
      }
      throw Exception('Failed to generate suggestions: ${e.toString()}');
    }
  }

  String _getSystemPrompt() {
    return '''You are a professional chef and recipe expert. Your role is to suggest creative, delicious, and practical recipes based on available ingredients and user preferences.

When suggesting recipes:
1. Prioritize using the available ingredients provided
2. Suggest recipes that are achievable with common kitchen equipment
3. Provide clear, step-by-step instructions
4. Include accurate cooking times and serving sizes
5. Respect dietary restrictions strictly
6. Be creative but practical

Always respond with valid JSON in the exact format specified.''';
  }

  String _buildPrompt(AIRecipeRequest request) {
    final buffer = StringBuffer();
    
    buffer.writeln('Based on the following information, suggest ${request.numberOfSuggestions} recipes:');
    buffer.writeln();
    buffer.writeln('Available Ingredients: ${request.availableIngredients.join(", ")}');
    
    if (request.dietaryRestrictions.isNotEmpty) {
      buffer.writeln('Dietary Restrictions: ${request.dietaryRestrictions.join(", ")}');
    }
    
    if (request.cuisinePreference != 'any' && request.cuisinePreference.isNotEmpty) {
      buffer.writeln('Cuisine Preference: ${request.cuisinePreference}');
    }
    
    buffer.writeln('Maximum Total Cooking Time: ${request.maxCookingTime} minutes');
    buffer.writeln();
    buffer.writeln('Please respond with a JSON object in the following format:');
    buffer.writeln('''{
  "reasoning": "Brief explanation of why these recipes were chosen",
  "suggestions": [
    {
      "name": "Recipe Name",
      "description": "Brief appetizing description",
      "cuisine": "cuisine type",
      "ingredients": [
        {"name": "ingredient name", "quantity": "amount", "unit": "measurement unit"}
      ],
      "instructions": ["step 1", "step 2", "step 3"],
      "prepTime": number (minutes for preparation),
      "cookTime": number (minutes for cooking),
      "servings": number,
      "difficulty": "easy|medium|hard",
      "dietaryTags": ["vegetarian", "vegan", "gluten-free", etc]
    }
  ]
}''');
    buffer.writeln();
    buffer.writeln('Important:');
    buffer.writeln('- Use as many available ingredients as possible');
    buffer.writeln('- Total time (prepTime + cookTime) must not exceed ${request.maxCookingTime} minutes');
    buffer.writeln('- Strictly follow dietary restrictions');
    buffer.writeln('- Provide realistic ingredient quantities');
    buffer.writeln('- Give detailed, numbered instructions');
    buffer.writeln('- Respond ONLY with valid JSON, no additional text');
    
    return buffer.toString();
  }

  AIRecipeResponse _parseResponse(String content) {
    try {
      String jsonContent = content.trim();
      
      if (jsonContent.startsWith('```json')) {
        jsonContent = jsonContent.substring(7);
      } else if (jsonContent.startsWith('```')) {
        jsonContent = jsonContent.substring(3);
      }
      
      if (jsonContent.endsWith('```')) {
        jsonContent = jsonContent.substring(0, jsonContent.length - 3);
      }
      
      jsonContent = jsonContent.trim();
      
      final parsed = jsonDecode(jsonContent) as Map<String, dynamic>;
      return AIRecipeResponse.fromJson(parsed);
    } catch (e) {
      if (kDebugMode) {
        print('[RecipeAI] Parse error: $e');
        print('[RecipeAI] Content: $content');
      }
      
      throw Exception('Failed to parse AI response. Please try again.');
    }
  }

  void dispose() {
    _client.dispose();
  }
}

