import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback? onLogout;

  const SettingsScreen({
    super.key,
    this.onLogout,
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
        children: [
          const Text('⚙️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          const Text(
            'Einstellungen',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Placeholder for settings
          Center(
            child: Column(
              children: [
                Text(
                  '⚙️',
                  style: TextStyle(
                    fontSize: 80,
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Einstellungen',
                  style: TextStyle(
                    fontSize: AppTypography.xl,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Hier findest du bald Einstellungen\nund dein GitHub Token Management',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppTypography.md,
                    color: AppColors.textSecondary.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl * 2),

          // Logout Button
          if (onLogout != null)
            ElevatedButton(
              onPressed: onLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.text,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🚪', style: TextStyle(fontSize: 24)),
                  SizedBox(width: AppSpacing.md),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: AppTypography.md,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
