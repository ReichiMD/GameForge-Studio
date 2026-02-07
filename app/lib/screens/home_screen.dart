import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../services/project_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onCreateProject;

  const HomeScreen({
    super.key,
    this.onCreateProject,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProjectService _projectService = ProjectService();
  List<Project> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
    });

    final projects = await _projectService.getProjects();

    if (mounted) {
      setState(() {
        _projects = projects;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleCreateProject() async {
    if (widget.onCreateProject != null) {
      widget.onCreateProject!();
      // Reload projects when returning from create screen
      await Future.delayed(const Duration(milliseconds: 500));
      _loadProjects();
    }
  }

  Future<void> _deleteProject(String projectId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Projekt löschen?',
          style: TextStyle(color: AppColors.text),
        ),
        content: const Text(
          'Möchtest du dieses Projekt wirklich löschen?',
          style: TextStyle(color: AppColors.textSecondary),
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
      final success = await _projectService.deleteProject(projectId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Projekt gelöscht'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadProjects();
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
              child: _buildContent(context),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Burger Menu Button
          SizedBox(
            width: AppSizing.touchMinimum,
            height: AppSizing.touchMinimum,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBurgerLine(),
                const SizedBox(height: 5),
                _buildBurgerLine(),
                const SizedBox(height: 5),
                _buildBurgerLine(),
              ],
            ),
          ),

          // Title
          Row(
            children: [
              const Text('⚒️', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.sm),
              const Text(
                'GameForge',
                style: TextStyle(
                  fontSize: AppTypography.xl,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                ),
                child: const Text(
                  'Minecraft',
                  style: TextStyle(
                    fontSize: AppTypography.xs,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
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

  Widget _buildBurgerLine() {
    return Container(
      width: 24,
      height: 3,
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // New Project Button
          _buildNewProjectButton(),

          const SizedBox(height: AppSpacing.xxl),

          // Projects Section
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xxl),
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            )
          else if (_projects.isEmpty)
            _buildEmptyState()
          else
            _buildProjectsList(),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildNewProjectButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleCreateProject,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.text,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✨', style: TextStyle(fontSize: 28)),
            SizedBox(width: AppSpacing.md),
            Text(
              'Neues Projekt',
              style: TextStyle(
                fontSize: AppTypography.lg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          const Text(
            '📦',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Noch keine Projekte',
            style: TextStyle(
              fontSize: AppTypography.lg,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Erstelle dein erstes Projekt!',
            style: TextStyle(
              fontSize: AppTypography.md,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '📋 Deine Projekte',
              style: TextStyle(
                fontSize: AppTypography.md,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            Text(
              '${_projects.length}',
              style: TextStyle(
                fontSize: AppTypography.md,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ..._projects.map((project) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildProjectCard(project),
            )),
      ],
    );
  }

  Widget _buildProjectCard(Project project) {
    final emoji = project.data['emoji'] as String? ?? project.categoryIcon;
    final createdDate = _formatDate(project.createdAt);

    return Dismissible(
      key: Key(project.id),
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
            Text('🗑️', style: TextStyle(fontSize: 32)),
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
        await _deleteProject(project.id);
        return false; // We handle deletion ourselves
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: AppSizing.touchIdeal,
              height: AppSizing.touchIdeal,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 32)),
            ),

            const SizedBox(width: AppSpacing.lg),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: AppTypography.md,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius:
                              BorderRadius.circular(AppSizing.radiusSmall),
                        ),
                        child: Text(
                          project.category,
                          style: const TextStyle(
                            fontSize: AppTypography.xs,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        createdDate,
                        style: TextStyle(
                          fontSize: AppTypography.xs,
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Heute';
    } else if (difference.inDays == 1) {
      return 'Gestern';
    } else if (difference.inDays < 7) {
      return 'vor ${difference.inDays} Tagen';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
