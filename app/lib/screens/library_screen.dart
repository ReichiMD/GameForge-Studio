import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/vanilla_item.dart';
import '../services/vanilla_data_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final VanillaDataService _vanillaService = VanillaDataService();
  final TextEditingController _searchController = TextEditingController();

  List<VanillaItem> _allItems = [];
  List<VanillaItem> _filteredItems = [];
  List<VanillaCategory> _categories = [];
  bool _isLoading = true;
  String? _selectedCategoryId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final items = await _vanillaService.getAllItems();
      final categories = await _vanillaService.getAllCategories();

      setState(() {
        _allItems = items;
        _filteredItems = items;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Fehler beim Laden: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _allItems.where((item) {
        // Filter by category
        final categoryMatch = _selectedCategoryId == null ||
            item.category == _selectedCategoryId;

        // Filter by search query
        final searchMatch = _searchQuery.isEmpty ||
            item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.nameEn.toLowerCase().contains(_searchQuery.toLowerCase());

        return categoryMatch && searchMatch;
      }).toList();
    });
  }

  void _onCategorySelected(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    _filterItems();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryFilter(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text('📚', style: TextStyle(fontSize: 28)),
              SizedBox(width: AppSpacing.md),
              Text(
                'Bibliothek',
                style: TextStyle(
                  fontSize: AppTypography.xl,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          if (!_isLoading)
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
                '${_filteredItems.length}',
                style: const TextStyle(
                  fontSize: AppTypography.md,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(
          fontSize: AppTypography.md,
          color: AppColors.text,
        ),
        decoration: InputDecoration(
          hintText: 'Items suchen...',
          hintStyle: TextStyle(
            fontSize: AppTypography.md,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.background,
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
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        children: [
          _buildCategoryChip(
            label: 'Alle',
            emoji: '📦',
            isSelected: _selectedCategoryId == null,
            onTap: () => _onCategorySelected(null),
          ),
          const SizedBox(width: AppSpacing.sm),
          ..._categories.map((category) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: _buildCategoryChip(
                  label: category.name,
                  emoji: category.emoji,
                  isSelected: _selectedCategoryId == category.id,
                  onTap: () => _onCategorySelected(category.id),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required String emoji,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.md,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.text : AppColors.textSecondary,
              ),
            ),
          ],
        ),
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

    if (_filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🔍',
            style: TextStyle(
              fontSize: 80,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
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
            'Versuche einen anderen Suchbegriff\noder Filter',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTypography.md,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(VanillaItem item) {
    return GestureDetector(
      onTap: () => _showItemDetails(item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Item Image/Emoji
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizing.radiusMedium),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),

            // Item Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: AppTypography.sm,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    _buildRarityBadge(item.rarity),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRarityBadge(String rarity) {
    Color badgeColor;
    switch (rarity.toLowerCase()) {
      case 'common':
        badgeColor = AppColors.textSecondary;
        break;
      case 'uncommon':
        badgeColor = AppColors.success;
        break;
      case 'rare':
        badgeColor = AppColors.info;
        break;
      case 'epic':
        badgeColor = AppColors.primary;
        break;
      default:
        badgeColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
      ),
      child: Text(
        rarity,
        style: TextStyle(
          fontSize: AppTypography.xs,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }

  void _showItemDetails(VanillaItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildItemDetailsModal(item),
    );
  }

  Widget _buildItemDetailsModal(VanillaItem item) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizing.radiusLarge),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
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
                    Text(item.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: AppTypography.lg,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          item.nameEn,
                          style: TextStyle(
                            fontSize: AppTypography.sm,
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Item Type & Rarity
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          label: 'Typ',
                          value: item.type,
                          emoji: '🔖',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildInfoCard(
                          label: 'Seltenheit',
                          value: item.rarity,
                          emoji: '⭐',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Stats Section
                  if (item.stats.isNotEmpty) ...[
                    const Text(
                      '⚡ Stats',
                      style: TextStyle(
                        fontSize: AppTypography.md,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                      ),
                      child: Column(
                        children: item.stats.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatStatKey(entry.key),
                                  style: const TextStyle(
                                    fontSize: AppTypography.sm,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  entry.value.toString(),
                                  style: const TextStyle(
                                    fontSize: AppTypography.sm,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  // Minecraft ID
                  const Text(
                    '🎮 Minecraft ID',
                    style: TextStyle(
                      fontSize: AppTypography.md,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                    ),
                    child: Text(
                      item.id,
                      style: TextStyle(
                        fontSize: AppTypography.sm,
                        color: AppColors.info.withOpacity(0.9),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required String emoji,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.xs,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppTypography.sm,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatKey(String key) {
    // Convert snake_case to Title Case
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
