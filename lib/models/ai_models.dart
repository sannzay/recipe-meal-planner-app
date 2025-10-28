import 'dart:convert';

class AIRecipeRequest {
  final List<String> availableIngredients;
  final List<String> dietaryRestrictions;
  final String cuisinePreference;
  final int maxCookingTime;
  final int numberOfSuggestions;

  AIRecipeRequest({
    required this.availableIngredients,
    this.dietaryRestrictions = const [],
    this.cuisinePreference = 'any',
    this.maxCookingTime = 60,
    this.numberOfSuggestions = 3,
  });

  Map<String, dynamic> toMap() {
    return {
      'availableIngredients': availableIngredients,
      'dietaryRestrictions': dietaryRestrictions,
      'cuisinePreference': cuisinePreference,
      'maxCookingTime': maxCookingTime,
      'numberOfSuggestions': numberOfSuggestions,
    };
  }
}

class AIRecipeResponse {
  final List<AIRecipeSuggestion> suggestions;
  final String reasoning;

  AIRecipeResponse({
    required this.suggestions,
    required this.reasoning,
  });

  factory AIRecipeResponse.fromJson(Map<String, dynamic> json) {
    return AIRecipeResponse(
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((item) => AIRecipeSuggestion.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      reasoning: json['reasoning'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suggestions': suggestions.map((s) => s.toJson()).toList(),
      'reasoning': reasoning,
    };
  }
}

class AIRecipeSuggestion {
  final String name;
  final String description;
  final List<AIIngredient> ingredients;
  final List<String> instructions;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;
  final List<String> dietaryTags;
  final String cuisine;

  AIRecipeSuggestion({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.dietaryTags,
    required this.cuisine,
  });

  factory AIRecipeSuggestion.fromJson(Map<String, dynamic> json) {
    return AIRecipeSuggestion(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((item) => AIIngredient.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      prepTime: json['prepTime'] as int? ?? json['prep_time'] as int? ?? 0,
      cookTime: json['cookTime'] as int? ?? json['cook_time'] as int? ?? 0,
      servings: json['servings'] as int? ?? 4,
      difficulty: json['difficulty'] as String? ?? 'medium',
      dietaryTags: (json['dietaryTags'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          (json['dietary_tags'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      cuisine: json['cuisine'] as String? ?? 'international',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'difficulty': difficulty,
      'dietaryTags': dietaryTags,
      'cuisine': cuisine,
    };
  }
}

class AIIngredient {
  final String name;
  final String quantity;
  final String unit;

  AIIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory AIIngredient.fromJson(Map<String, dynamic> json) {
    return AIIngredient(
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

class OpenRouterRequest {
  final String model;
  final List<Message> messages;
  final int maxTokens;
  final double temperature;

  OpenRouterRequest({
    required this.model,
    required this.messages,
    this.maxTokens = 2000,
    this.temperature = 0.7,
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'messages': messages.map((m) => m.toJson()).toList(),
      'max_tokens': maxTokens,
      'temperature': temperature,
    };
  }
}

class Message {
  final String role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class OpenRouterResponse {
  final String id;
  final List<Choice> choices;
  final Usage? usage;

  OpenRouterResponse({
    required this.id,
    required this.choices,
    this.usage,
  });

  factory OpenRouterResponse.fromJson(Map<String, dynamic> json) {
    return OpenRouterResponse(
      id: json['id'] as String? ?? '',
      choices: (json['choices'] as List<dynamic>?)
              ?.map((item) => Choice.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      usage: json['usage'] != null
          ? Usage.fromJson(json['usage'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Choice {
  final Message message;
  final String finishReason;

  Choice({
    required this.message,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      message: Message(
        role: json['message']?['role'] as String? ?? 'assistant',
        content: json['message']?['content'] as String? ?? '',
      ),
      finishReason: json['finish_reason'] as String? ?? '',
    );
  }
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'] as int? ?? 0,
      completionTokens: json['completion_tokens'] as int? ?? 0,
      totalTokens: json['total_tokens'] as int? ?? 0,
    );
  }
}

