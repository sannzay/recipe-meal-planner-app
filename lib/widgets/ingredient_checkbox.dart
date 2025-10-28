import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ingredient_model.dart';
import '../utils/app_theme.dart';

class IngredientCheckbox extends StatelessWidget {
  final Ingredient ingredient;
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final bool showQuantity;

  const IngredientCheckbox({
    super.key,
    required this.ingredient,
    required this.isChecked,
    required this.onChanged,
    this.showQuantity = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: isChecked 
                        ? TextDecoration.lineThrough 
                        : TextDecoration.none,
                    color: isChecked 
                        ? Colors.grey[500] 
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                if (showQuantity && ingredient.quantity.isNotEmpty)
                  Text(
                    ingredient.quantity,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                      decoration: isChecked 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                    ),
                  ),
              ],
            ),
          ),
          if (ingredient.category.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ingredient.category,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
