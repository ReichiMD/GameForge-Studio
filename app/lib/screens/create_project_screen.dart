import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../services/project_service.dart';
import 'project_items_screen.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ProjectService _projectService = ProjectService();
  bool _nameError = false;
  bool _isSaving = false;

  // Default category for new projects
  static const String _defaultCategory = 'Waffen';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateProject() async {
    // Validate project name
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = true;
      });
      return;
    }

    setState(() {
      _nameError = false;
      _isSaving = true;
    });

    // Create project with default category and no items
    final project = Project.create(
      name: _nameController.text.trim(),
      category: _defaultCategory,
      data: {
        'categoryId': 'weapons',
        'emoji': '⚔️',
      },
    );

    final success = await _projectService.saveProject(project);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Projekt "${project.name}" erstellt!',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to ProjectItemsScreen instead of going back
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProjectItemsScreen(project: project),
        ),
      );
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

          // Create Button
          _buildCreateButton(),

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

  Widget _buildCreateButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _handleCreateProject,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          ),
          disabledBackgroundColor: AppColors.success.withOpacity(0.5),
        ),
        child: _isSaving
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Text(
                    'Wird erstellt...',
                    style: TextStyle(
                      fontSize: AppTypography.lg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('✨', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: AppSpacing.md),
                  const Text(
                    'Projekt erstellen',
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
}
