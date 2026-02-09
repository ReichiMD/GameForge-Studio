import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../models/project_item.dart';
import '../services/project_service.dart';
import '../services/minecraft_export_service.dart';
import '../widgets/item_texture_widget.dart';

class WorkshopScreen extends StatefulWidget {
  final Project project;
  final ProjectItem item;
  final bool isNewItem;

  const WorkshopScreen({
    super.key,
    required this.project,
    required this.item,
    this.isNewItem = false,
  });

  @override
  State<WorkshopScreen> createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  final ProjectService _projectService = ProjectService();

  // Item State
  late String _itemName;
  late String _itemEmoji;
  late String _category;

  // Stats
  late double _damage;
  late double _durability;
  late double _attackSpeed;
  late double _armor;
  late double _armorToughness;
  late double _miningSpeed;

  // Effects
  late bool _fireEffect;
  late bool _glowEffect;

  @override
  void initState() {
    super.initState();
    _loadItemData();
  }

  void _loadItemData() {
    final item = widget.item;

    setState(() {
      _itemName = item.name;
      _itemEmoji = item.emoji;
      _category = item.category;

      // Load stats
      _damage = (item.customStats['damage'] as num?)?.toDouble() ?? 1.0;
      _durability = (item.customStats['durability'] as num?)?.toDouble() ?? 100.0;
      _attackSpeed = (item.customStats['attack_speed'] as num?)?.toDouble() ?? 1.0;
      _armor = (item.customStats['armor'] as num?)?.toDouble() ?? 0.0;
      _armorToughness = (item.customStats['armor_toughness'] as num?)?.toDouble() ?? 0.0;
      _miningSpeed = (item.customStats['mining_speed'] as num?)?.toDouble() ?? 1.0;

      // Load effects
      _fireEffect = item.effects['fire'] as bool? ?? false;
      _glowEffect = item.effects['glow'] as bool? ?? false;
    });
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
          const Text('🔧', style: TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          Text(
            widget.isNewItem ? 'Neues Item' : 'Item bearbeiten',
            style: const TextStyle(
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

          if (!widget.isNewItem) ...[
            const SizedBox(height: AppSpacing.lg),
            // Export Button
            _buildExportButton(),
          ],

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
          // Item Icon with texture or emoji
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
            ),
            alignment: Alignment.center,
            child: widget.item.baseItem != null
                ? ItemTextureWidget(
                    item: widget.item.baseItem!,
                    size: 80,
                  )
                : Text(
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
          if (widget.item.baseItem != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Basiert auf: ${widget.item.baseItem!.name}',
              style: TextStyle(
                fontSize: AppTypography.sm,
                color: AppColors.info.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _category,
              style: TextStyle(
                fontSize: AppTypography.sm,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
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
        const SizedBox(height: AppSpacing.lg),
        _buildStatSlider(
          label: 'Attack Speed',
          emoji: '⚡',
          value: _attackSpeed,
          minValue: 0.5,
          maxValue: 4.0,
          divisions: 35,
          decimals: 1,
          onChanged: (value) {
            setState(() {
              _attackSpeed = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildStatSlider(
          label: 'Armor',
          emoji: '🛡️',
          value: _armor,
          minValue: 0,
          maxValue: 20,
          onChanged: (value) {
            setState(() {
              _armor = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildStatSlider(
          label: 'Armor Toughness',
          emoji: '💪',
          value: _armorToughness,
          minValue: 0,
          maxValue: 12,
          onChanged: (value) {
            setState(() {
              _armorToughness = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildStatSlider(
          label: 'Mining Speed',
          emoji: '⛏️',
          value: _miningSpeed,
          minValue: 0.5,
          maxValue: 12.0,
          divisions: 115,
          decimals: 1,
          onChanged: (value) {
            setState(() {
              _miningSpeed = value;
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
    int? divisions,
    int decimals = 0,
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
                  decimals > 0 ? value.toStringAsFixed(decimals) : value.toInt().toString(),
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
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          // Min/Max Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                decimals > 0 ? minValue.toStringAsFixed(decimals) : minValue.toInt().toString(),
                style: TextStyle(
                  fontSize: AppTypography.xs,
                  color: AppColors.textSecondary.withOpacity(0.6),
                ),
              ),
              Text(
                decimals > 0 ? maxValue.toStringAsFixed(decimals) : maxValue.toInt().toString(),
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

  Future<void> _handleSave() async {
    // Create updated item
    final updatedItem = widget.item.copyWith(
      name: _itemName,
      emoji: _itemEmoji,
      customStats: {
        'damage': _damage,
        'durability': _durability,
        'attack_speed': _attackSpeed,
        'armor': _armor,
        'armor_toughness': _armorToughness,
        'mining_speed': _miningSpeed,
      },
      effects: {
        'fire': _fireEffect,
        'glow': _glowEffect,
      },
    );

    // Update or add item to project
    final Project updatedProject;
    if (widget.isNewItem) {
      updatedProject = widget.project.addItem(updatedItem);
    } else {
      updatedProject = widget.project.updateItem(updatedItem);
    }

    final success = await _projectService.updateProject(updatedProject);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ "$_itemName" gespeichert!',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );

      // Return true to indicate success
      Navigator.of(context).pop(true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '❌ Fehler beim Speichern',
          ),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildExportButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleExport,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.info,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📤', style: TextStyle(fontSize: 28)),
            SizedBox(width: AppSpacing.md),
            Text(
              'Als Minecraft Addon exportieren',
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

  Future<void> _handleExport() async {
    try {
      // Create temporary project with just this item for export
      final tempProject = Project.create(
        name: _itemName,
        items: [widget.item.copyWith(name: _itemName)],
      );

      // Generate Minecraft JSON
      final minecraftJson = MinecraftExportService.exportToMinecraftJSON(tempProject);
      final filename = MinecraftExportService.getExportFilename(tempProject);

      // Share the JSON file
      await Share.share(
        minecraftJson,
        subject: 'Minecraft Addon: $_itemName',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ "$_itemName" als $filename exportiert!',
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Fehler beim Exportieren: $e',
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
