import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/recipe_provider.dart';
import '../models/recipe_model.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/recipe_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_indicator.dart';
import 'recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;
  
  String _searchQuery = '';
  List<String> _recentSearches = [];
  List<String> _activeFilters = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().loadRecipes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Search Recipes',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_activeFilters.isNotEmpty) _buildActiveFilters(),
          Expanded(
            child: _buildSearchContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search recipes, ingredients, or categories...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _activeFilters.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChipWidget(
                label: filter,
                isSelected: true,
                onTap: () => _removeFilter(filter),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    if (_searchQuery.isEmpty && _activeFilters.isEmpty) {
      return _buildDefaultContent();
    }

    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        if (_isSearching) {
          return const LoadingIndicator(message: 'Searching recipes...');
        }

        final searchResults = _getSearchResults(recipeProvider.recipes);
        
        if (searchResults.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.search_off,
            title: 'No recipes found',
            subtitle: 'Try adjusting your search terms or filters',
            actionText: 'Clear Search',
            onAction: _clearSearch,
          );
        }

        return Column(
          children: [
            _buildSearchResultsHeader(searchResults.length),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final recipe = searchResults[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: RecipeCard(
                      recipe: recipe,
                      isCompact: true,
                      onTap: () => _navigateToRecipe(recipe),
                      onFavoriteToggle: () => recipeProvider.toggleFavorite(recipe.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDefaultContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionHeader('Recent Searches'),
            const SizedBox(height: 12),
            _buildRecentSearches(),
            const SizedBox(height: 24),
          ],
          _buildSectionHeader('Popular Recipes'),
          const SizedBox(height: 12),
          _buildPopularRecipes(),
          const SizedBox(height: 24),
          _buildSectionHeader('Popular Tags'),
          const SizedBox(height: 12),
          _buildPopularTags(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _recentSearches.take(5).map((search) {
        return InkWell(
          onTap: () => _performSearch(search),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.history,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  search,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPopularRecipes() {
    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        final popularRecipes = recipeProvider.recipes.take(3).toList();
        
        return Column(
          children: popularRecipes.map((recipe) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _navigateToRecipe(recipe),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: recipe.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  recipe.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.restaurant,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.restaurant,
                                color: Colors.grey,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.medium,
                              ),
                            ),
                            Text(
                              '${recipe.prepTime + recipe.cookTime} min • ${recipe.difficulty}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.trending_up,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPopularTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DietaryTags.allTags.take(6).map((tag) {
        return InkWell(
          onTap: () => _addFilter(tag),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tag,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.medium,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchResultsHeader(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '$count recipe${count != 1 ? 's' : ''} found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.medium,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _showFilterDialog,
            child: Text(
              'Filter',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = value;
        _isSearching = false;
      });
      
      if (value.isNotEmpty) {
        _addToRecentSearches(value);
      }
    });

    setState(() {
      _isSearching = true;
    });
  }

  void _performSearch(String query) {
    _searchController.text = query;
    setState(() {
      _searchQuery = query;
    });
    _addToRecentSearches(query);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
    });
    _searchFocusNode.unfocus();
  }

  void _addFilter(String filter) {
    if (!_activeFilters.contains(filter)) {
      setState(() {
        _activeFilters.add(filter);
      });
    }
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
    });
  }

  List<Recipe> _getSearchResults(List<Recipe> recipes) {
    var results = recipes;

    if (_searchQuery.isNotEmpty) {
      results = results.where((recipe) {
        return recipe.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               recipe.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               recipe.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               recipe.ingredients.any((ingredient) => 
                 ingredient.name.toLowerCase().contains(_searchQuery.toLowerCase())
               );
      }).toList();
    }

    if (_activeFilters.isNotEmpty) {
      results = results.where((recipe) {
        return _activeFilters.any((filter) =>
          recipe.dietaryTags.any((tag) => tag.toLowerCase() == filter.toLowerCase())
        );
      }).toList();
    }

    return results;
  }

  void _navigateToRecipe(Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Filter Recipes',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: DietaryTags.allTags.map((tag) {
              final isSelected = _activeFilters.contains(tag);
              return CheckboxListTile(
                title: Text(tag),
                value: isSelected,
                onChanged: (value) {
                  if (value == true) {
                    _addFilter(tag);
                  } else {
                    _removeFilter(tag);
                  }
                },
                activeColor: AppTheme.primaryColor,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _activeFilters.clear();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Clear All'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _loadRecentSearches() async {
    // In a real app, you would load from SharedPreferences
    // For now, we'll use a mock list
    setState(() {
      _recentSearches = ['pasta', 'chicken', 'vegetarian', 'quick meals'];
    });
  }

  void _addToRecentSearches(String search) {
    if (!_recentSearches.contains(search)) {
      setState(() {
        _recentSearches.insert(0, search);
        if (_recentSearches.length > 10) {
          _recentSearches = _recentSearches.take(10).toList();
        }
      });
      // In a real app, you would save to SharedPreferences
    }
  }
}
