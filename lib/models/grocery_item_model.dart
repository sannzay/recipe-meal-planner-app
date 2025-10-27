class GroceryItem {
  final String id;
  final String name;
  final String quantity;
  final String unit;
  final String category;
  final bool isChecked;
  final String? fromRecipeId;

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.isChecked,
    this.fromRecipeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'isChecked': isChecked ? 1 : 0,
      'fromRecipeId': fromRecipeId,
    };
  }

  factory GroceryItem.fromMap(Map<String, dynamic> map) {
    return GroceryItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? '',
      unit: map['unit'] ?? '',
      category: map['category'] ?? '',
      isChecked: map['isChecked'] == 1,
      fromRecipeId: map['fromRecipeId'],
    );
  }

  GroceryItem copyWith({
    String? id,
    String? name,
    String? quantity,
    String? unit,
    String? category,
    bool? isChecked,
    String? fromRecipeId,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
      fromRecipeId: fromRecipeId ?? this.fromRecipeId,
    );
  }

  @override
  String toString() {
    return 'GroceryItem(id: $id, name: $name, quantity: $quantity, unit: $unit, category: $category, isChecked: $isChecked, fromRecipeId: $fromRecipeId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroceryItem &&
        other.id == id &&
        other.name == name &&
        other.quantity == quantity &&
        other.unit == unit &&
        other.category == category &&
        other.isChecked == isChecked &&
        other.fromRecipeId == fromRecipeId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        quantity.hashCode ^
        unit.hashCode ^
        category.hashCode ^
        isChecked.hashCode ^
        fromRecipeId.hashCode;
  }
}

