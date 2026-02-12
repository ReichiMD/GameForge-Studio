import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../models/project_item.dart';
import '../services/project_service.dart';
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
  late TextEditingController _nameController;

  // Item State
  late String _itemName;
  late String _itemEmoji;
  late String _category;
  String? _customIconUrl;
  String _nameColor = 'white'; // NEU: Namensfarbe

  // Stats (nur für Nahkampfwaffen!)
  late double _damage;
  late double _durability;
  late double _enchantability;
  late double _movementSpeed;

  // Spezial-Fähigkeiten (NEU!)
  late bool _fireAspect; // Feueraspekt
  late bool _knockback; // Rückstoß
  late bool _shootFireballs; // Feuerbälle schießen

  @override
  void initState() {
    super.initState();
    _loadItemData();
    _nameController = TextEditingController(text: _itemName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _loadItemData() {
    final item = widget.item;

    setState(() {
      _itemName = item.name;
      _itemEmoji = item.emoji;
      _category = item.category;
      _customIconUrl = item.customIconUrl;
      _nameColor = item.customStats['name_color'] as String? ?? 'white';

      // Load stats (Default: Diamant-Werte)
      _damage = (item.customStats['damage'] as num?)?.toDouble() ?? 7.0; // Diamant
      _durability = (item.customStats['durability'] as num?)?.toDouble() ?? 1561.0; // Diamant
      _enchantability = (item.customStats['enchantability'] as num?)?.toDouble() ?? 10.0;
      _movementSpeed = (item.customStats['movement_speed'] as num?)?.toDouble() ?? 0.0;

      // Load abilities
      _fireAspect = item.effects['fire_aspect'] as bool? ?? false;
      _knockback = item.effects['knockback'] as bool? ?? false;
      _shootFireballs = item.effects['shoot_fireballs'] as bool? ?? false;
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
          const Text('⚔️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          Text(
            widget.isNewItem ? 'Neue Waffe' : 'Waffe bearbeiten',
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
          // Item Preview - NUR BILD!
          _buildItemPreview(),

          const SizedBox(height: AppSpacing.xxl),

          // Item Name Input
          _buildItemNameInput(),

          const SizedBox(height: AppSpacing.md),

          // Namensfarbe Picker
          _buildNameColorPicker(),

          const SizedBox(height: AppSpacing.xxl),

          // Stats Section
          _buildStatsSection(),

          const SizedBox(height: AppSpacing.xxl),

          // Abilities Section
          _buildAbilitiesSection(),

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
          // Nur das Bild - tappable zum Ändern
          GestureDetector(
            onTap: _showIconPicker,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                  ),
                  alignment: Alignment.center,
                  child: _customIconUrl != null
                      ? CachedNetworkImage(
                          imageUrl: _customIconUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                          placeholder: (context, url) => const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) => Text(
                            _itemEmoji,
                            style: const TextStyle(fontSize: 64),
                          ),
                        )
                      : widget.item.baseItem != null
                          ? ItemTextureWidget(
                              item: widget.item.baseItem!,
                              size: 80,
                            )
                          : Text(
                              _itemEmoji,
                              style: const TextStyle(fontSize: 64),
                            ),
                ),
                // Edit badge
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tippe auf das Bild zum Ändern',
            style: TextStyle(
              fontSize: AppTypography.xs,
              color: AppColors.textSecondary.withOpacity(0.6),
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
          '📝 Waffen-Name',
          style: TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _nameController,
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

  Widget _buildNameColorPicker() {
    final colors = {
      'white': {'name': 'Weiß', 'color': Colors.white},
      'red': {'name': 'Rot', 'color': Colors.red},
      'gold': {'name': 'Gold', 'color': Colors.amber},
      'yellow': {'name': 'Gelb', 'color': Colors.yellow},
      'green': {'name': 'Grün', 'color': Colors.green},
      'aqua': {'name': 'Türkis', 'color': Colors.cyan},
      'blue': {'name': 'Blau', 'color': Colors.blue},
      'light_purple': {'name': 'Lila', 'color': Colors.purple},
      'dark_purple': {'name': 'Dunkellila', 'color': Colors.deepPurple},
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎨 Namensfarbe',
          style: TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: colors.entries.map((entry) {
              final isSelected = _nameColor == entry.key;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _nameColor = entry.key;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: entry.value['color'] as Color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.white24,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }).toList(),
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
          '⚡ Waffen-Stats',
          style: TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Schaden (1-50)
        _buildStatSlider(
          label: 'Schaden',
          emoji: '⚔️',
          value: _damage,
          minValue: 1,
          maxValue: 50,
          marks: [6.0, 7.0, 8.0], // Eisen, Diamant, Netherit
          markLabels: ['Eisen', 'Diamant', 'Netherit'],
          onChanged: (value) {
            setState(() {
              _damage = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Haltbarkeit
        _buildStatSlider(
          label: 'Haltbarkeit',
          emoji: '🛡️',
          value: _durability,
          minValue: 100,
          maxValue: 3000,
          marks: [250.0, 1561.0, 2031.0], // Eisen, Diamant, Netherit
          markLabels: ['Eisen', 'Diamant', 'Netherit'],
          onChanged: (value) {
            setState(() {
              _durability = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Verzauberbarkeit
        _buildStatSlider(
          label: 'Verzauberbarkeit',
          emoji: '✨',
          value: _enchantability,
          minValue: 1,
          maxValue: 15,
          onChanged: (value) {
            setState(() {
              _enchantability = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Bewegungsgeschwindigkeit
        _buildStatSlider(
          label: 'Bewegungsgeschwindigkeit',
          emoji: '👟',
          value: _movementSpeed,
          minValue: -0.5,
          maxValue: 0.5,
          divisions: 100,
          decimals: 2,
          suffix: '%',
          onChanged: (value) {
            setState(() {
              _movementSpeed = value;
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
    String suffix = '',
    List<double>? marks, // Standard-Markierungen
    List<String>? markLabels, // Labels für Markierungen
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
                  '${decimals > 0 ? value.toStringAsFixed(decimals) : value.toInt().toString()}$suffix',
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
          // Markierungen (falls vorhanden)
          if (marks != null && markLabels != null) ...[
            const SizedBox(height: 4),
            Stack(
              children: [
                for (int i = 0; i < marks.length; i++)
                  Positioned(
                    left: ((marks[i] - minValue) / (maxValue - minValue)) * (MediaQuery.of(context).size.width - 100),
                    child: Column(
                      children: [
                        Container(
                          width: 2,
                          height: 8,
                          color: AppColors.info,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          markLabels[i],
                          style: TextStyle(
                            fontSize: AppTypography.xxs,
                            color: AppColors.info.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
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

  Widget _buildAbilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '✨ Spezial-Fähigkeiten',
          style: TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildAbilityToggle(
          label: 'Feueraspekt',
          emoji: '🔥',
          description: 'Setzt Gegner in Brand',
          value: _fireAspect,
          onChanged: (value) {
            setState(() {
              _fireAspect = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildAbilityToggle(
          label: 'Rückstoß',
          emoji: '💥',
          description: 'Schleudert Gegner zurück',
          value: _knockback,
          onChanged: (value) {
            setState(() {
              _knockback = value;
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildAbilityToggle(
          label: 'Feuerbälle schießen',
          emoji: '🎯',
          description: 'Schießt Feuerbälle beim Rechtsklick',
          value: _shootFireballs,
          onChanged: (value) {
            setState(() {
              _shootFireballs = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAbilityToggle({
    required String label,
    required String emoji,
    required String description,
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
          border: Border.all(
            color: value ? AppColors.primary : AppColors.border,
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: AppTypography.md,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: AppTypography.xs,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ],
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
              'Waffe speichern',
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
      customIconUrl: _customIconUrl,
      clearCustomIcon: _customIconUrl == null,
      customStats: {
        'damage': _damage,
        'durability': _durability,
        'enchantability': _enchantability,
        'movement_speed': _movementSpeed,
        'name_color': _nameColor, // Namensfarbe speichern
      },
      effects: {
        'fire_aspect': _fireAspect,
        'knockback': _knockback,
        'shoot_fireballs': _shootFireballs,
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

  Future<void> _showIconPicker() async {
    showDialog(
      context: context,
      builder: (context) => _IconPickerDialog(
        currentIconUrl: _customIconUrl,
        onIconSelected: (url) {
          setState(() {
            _customIconUrl = url;
          });
        },
        onIconRemoved: () {
          setState(() {
            _customIconUrl = null;
          });
        },
      ),
    );
  }
}

class _IconPickerDialog extends StatefulWidget {
  final String? currentIconUrl;
  final ValueChanged<String> onIconSelected;
  final VoidCallback onIconRemoved;

  const _IconPickerDialog({
    required this.currentIconUrl,
    required this.onIconSelected,
    required this.onIconRemoved,
  });

  @override
  State<_IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<_IconPickerDialog> {
  List<String> _iconUrls = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadIcons();
  }

  Future<void> _loadIcons() async {
    try {
      // Nur Icons aus Schwert-Unterordner laden!
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/ReichiMD/fabrik-library/contents/assets/custom/icons/Schwert'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> files = json.decode(response.body);
        final urls = <String>[];
        for (final file in files) {
          final name = file['name'] as String;
          if (name.toLowerCase().endsWith('.png')) {
            urls.add(file['download_url'] as String);
          }
        }
        if (mounted) {
          setState(() {
            _iconUrls = urls;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _error = 'Fehler beim Laden (${response.statusCode})';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Keine Internetverbindung';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Waffen-Icon auswählen',
              style: TextStyle(
                fontSize: AppTypography.xl,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Wähle ein Custom-Icon für deine Waffe',
              style: TextStyle(
                fontSize: AppTypography.sm,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.xxl),
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    const Text('❌', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _error!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: AppTypography.md,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: _iconUrls.length,
                  itemBuilder: (context, index) {
                    final url = _iconUrls[index];
                    final isSelected = url == widget.currentIconUrl;
                    return GestureDetector(
                      onTap: () {
                        widget.onIconSelected(url);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.broken_image,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                if (widget.currentIconUrl != null)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        widget.onIconRemoved();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Standard-Bild',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: AppTypography.md,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Abbrechen',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppTypography.md,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
