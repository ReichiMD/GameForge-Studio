import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import 'item_list_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  final Project project;

  const CategorySelectionScreen({super.key, required this.project});

  static final List<Map<String, String>> _categories = [
    {
      'id': 'weapons',
      'name': 'Waffen',
      'emoji': '⚔️',
      'description': 'Schwerter, Äxte, Bögen',
    },
    {
      'id': 'armor',
      'name': 'Rüstung',
      'emoji': '🛡️',
      'description': 'Helme, Brustpanzer, Hosen',
    },
    {
      'id': 'mobs',
      'name': 'Mobs',
      'emoji': '👾',
      'description': 'Tiere, Monster, NPCs',
    },
    {
      'id': 'food',
      'name': 'Nahrung',
      'emoji': '🍖',
      'description': 'Essen, Tränke',
    },
    {
      'id': 'blocks',
      'name': 'Blöcke',
      'emoji': '🧱',
      'description': 'Baublöcke, Dekorationen',
    },
    {
      'id': 'tools',
      'name': 'Werkzeuge',
      'emoji': '⚒️',
      'description': 'Spitzhacken, Schaufeln',
    },
  ];

  Future<void> _handleCategorySelect(BuildContext context, Map<String, String> category) async {
    // Navigate to item list screen
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemListScreen(
          project: project,
          category: category,
        ),
      ),
    );

    // Pop back to ProjectDetailScreen with result
    if (result == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: AppSizing.touchMinimum,
              height: AppSizing.touchMinimum,
              alignment: Alignment.center,
              child: const Text('←', style: TextStyle(fontSize: 28, color: AppColors.text)),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Text('🎯', style: TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          const Text(
            'Kategorie wählen',
            style: TextStyle(
              fontSize: AppTypography.xl,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.0,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, String> category) {
    return GestureDetector(
      onTap: () => _handleCategorySelect(context, category),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          border: Border.all(color: AppColors.border, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category['emoji']!,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              category['name']!,
              style: const TextStyle(
                fontSize: AppTypography.lg,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                category['description']!,
                style: TextStyle(
                  fontSize: AppTypography.xs,
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
