import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onCreateProject;

  const HomeScreen({
    super.key,
    this.onCreateProject,
  });

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

          // Demo Projects Section
          const Text(
            '📋 Beispiel-Projekte',
            style: TextStyle(
              fontSize: AppTypography.md,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _buildDemoProjectCard(
            emoji: '⚔️',
            name: 'Super Schwert Pack',
            items: 3,
            status: 'ready',
          ),
          const SizedBox(height: AppSpacing.md),

          _buildDemoProjectCard(
            emoji: '🛡️',
            name: 'Coole Rüstungen',
            items: 5,
            status: 'draft',
          ),
          const SizedBox(height: AppSpacing.md),

          _buildDemoProjectCard(
            emoji: '🧪',
            name: 'Magische Tränke',
            items: 2,
            status: 'draft',
          ),

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
        onPressed: onCreateProject,
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

  Widget _buildDemoProjectCard({
    required String emoji,
    required String name,
    required int items,
    required String status,
  }) {
    final bool isReady = status == 'ready';

    return Container(
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
                  name,
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
                        borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
                      ),
                      child: Text(
                        '$items Items',
                        style: const TextStyle(
                          fontSize: AppTypography.xs,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isReady
                            ? AppColors.statusReady
                            : AppColors.statusDraft,
                        borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
                      ),
                      child: Text(
                        isReady ? '✓ Fertig' : '⏳ Entwurf',
                        style: TextStyle(
                          fontSize: AppTypography.xs,
                          fontWeight: FontWeight.w600,
                          color: isReady
                              ? AppColors.statusReadyText
                              : AppColors.statusDraftText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
