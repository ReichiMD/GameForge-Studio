import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../models/project_item.dart';
import '../services/project_service.dart';
import '../services/addon_builder_service.dart';
import '../widgets/item_texture_widget.dart';
import 'category_selection_screen.dart';
import 'workshop_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final ProjectService _projectService = ProjectService();
  late Project _currentProject;

  @override
  void initState() {
    super.initState();
    _currentProject = widget.project;
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

  Future<void> _handleAddItem() async {
    // Navigate to category selection
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(project: _currentProject),
      ),
    );

    // Reload project if item was added
    if (result == true) {
      await _loadProject();
    }
  }

  Future<void> _handleDeleteItem(ProjectItem item) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          '🗑️ Item löschen?',
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
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Delete item from project
    final updatedProject = _currentProject.removeItem(item.id);
    final success = await _projectService.updateProject(updatedProject);

    if (success && mounted) {
      setState(() {
        _currentProject = updatedProject;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ "${item.name}" gelöscht'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleExportProject() async {
    if (_currentProject.items.isEmpty) return;

    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⏳ Erstelle Addon...'),
            backgroundColor: AppColors.info,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Build .mcaddon file
      final addonBytes = await AddonBuilderService.buildAddon(_currentProject);
      final filename = AddonBuilderService.getAddonFilename(_currentProject);

      // Save to Downloads using FileSaver (works on all Android versions without permissions)
      await FileSaver.instance.saveFile(
        name: filename.replaceAll('.mcaddon', ''),
        bytes: addonBytes,
        ext: 'mcaddon',
        mimeType: MimeType.other,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Gespeichert in Downloads/$filename'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Fehler: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
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
    );
  }

  Widget _buildHeader() {
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
          Text(
            _currentProject.emoji,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentProject.name,
                  style: const TextStyle(
                    fontSize: AppTypography.xl,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  '${_currentProject.itemCount} ${_currentProject.itemCount == 1 ? 'Item' : 'Items'}',
                  style: TextStyle(
                    fontSize: AppTypography.sm,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Export Button
          if (_currentProject.items.isNotEmpty)
            GestureDetector(
              onTap: _handleExportProject,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info,
                  borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                ),
                child: const Text(
                  '📤',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_currentProject.items.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: _currentProject.items.length + 1, // +1 for Add button
      itemBuilder: (context, index) {
        if (index == _currentProject.items.length) {
          return _buildAddItemButton();
        }

        final item = _currentProject.items[index];
        return _buildItemCard(item, index);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              alignment: Alignment.center,
              child: const Text('📦', style: TextStyle(fontSize: 64)),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Keine Items',
              style: TextStyle(
                fontSize: AppTypography.xl,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Füge dein erstes Item hinzu!',
              style: TextStyle(
                fontSize: AppTypography.md,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildAddItemButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddItemButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleAddItem,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('➕', style: TextStyle(fontSize: 28)),
            SizedBox(width: AppSpacing.md),
            Text(
              'Item hinzufügen',
              style: TextStyle(
                fontSize: AppTypography.lg,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(ProjectItem item, int index) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        child: const Text(
          '🗑️',
          style: TextStyle(fontSize: 32),
        ),
      ),
      confirmDismiss: (direction) async {
        await _handleDeleteItem(item);
        return false; // We handle deletion manually
      },
      child: GestureDetector(
        onTap: () async {
          // Navigate to item editor
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkshopScreen(
                project: _currentProject,
                item: item,
                isNewItem: false,
              ),
            ),
          );

          // Reload project if item was updated
          if (result == true) {
            await _loadProject();
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: Row(
            children: [
              // Item Icon with texture or emoji
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                ),
                alignment: Alignment.center,
                child: item.baseItem != null
                    ? ItemTextureWidget(
                        item: item.baseItem!,
                        size: 48,
                      )
                    : Text(item.emoji, style: const TextStyle(fontSize: 32)),
              ),
              const SizedBox(width: AppSpacing.lg),
              // Item Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: AppTypography.lg,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          item.categoryIcon,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          item.category,
                          style: TextStyle(
                            fontSize: AppTypography.sm,
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                        if (item.baseItem != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
                            ),
                            child: Text(
                              item.baseItem!.name,
                              style: const TextStyle(
                                fontSize: AppTypography.xs,
                                color: AppColors.info,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
