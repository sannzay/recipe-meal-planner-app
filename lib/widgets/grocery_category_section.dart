import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/grocery_item_model.dart';
import '../utils/app_theme.dart';

class GroceryCategorySection extends StatefulWidget {
  final String category;
  final List<GroceryItem> items;
  final Function(String itemId) onToggleChecked;
  final Function(String itemId) onDeleteItem;
  final IconData? categoryIcon;

  const GroceryCategorySection({
    super.key,
    required this.category,
    required this.items,
    required this.onToggleChecked,
    required this.onDeleteItem,
    this.categoryIcon,
  });

  @override
  State<GroceryCategorySection> createState() => _GroceryCategorySectionState();
}

class _GroceryCategorySectionState extends State<GroceryCategorySection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final completedCount = widget.items.where((item) => item.isChecked).length;
    final totalCount = widget.items.length;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(completedCount, totalCount),
          if (_isExpanded) _buildItemsList(),
        ],
      ),
    );
  }

  Widget _buildHeader(int completedCount, int totalCount) {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              widget.categoryIcon ?? _getDefaultCategoryIcon(),
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.category.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            Text(
              '$completedCount/$totalCount',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return _buildGroceryItem(item);
      },
    );
  }

  Widget _buildGroceryItem(GroceryItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.isChecked,
            onChanged: (value) {
              widget.onToggleChecked(item.id);
            },
            activeColor: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: item.isChecked 
                        ? TextDecoration.lineThrough 
                        : TextDecoration.none,
                    color: item.isChecked 
                        ? Colors.grey[500] 
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                if (item.quantity.isNotEmpty)
                  Text(
                    item.quantity,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                      decoration: item.isChecked 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => widget.onDeleteItem(item.id),
            color: Colors.red[400],
          ),
        ],
      ),
    );
  }

  IconData _getDefaultCategoryIcon() {
    switch (widget.category.toLowerCase()) {
      case 'produce':
        return Icons.local_florist;
      case 'dairy':
        return Icons.local_drink;
      case 'meat':
        return Icons.restaurant;
      case 'seafood':
        return Icons.set_meal;
      case 'pantry':
        return Icons.kitchen;
      case 'spices':
        return Icons.spa;
      case 'beverages':
        return Icons.local_cafe;
      case 'frozen':
        return Icons.ac_unit;
      default:
        return Icons.shopping_basket;
    }
  }
}
