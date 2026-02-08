import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/vanilla_item.dart';
import '../services/vanilla_data_service.dart';

class ItemSelectionModal extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryEmoji;
  final Function(VanillaItem)? onItemSelected;

  const ItemSelectionModal({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryEmoji,
    this.onItemSelected,
  });

  @override
  State<ItemSelectionModal> createState() => _ItemSelectionModalState();
}

class _ItemSelectionModalState extends State<ItemSelectionModal> {
  final VanillaDataService _vanillaService = VanillaDataService();
  List<VanillaItem> _items = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final items = await _vanillaService.getItemsByCategory(widget.categoryId);

      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Fehler beim Laden der Items: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizing.radiusLarge),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizing.radiusLarge),
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                widget.categoryEmoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Wähle ein ${widget.categoryName}',
                style: const TextStyle(
                  fontSize: AppTypography.lg,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          SizedBox(
            width: AppSizing.touchMinimum,
            height: AppSizing.touchMinimum,
            child: IconButton(
              icon: const Text(
                '×',
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.textSecondary,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
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

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '❌',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _error!,
                style: const TextStyle(
                  fontSize: AppTypography.md,
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: _loadItems,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
                child: const Text(
                  'Erneut versuchen',
                  style: TextStyle(
                    fontSize: AppTypography.md,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.categoryEmoji,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Keine Items gefunden',
                style: TextStyle(
                  fontSize: AppTypography.lg,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Für diese Kategorie sind noch keine Items verfügbar.',
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

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
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

  Widget _buildItemCard(VanillaItem item) {
    return GestureDetector(
      onTap: () {
        if (widget.onItemSelected != null) {
          Navigator.of(context).pop();
          // Call callback AFTER closing modal
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onItemSelected!(item);
          });
        } else {
          Navigator.of(context).pop(item);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Item Emoji
            Text(
              item.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: AppSpacing.sm),

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
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: _getRarityColor(item.rarity).withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
              ),
              child: Text(
                _getRarityName(item.rarity),
                style: TextStyle(
                  fontSize: AppTypography.xs,
                  fontWeight: FontWeight.w600,
                  color: _getRarityColor(item.rarity),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Main Stat
            if (item.hasStat('damage'))
              _buildStatRow('⚔️', '${item.getStat('damage')}')
            else if (item.hasStat('armor'))
              _buildStatRow('🛡️', '${item.getStat('armor')}')
            else if (item.hasStat('nutrition'))
              _buildStatRow('🍖', '${item.getStat('nutrition')}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String icon, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: AppSpacing.xs),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppTypography.sm,
            fontWeight: FontWeight.w600,
            color: AppColors.info,
          ),
        ),
      ],
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
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
        return Colors.grey;
    }
  }

  String _getRarityName(String rarity) {
    switch (rarity) {
      case 'common':
        return 'Gewöhnlich';
      case 'uncommon':
        return 'Ungewöhnlich';
      case 'rare':
        return 'Selten';
      case 'epic':
        return 'Episch';
      case 'legendary':
        return 'Legendär';
      default:
        return rarity;
    }
  }
}

/// Show item selection modal
Future<VanillaItem?> showItemSelectionModal(
  BuildContext context, {
  required String categoryId,
  required String categoryName,
  required String categoryEmoji,
}) {
  return showModalBottomSheet<VanillaItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ItemSelectionModal(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryEmoji: categoryEmoji,
    ),
  );
}
