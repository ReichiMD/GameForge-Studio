import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../services/project_service.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _nameError = true;
      });
      return;
    }

    setState(() {
      _nameError = false;
      _isSaving = true;
    });

    final project = Project.create(name: name);
    final success = await _projectService.saveProject(project);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Projekt "$name" erstellt!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Fehler beim Erstellen'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
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
          const Text('📝', style: TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
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
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),

          // Project Icon
          Center(
            child: Container(
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
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Name Input
          const Text(
            'Projekt-Name',
            style: TextStyle(
              fontSize: AppTypography.lg,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameController,
            autofocus: true,
            style: const TextStyle(
              fontSize: AppTypography.lg,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              hintText: 'z.B. Meine coolen Items',
              hintStyle: TextStyle(
                fontSize: AppTypography.lg,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                borderSide: BorderSide(
                  color: _nameError ? AppColors.error : AppColors.border,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                borderSide: BorderSide(
                  color: _nameError ? AppColors.error : AppColors.border,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                borderSide: BorderSide(
                  color: _nameError ? AppColors.error : AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
            ),
            onChanged: (value) {
              if (_nameError && value.trim().isNotEmpty) {
                setState(() {
                  _nameError = false;
                });
              }
            },
            onSubmitted: (_) => _handleSave(),
          ),

          if (_nameError) ...[
            const SizedBox(height: AppSpacing.sm),
            const Text(
              '⚠️ Bitte gib einen Namen ein',
              style: TextStyle(
                fontSize: AppTypography.sm,
                color: AppColors.error,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.md),
          Text(
            'Du kannst später Items zu deinem Projekt hinzufügen',
            style: TextStyle(
              fontSize: AppTypography.sm,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Save Button
          Container(
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
              onPressed: _isSaving ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('✅', style: TextStyle(fontSize: 28)),
                        SizedBox(width: AppSpacing.md),
                        Text(
                          'Projekt erstellen',
                          style: TextStyle(
                            fontSize: AppTypography.lg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
