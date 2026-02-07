import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../models/vanilla_item.dart';
import '../services/project_service.dart';
import '../services/vanilla_data_service.dart';
import '../widgets/item_selection_modal.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ProjectService _projectService = ProjectService();
  final VanillaDataService _vanillaService = VanillaDataService();
  String? _selectedCategory;
  bool _nameError = false;
  bool _isSaving = false;

  final List<Map<String, String>> _categories = [
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
      'emoji': '🔨',
      'description': 'Spitzhacken, Schaufeln',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCategorySelect(String categoryId) async {
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = true;
        _selectedCategory = categoryId;
      });
      return;
    }

    setState(() {
      _nameError = false;
      _selectedCategory = categoryId;
    });

    final category = _categories.firstWhere((c) => c['id'] == categoryId);

    // Check if category has vanilla items
    final vanillaCategoryId = _vanillaService.getCategoryIdByName(category['name']!);

    if (vanillaCategoryId != null) {
      // Show item selection modal
      final selectedItem = await showItemSelectionModal(
        context,
        categoryId: vanillaCategoryId,
        categoryName: category['name']!,
        categoryEmoji: category['emoji']!,
      );

      if (selectedItem != null) {
        // User selected an item, save project with item data
        await _saveProject(categoryId, selectedItem);
      }
      // If selectedItem is null, user cancelled the modal - do nothing
    } else {
      // No vanilla items for this category, save directly
      await _saveProject(categoryId, null);
    }
  }

  Future<void> _saveProject(String categoryId, VanillaItem? baseItem) async {
    setState(() {
      _isSaving = true;
    });

    final category = _categories.firstWhere((c) => c['id'] == categoryId);

    // Build project data
    final Map<String, dynamic> projectData = {
      'categoryId': categoryId,
      'emoji': category['emoji'],
      'description': category['description'],
    };

    // Add base item data if selected
    if (baseItem != null) {
      projectData['baseItem'] = baseItem.toJson();
    }

    final project = Project.create(
      name: _nameController.text.trim(),
      category: category['name']!,
      data: projectData,
    );

    final success = await _projectService.saveProject(project);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      // Show success message
      final itemInfo = baseItem != null ? ' (${baseItem.emoji} ${baseItem.name})' : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ ${category['emoji']} Projekt "${project.name}"$itemInfo erfolgreich erstellt!',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate back to home screen
      Navigator.of(context).pop();
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Fehler beim Speichern des Projekts'),
          backgroundColor: AppColors.error,
        ),
      );
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
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          SizedBox(
            width: AppSizing.touchMinimum,
            height: AppSizing.touchMinimum,
            child: IconButton(
              icon: const Text(
                '←',
                style: TextStyle(
                  fontSize: 28,
                  color: AppColors.text,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
            ),
          ),

          // Title
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.sm),
              const Text(
                'Neues Projekt',
                style: TextStyle(
                  fontSize: AppTypography.xl,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ],
          ),

          // Spacer
          const SizedBox(width: AppSizing.touchMinimum),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Project Name Input
          _buildProjectNameSection(),

          const SizedBox(height: AppSpacing.xxl),

          // Category Selection
          _buildCategorySection(),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildProjectNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📝 Projekt-Name',
          style: TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _nameController,
          style: const TextStyle(
            fontSize: AppTypography.md,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: 'z.B. Super Schwert Pack',
            hintStyle: TextStyle(
              fontSize: AppTypography.md,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: BorderSide(
                color: _nameError ? AppColors.error : AppColors.border,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: BorderSide(
                color: _nameError ? AppColors.error : AppColors.border,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: BorderSide(
                color: _nameError ? AppColors.error : AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
          ),
          onChanged: (text) {
            if (text.trim().isNotEmpty) {
              setState(() {
                _nameError = false;
              });
            }
          },
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
        ),
        if (_nameError) ...[
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Bitte gib einen Namen ein!',
            style: TextStyle(
              fontSize: AppTypography.sm,
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎯 Was möchtest du erstellen?',
          style: TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildCategoryGrid(),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.1,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final isSelected = _selectedCategory == category['id'];

        return GestureDetector(
          onTap: () => _handleCategorySelect(category['id']!),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category['emoji']!,
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  category['name']!,
                  style: const TextStyle(
                    fontSize: AppTypography.md,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  category['description']!,
                  style: TextStyle(
                    fontSize: AppTypography.xs,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
