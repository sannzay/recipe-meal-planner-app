import 'dart:convert';
import 'ingredient_model.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;
  final String category;
  final List<String> dietaryTags;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.category,
    required this.dietaryTags,
    required this.ingredients,
    required this.instructions,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'difficulty': difficulty,
      'category': category,
      'dietaryTags': dietaryTags.join(','),
      'ingredients': jsonEncode(ingredients.map((x) => x.toMap()).toList()),
      'instructions': instructions.join('|||'),
      'isFavorite': isFavorite ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      prepTime: map['prepTime']?.toInt() ?? 0,
      cookTime: map['cookTime']?.toInt() ?? 0,
      servings: map['servings']?.toInt() ?? 0,
      difficulty: map['difficulty'] ?? '',
      category: map['category'] ?? '',
      dietaryTags: map['dietaryTags'] != null 
          ? (map['dietaryTags'] as String).split(',').where((s) => s.isNotEmpty).toList()
          : [],
      ingredients: map['ingredients'] != null
          ? List<Ingredient>.from(
              (jsonDecode(map['ingredients']) as List)
                  .map((x) => Ingredient.fromMap(x))
            )
          : [],
      instructions: map['instructions'] != null
          ? (map['instructions'] as String).split('|||').where((s) => s.isNotEmpty).toList()
          : [],
      isFavorite: map['isFavorite'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }

  Recipe copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? prepTime,
    int? cookTime,
    int? servings,
    String? difficulty,
    String? category,
    List<String>? dietaryTags,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Recipe(id: $id, name: $name, description: $description, imageUrl: $imageUrl, prepTime: $prepTime, cookTime: $cookTime, servings: $servings, difficulty: $difficulty, category: $category, dietaryTags: $dietaryTags, ingredients: $ingredients, instructions: $instructions, isFavorite: $isFavorite, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.prepTime == prepTime &&
        other.cookTime == cookTime &&
        other.servings == servings &&
        other.difficulty == difficulty &&
        other.category == category &&
        other.dietaryTags.toString() == dietaryTags.toString() &&
        other.ingredients.toString() == ingredients.toString() &&
        other.instructions.toString() == instructions.toString() &&
        other.isFavorite == isFavorite &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        prepTime.hashCode ^
        cookTime.hashCode ^
        servings.hashCode ^
        difficulty.hashCode ^
        category.hashCode ^
        dietaryTags.hashCode ^
        ingredients.hashCode ^
        instructions.hashCode ^
        isFavorite.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

