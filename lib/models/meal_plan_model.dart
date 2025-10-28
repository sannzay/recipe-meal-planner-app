class MealPlan {
  final String id;
  final DateTime date;
  final String mealType;
  final String recipeId;

  MealPlan({
    required this.id,
    required this.date,
    required this.mealType,
    required this.recipeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'meal_type': mealType,
      'recipe_id': recipeId,
    };
  }

  factory MealPlan.fromMap(Map<String, dynamic> map) {
    return MealPlan(
      id: map['id'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      mealType: map['meal_type'] ?? '',
      recipeId: map['recipe_id'] ?? '',
    );
  }

  MealPlan copyWith({
    String? id,
    DateTime? date,
    String? mealType,
    String? recipeId,
  }) {
    return MealPlan(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      recipeId: recipeId ?? this.recipeId,
    );
  }

  @override
  String toString() {
    return 'MealPlan(id: $id, date: $date, mealType: $mealType, recipeId: $recipeId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealPlan &&
        other.id == id &&
        other.date == date &&
        other.mealType == mealType &&
        other.recipeId == recipeId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        mealType.hashCode ^
        recipeId.hashCode;
  }
}

