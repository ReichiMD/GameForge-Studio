import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../models/vanilla_item.dart';
import '../services/project_service.dart';
import '../services/minecraft_export_service.dart';

class WorkshopScreen extends StatefulWidget {
  final Project? project;

  const WorkshopScreen({super.key, this.project});

  @override
  State<WorkshopScreen> createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  final ProjectService _projectService = ProjectService();

  // Item State
  String _itemName = 'Mein Super Schwert';
  String _itemEmoji = '⚔️';
  String? _baseItemName;

  // Stats
  double _damage = 7.0;
  double _durability = 1561.0;
  double _attackSpeed = 1.6;
  double _armor = 0.0;
  double _armorToughness = 0.0;
  double _miningSpeed = 1.0;

  // Effects
  bool _fireEffect = true;
  bool _glowEffect = false;

  // Original project reference
  VanillaItem? _baseItem;

  @override
  void initState() {
    super.initState();
    _loadProjectData();
  }

  void _loadProjectData() {
    if (widget.project == null) return;

    final project = widget.project!;

    // Load basic info
    setState(() {
      _itemName = project.name;
      _itemEmoji = project.data['emoji'] as String? ?? project.categoryIcon;
    });

    // Load base item data
    final baseItem = project.baseItem;
    if (baseItem != null) {
      setState(() {
        _baseItem = baseItem;
        _baseItemName = baseItem.name;

        // Load stats from base item
        _damage = (baseItem.getStat('attack_damage') as num?)?.toDouble() ?? _damage;
        _durability = (baseItem.getStat('durability') as num?)?.toDouble() ?? _durability;
        _attackSpeed = (baseItem.getStat('attack_speed') as num?)?.toDouble() ?? _attackSpeed;
        _armor = (baseItem.getStat('armor') as num?)?.toDouble() ?? _armor;
        _armorToughness = (baseItem.getStat('armor_toughness') as num?)?.toDouble() ?? _armorToughness;
        _miningSpeed = (baseItem.getStat('mining_speed') as num?)?.toDouble() ?? _miningSpeed;
      });
    }

    // Load custom modifications if any
    final data = project.data;
    if (data['customStats'] != null) {
      final customStats = data['customStats'] as Map<String, dynamic>;
      setState(() {
        _damage = (customStats['damage'] as num?)?.toDouble() ?? _damage;
        _durability = (customStats['durability'] as num?)?.toDouble() ?? _durability;
        _attackSpeed = (customStats['attack_speed'] as num?)?.toDouble() ?? _attackSpeed;
        _armor = (customStats['armor'] as num?)?.toDouble() ?? _armor;
        _armorToughness = (customStats['armor_toughness'] as num?)?.toDouble() ?? _armorToughness;
        _miningSpeed = (customStats['mining_speed'] as num?)?.toDouble() ?? _miningSpeed;
      });
    }

    if (data['effects'] != null) {
      final effects = data['effects'] as Map<String, dynamic>;
      setState(() {
        _fireEffect = effects['fire'] as bool? ?? _fireEffect;
        _glowEffect = effects['glow'] as bool? ?? _glowEffect;
      });
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
    final bool isEditMode = widget.project != null;

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
          if (isEditMode) ...[
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
          ],
          const Text('🔧', style: TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          Text(
            isEditMode ? 'Bearbeiten' : 'Workshop',
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

          const SizedBox(height: AppSpacing.lg),

          // Export Button
          _buildExportButton(),

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
          if (_baseItemName != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Basiert auf: $_baseItemName',
              style: TextStyle(
                fontSize: AppTypography.sm,
                color: AppColors.info.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.project != null ? widget.project!.category : 'Demo',
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
    if (widget.project == null) {
      // Demo mode - just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ "$_itemName" gespeichert! (Demo-Modus)',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Save project with updated data
    final updatedProject = widget.project!.copyWith(
      name: _itemName,
      data: {
        ...widget.project!.data,
        'emoji': _itemEmoji,
        'customStats': {
          'damage': _damage,
          'durability': _durability,
          'attack_speed': _attackSpeed,
          'armor': _armor,
          'armor_toughness': _armorToughness,
          'mining_speed': _miningSpeed,
        },
        'effects': {
          'fire': _fireEffect,
          'glow': _glowEffect,
        },
      },
    );

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

      // Close workshop and return to home
      Navigator.of(context).pop();
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
    // Only show export button when editing an existing project
    if (widget.project == null) {
      return const SizedBox.shrink();
    }

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
    if (widget.project == null) return;

    try {
      // Create updated project with current stats before exporting
      final currentProject = widget.project!.copyWith(
        name: _itemName,
        data: {
          ...widget.project!.data,
          'emoji': _itemEmoji,
          'customStats': {
            'damage': _damage,
            'durability': _durability,
            'attack_speed': _attackSpeed,
            'armor': _armor,
            'armor_toughness': _armorToughness,
            'mining_speed': _miningSpeed,
          },
          'effects': {
            'fire': _fireEffect,
            'glow': _glowEffect,
          },
        },
      );

      // Generate Minecraft JSON
      final minecraftJson = MinecraftExportService.exportToMinecraftJSON(currentProject);
      final filename = MinecraftExportService.getExportFilename(currentProject);

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
