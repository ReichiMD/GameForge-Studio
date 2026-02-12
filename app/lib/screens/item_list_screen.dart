import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../models/project_item.dart';
import '../models/vanilla_item.dart';
import '../services/vanilla_data_service.dart';
import '../services/project_service.dart';
import '../widgets/item_texture_widget.dart';
import 'workshop_screen.dart';

class ItemListScreen extends StatefulWidget {
  final Project project;
  final Map<String, String> category;

  const ItemListScreen({
    super.key,
    required this.project,
    required this.category,
  });

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final VanillaDataService _vanillaService = VanillaDataService();
  final ProjectService _projectService = ProjectService();
  List<VanillaItem> _items = [];
  List<String> _customIconUrls = []; // Custom Icons
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    await _vanillaService.loadData();
    final categoryId = _vanillaService.getCategoryIdByName(widget.category['name']!);

    if (categoryId != null) {
      final items = await _vanillaService.getItemsByCategory(categoryId);

      // Custom Icons laden (nur für Waffen)
      if (categoryId == 'weapons') {
        await _loadCustomIcons();
      }

      setState(() {
        _items = items;
        _isLoading = false;
      });
    } else {
      // No vanilla items for this category - create custom item directly
      await _handleCreateCustomItem();
    }
  }

  Future<void> _loadCustomIcons() async {
    try {
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
        _customIconUrls = urls;
      }
    } catch (e) {
      // Fehler beim Laden - ignorieren
      _customIconUrls = [];
    }
  }

  Future<void> _handleCreateCustomItem() async {
    // Create a new item without base item
    final newItem = ProjectItem.create(
      name: 'Neues ${widget.category['name']} Item',
      category: widget.category['name']!,
      emoji: widget.category['emoji']!,
    );

    // Navigate to editor
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkshopScreen(
          project: widget.project,
          item: newItem,
          isNewItem: true,
        ),
      ),
    );

    if (result == true && mounted) {
      Navigator.of(context).pop(true); // Pop back to ProjectDetailScreen
    } else if (mounted) {
      Navigator.of(context).pop(); // Just close this screen
    }
  }

  Future<void> _handleItemSelect(VanillaItem vanillaItem) async {
    // Create new ProjectItem based on VanillaItem
    final newItem = ProjectItem.create(
      name: vanillaItem.name,
      category: widget.category['name']!,
      emoji: vanillaItem.emoji,
      baseItem: vanillaItem,
      customStats: {
        'damage': (vanillaItem.getStat('attack_damage') as num?)?.toDouble() ?? 1.0,
        'durability': (vanillaItem.getStat('durability') as num?)?.toDouble() ?? 100.0,
        'attack_speed': (vanillaItem.getStat('attack_speed') as num?)?.toDouble() ?? 1.0,
        'armor': (vanillaItem.getStat('armor') as num?)?.toDouble() ?? 0.0,
        'armor_toughness': (vanillaItem.getStat('armor_toughness') as num?)?.toDouble() ?? 0.0,
        'mining_speed': (vanillaItem.getStat('mining_speed') as num?)?.toDouble() ?? 1.0,
      },
    );

    // Navigate to workshop screen
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkshopScreen(
          project: widget.project,
          item: newItem,
          isNewItem: true,
        ),
      ),
    );

    // If item was saved, pop back to ProjectDetailScreen
    if (result == true && mounted) {
      Navigator.of(context).pop(true);
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
          Text(
            widget.category['emoji']!,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category['name']!,
                  style: const TextStyle(
                    fontSize: AppTypography.xl,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                if (!_isLoading)
                  Text(
                    '${_items.length} ${_items.length == 1 ? 'Item' : 'Items'}',
                    style: TextStyle(
                      fontSize: AppTypography.sm,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_items.isEmpty) {
      return _buildEmptyState();
    }

    final totalItems = _items.length + _customIconUrls.length;

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 Spalten statt 2 für kleinere Karten
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.0, // Quadratisch
      ),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        // Erst Vanilla Items, dann Custom Icons
        if (index < _items.length) {
          return _buildItemCard(_items[index], null);
        } else {
          final customIconUrl = _customIconUrls[index - _items.length];
          return _buildCustomIconCard(customIconUrl);
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.category['emoji']!,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Keine Vanilla Items',
              style: TextStyle(
                fontSize: AppTypography.xl,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Für diese Kategorie gibt es noch keine Basis-Items.\nDu kannst trotzdem ein eigenes Item erstellen!',
              style: TextStyle(
                fontSize: AppTypography.md,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(VanillaItem item, String? customIconUrl) {
    return GestureDetector(
      onTap: () => _handleItemSelect(item),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: Center(
          child: ItemTextureWidget(
            item: item,
            size: 64, // 20% kleiner für kompaktere Ansicht
          ),
        ),
      ),
    );
  }

  Widget _buildCustomIconCard(String customIconUrl) {
    return GestureDetector(
      onTap: () => _handleCustomIconSelect(customIconUrl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: customIconUrl,
            width: 64,
            height: 64,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.none,
            placeholder: (context, url) => const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.broken_image,
              color: AppColors.error,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCustomIconSelect(String iconUrl) async {
    // Erstelle Item mit Custom Icon
    final fileName = iconUrl.split('/').last.replaceAll('.png', '');
    final newItem = ProjectItem.create(
      name: 'Custom $fileName',
      category: widget.category['name']!,
      emoji: '⚔️',
      customIconUrl: iconUrl,
    );

    // Navigate to editor
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkshopScreen(
          project: widget.project,
          item: newItem,
          isNewItem: true,
        ),
      ),
    );

    // If item was saved, pop back to ProjectDetailScreen
    if (result == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

}
