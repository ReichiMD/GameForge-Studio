import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../services/project_service.dart';
import '../widgets/item_selection_modal.dart';
import 'workshop_screen.dart';

class ProjectItemsScreen extends StatefulWidget {
  final Project project;

  const ProjectItemsScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectItemsScreen> createState() => _ProjectItemsScreenState();
}

class _ProjectItemsScreenState extends State<ProjectItemsScreen> {
  final ProjectService _projectService = ProjectService();
  late Project _currentProject;

  @override
  void initState() {
    super.initState();
    _currentProject = widget.project;
  }

  Future<void> _openItemEditor(ProjectItem item) async {
    // Navigate to WorkshopScreen with the project and item
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkshopScreen(
          project: _currentProject,
          projectItem: item,
        ),
      ),
    );

    // Reload project when returning
    _loadProject();
  }

  Future<void> _loadProject() async {
    final project = await _projectService.getProjectById(_currentProject.id);
    if (project != null && mounted) {
      setState(() {
        _currentProject = project;
      });
    }
  }

  void _showAddItemModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ItemSelectionModal(
        categoryId: _currentProject.category.toLowerCase(),
        categoryName: _currentProject.category,
        categoryEmoji: _currentProject.categoryIcon,
        onItemSelected: _addItemToProject,
      ),
    );
  }

  Future<void> _addItemToProject(dynamic vanillaItem) async {
    final newItem = ProjectItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: vanillaItem.name,
      baseItemKey: vanillaItem.key,
    );

    final updatedProject = _currentProject.copyWith(
      items: [..._currentProject.items, newItem],
      updatedAt: DateTime.now(),
    );

    final saved = await _projectService.saveProject(updatedProject);
    if (saved && mounted) {
      setState(() {
        _currentProject = updatedProject;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Item hinzugefügt'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _deleteItem(ProjectItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Item löschen?',
          style: TextStyle(color: AppColors.text),
        ),
        content: Text(
          'Möchtest du "${item.name}" wirklich löschen?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final updatedItems = _currentProject.items
          .where((i) => i.id != item.id)
          .toList();

      final updatedProject = _currentProject.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );

      final saved = await _projectService.saveProject(updatedProject);
      if (saved && mounted) {
        setState(() {
          _currentProject = updatedProject;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Item gelöscht'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemModal,
        backgroundColor: AppColors.primary,
        label: const Text('Item hinzufügen'),
        icon: const Text('➕', style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: AppSizing.touchMinimum,
                  height: AppSizing.touchMinimum,
                  alignment: Alignment.center,
                  child: const Text('←', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentProject.name,
                      style: const TextStyle(
                        fontSize: AppTypography.lg,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      '${_currentProject.items.length} ${_currentProject.items.length == 1 ? 'Item' : 'Items'}',
                      style: TextStyle(
                        fontSize: AppTypography.sm,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_currentProject.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📭', style: TextStyle(fontSize: 64)),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Noch keine Items',
              style: TextStyle(
                fontSize: AppTypography.lg,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Drücke ➕ um Items hinzuzufügen!',
              style: TextStyle(
                fontSize: AppTypography.md,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _currentProject.items.length,
      itemBuilder: (context, index) {
        final item = _currentProject.items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _buildItemCard(item),
        );
      },
    );
  }

  Widget _buildItemCard(ProjectItem item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🗑️', style: TextStyle(fontSize: 28)),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Löschen',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        await _deleteItem(item);
        return false;
      },
      child: GestureDetector(
        onTap: () => _openItemEditor(item),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          ),
          child: Row(
            children: [
              Container(
                width: AppSizing.touchIdeal,
                height: AppSizing.touchIdeal,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                ),
                alignment: Alignment.center,
                child: const Text('✨', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: AppTypography.md,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Tippen zum Bearbeiten',
                      style: TextStyle(
                        fontSize: AppTypography.xs,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Text('→', style: TextStyle(fontSize: 20, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
