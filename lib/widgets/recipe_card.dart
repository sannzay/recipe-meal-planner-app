import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/recipe_model.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool showFavoriteButton;
  final bool isCompact;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onFavoriteToggle,
    this.showFavoriteButton = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 4),
                  _buildSubtitle(),
                  const SizedBox(height: 8),
                  _buildTags(),
                  if (!isCompact) ...[
                    const SizedBox(height: 8),
                    _buildActionButton(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: isCompact ? 120 : 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          if (recipe.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: recipe.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.restaurant,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            )
          else
            const Center(
              child: Icon(
                Icons.restaurant,
                color: Colors.grey,
                size: 40,
              ),
            ),
          if (showFavoriteButton)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    recipe.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    color: recipe.isFavorite ? AppTheme.primaryColor : Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      recipe.name,
      style: GoogleFonts.plusJakartaSans(
        fontSize: isCompact ? 14 : 16,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Text(
          '${recipe.prepTime + recipe.cookTime} min',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.trending_up,
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Text(
          recipe.difficulty,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    if (recipe.dietaryTags.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: recipe.dietaryTags.take(2).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.medium,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'View Recipe',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.medium,
          ),
        ),
      ),
    );
  }
}
