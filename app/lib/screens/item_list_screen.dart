import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/project.dart';
import '../models/project_item.dart';
import '../models/vanilla_item.dart';
import '../services/vanilla_data_service.dart';
import '../services/project_service.dart';
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
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } else {
      // No vanilla items for this category - create custom item directly
      await _handleCreateCustomItem();
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

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildItemCard(item);
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

  Widget _buildItemCard(VanillaItem item) {
    return GestureDetector(
      onTap: () => _handleItemSelect(item),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Item Icon
            Text(
              item.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: AppSpacing.md),
            // Item Name
            Text(
              item.name,
              style: const TextStyle(
                fontSize: AppTypography.md,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            // Rarity Badge
            if (item.rarity != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getRarityColor(item.rarity!).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
                ),
                child: Text(
                  item.rarity!,
                  style: TextStyle(
                    fontSize: AppTypography.xs,
                    color: _getRarityColor(item.rarity!),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'uncommon':
        return Colors.green;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }
}
