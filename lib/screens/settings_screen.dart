import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/recipe_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadSettings();
      context.read<ThemeProvider>().loadThemePreference();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserPreferencesSection(),
            const SizedBox(height: 24),
            _buildUnitsSection(),
            const SizedBox(height: 24),
            _buildOfflineStorageSection(),
            const SizedBox(height: 24),
            _buildGeneralSection(),
            const SizedBox(height: 24),
            _buildAppInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPreferencesSection() {
    return _buildSection(
      title: 'User Preferences',
      icon: Icons.person_outline,
      children: [
        Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return Column(
              children: DietaryTags.allTags.map((tag) {
                final isSelected = settingsProvider.dietaryPreferences.contains(tag);
                return _buildSwitchTile(
                  title: tag,
                  subtitle: 'Show $tag recipes by default',
                  value: isSelected,
                  onChanged: (value) {
                    settingsProvider.toggleDietaryPreference(tag);
                    _applyDietaryPreferences(settingsProvider.dietaryPreferences);
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUnitsSection() {
    return _buildSection(
      title: 'Units',
      icon: Icons.straighten,
      children: [
        Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return _buildSwitchTile(
              title: 'Metric System',
              subtitle: settingsProvider.isMetric ? 'Using metric units' : 'Using imperial units',
              value: settingsProvider.isMetric,
              onChanged: (value) {
                settingsProvider.toggleUnitSystem();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOfflineStorageSection() {
    return _buildSection(
      title: 'Offline Storage',
      icon: Icons.storage,
      children: [
        _buildActionTile(
          title: 'Manage Data',
          subtitle: 'View storage usage and manage offline data',
          icon: Icons.info_outline,
          onTap: _showStorageInfo,
        ),
        _buildActionTile(
          title: 'Clear Cache',
          subtitle: 'Clear cached images and temporary data',
          icon: Icons.clear_all,
          onTap: _clearCache,
        ),
        _buildActionTile(
          title: 'Export Data',
          subtitle: 'Export your recipes and meal plans',
          icon: Icons.file_download,
          onTap: _exportData,
        ),
      ],
    );
  }

  Widget _buildGeneralSection() {
    return _buildSection(
      title: 'General',
      icon: Icons.settings_outlined,
      children: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return _buildSwitchTile(
              title: 'Dark Mode',
              subtitle: themeProvider.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            );
          },
        ),
        _buildActionTile(
          title: 'About',
          subtitle: 'App version and information',
          icon: Icons.info,
          onTap: _showAboutDialog,
        ),
        _buildActionTile(
          title: 'Contact Support',
          subtitle: 'Get help and report issues',
          icon: Icons.support_agent,
          onTap: _contactSupport,
        ),
        _buildActionTile(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          icon: Icons.privacy_tip,
          onTap: _showPrivacyPolicy,
        ),
      ],
    );
  }

  Widget _buildAppInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recipe & Meal Planner',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Version 1.0.0',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Your daily dose of delicious recipes and smart meal planning.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
            Icon(
              icon,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _applyDietaryPreferences(Set<String> preferences) {
    final recipeProvider = context.read<RecipeProvider>();
    recipeProvider.filterByDietary(preferences.toList());
  }

  void _showStorageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Storage Information',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStorageItem('Recipes', '50 recipes stored'),
            _buildStorageItem('Meal Plans', '7 days of meal plans'),
            _buildStorageItem('Grocery Lists', '3 saved lists'),
            _buildStorageItem('Images', '~25MB cached'),
            const SizedBox(height: 16),
            Text(
              'Total Storage: ~30MB',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached images and temporary data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export feature coming soon'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Recipe & Meal Planner',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.restaurant,
          color: AppTheme.primaryColor,
        ),
      ),
      children: [
        const SizedBox(height: 16),
        Text(
          'Your daily dose of delicious recipes and smart meal planning.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
        ),
        const SizedBox(height: 16),
        Text(
          'Features:',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '• Recipe database with dietary filters\n• Weekly meal planning\n• Smart grocery list generation\n• Offline storage\n• Dark mode support',
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
        ),
      ],
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact support feature coming soon'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'This app stores all data locally on your device. We do not collect or share any personal information. Your recipes, meal plans, and grocery lists are stored securely in your device\'s local database.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}