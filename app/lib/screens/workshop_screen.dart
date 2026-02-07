import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class WorkshopScreen extends StatefulWidget {
  const WorkshopScreen({super.key});

  @override
  State<WorkshopScreen> createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  // Demo Item State
  String _itemName = 'Mein Super Schwert';
  String _itemEmoji = '⚔️';
  double _damage = 7.0;
  double _durability = 1561.0;
  bool _fireEffect = true;
  bool _glowEffect = false;

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Item Preview
          _buildItemPreview(),

          const SizedBox(height: AppSpacing.xxl),

          // Item Name Input
          _buildItemNameInput(),

          const SizedBox(height: AppSpacing.xxl),

          // Stats Section
          _buildStatsSection(),

          const SizedBox(height: AppSpacing.xxl),

          // Effects Section
          _buildEffectsSection(),

          const SizedBox(height: AppSpacing.xxl),

          // Save Button
          _buildSaveButton(),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildItemPreview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Item Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
            ),
            alignment: Alignment.center,
            child: Text(
              _itemEmoji,
              style: const TextStyle(fontSize: 64),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            _itemName,
            style: const TextStyle(
              fontSize: AppTypography.xl,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Diamond Sword (Demo)',
            style: TextStyle(
              fontSize: AppTypography.sm,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📝 Item-Name',
          style: TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: TextEditingController(text: _itemName),
          onChanged: (value) {
            setState(() {
              _itemName = value;
            });
          },
          style: const TextStyle(
            fontSize: AppTypography.md,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: 'z.B. Flammen-Schwert',
            hintStyle: TextStyle(
              fontSize: AppTypography.md,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚡ Item-Stats',
          style: TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildStatSlider(
          label: 'Damage',
          emoji: '⚔️',
          value: _damage,
          minValue: 1,
          maxValue: 20,
          onChanged: (value) {
            setState(() {
              _damage = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildStatSlider(
          label: 'Durability',
          emoji: '🛡️',
          value: _durability,
          minValue: 100,
          maxValue: 3000,
          onChanged: (value) {
            setState(() {
              _durability = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStatSlider({
    required String label,
    required String emoji,
    required double value,
    required double minValue,
    required double maxValue,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label and Value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$emoji $label',
                style: const TextStyle(
                  fontSize: AppTypography.md,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
                ),
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: AppTypography.md,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceLight,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: value,
              min: minValue,
              max: maxValue,
              onChanged: onChanged,
            ),
          ),
          // Min/Max Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minValue.toInt().toString(),
                style: TextStyle(
                  fontSize: AppTypography.xs,
                  color: AppColors.textSecondary.withOpacity(0.6),
                ),
              ),
              Text(
                maxValue.toInt().toString(),
                style: TextStyle(
                  fontSize: AppTypography.xs,
                  color: AppColors.textSecondary.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEffectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '✨ Effekte',
          style: TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildToggle(
          label: 'Feuer-Effekt',
          emoji: '🔥',
          value: _fireEffect,
          onChanged: (value) {
            setState(() {
              _fireEffect = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildToggle(
          label: 'Leuchten',
          emoji: '✨',
          value: _glowEffect,
          onChanged: (value) {
            setState(() {
              _glowEffect = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildToggle({
    required String label,
    required String emoji,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$emoji $label',
              style: const TextStyle(
                fontSize: AppTypography.md,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            Container(
              width: 56,
              height: 32,
              decoration: BoxDecoration(
                color: value ? AppColors.primary : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
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
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('💾', style: TextStyle(fontSize: 28)),
            SizedBox(width: AppSpacing.md),
            Text(
              'Item speichern',
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

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ "$_itemName" gespeichert! (Damage: ${_damage.toInt()}, Durability: ${_durability.toInt()})',
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
