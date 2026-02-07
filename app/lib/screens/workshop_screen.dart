import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class WorkshopScreen extends StatelessWidget {
  const WorkshopScreen({super.key});

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
          const Text('🔧', style: TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          const Text(
            'Workshop',
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🔧',
            style: TextStyle(
              fontSize: 80,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Workshop',
            style: TextStyle(
              fontSize: AppTypography.xl,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Hier kannst du bald Items erstellen\nund bearbeiten',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTypography.md,
              color: AppColors.textSecondary.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
