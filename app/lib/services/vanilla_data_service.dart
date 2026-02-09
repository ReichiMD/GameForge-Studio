import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/vanilla_item.dart';

/// Service to load and manage Minecraft vanilla item data
class VanillaDataService {
  static final VanillaDataService _instance = VanillaDataService._internal();
  factory VanillaDataService() => _instance;
  VanillaDataService._internal();

  // Cache for loaded data
  Map<String, VanillaItem>? _items;
  Map<String, VanillaCategory>? _categories;
  bool _isLoaded = false;

  /// Load vanilla_stats.json from assets
  Future<void> loadData() async {
    if (_isLoaded) return; // Already loaded

    try {
      // Load JSON file from assets folder
      final String jsonString = await rootBundle.loadString(
        'assets/library/vanilla_stats.json',
      );

      final Map<String, dynamic> data = json.decode(jsonString);

      // Parse items
      final Map<String, dynamic> itemsJson = data['items'] as Map<String, dynamic>;
      _items = {};

      itemsJson.forEach((key, value) {
        // Skip comment entries
        if (key.startsWith('_comment')) return;

        _items![key] = VanillaItem.fromJson(key, value as Map<String, dynamic>);
      });

      // Parse categories
      final Map<String, dynamic> categoriesJson =
          data['categories'] as Map<String, dynamic>;
      _categories = {};

      categoriesJson.forEach((key, value) {
        _categories![key] =
            VanillaCategory.fromJson(key, value as Map<String, dynamic>);
      });

      _isLoaded = true;
      print('✅ Loaded ${_items!.length} items and ${_categories!.length} categories');
    } catch (e) {
      print('❌ Error loading vanilla_stats.json: $e');
      rethrow;
    }
  }

  /// Get all items
  Future<List<VanillaItem>> getAllItems() async {
    await loadData();
    return _items?.values.toList() ?? [];
  }

  /// Get items by category
  Future<List<VanillaItem>> getItemsByCategory(String categoryId) async {
    await loadData();
    return _items?.values
            .where((item) => item.category == categoryId)
            .toList() ??
        [];
  }

  /// Get item by key
  Future<VanillaItem?> getItem(String key) async {
    await loadData();
    return _items?[key];
  }

  /// Get all categories
  Future<List<VanillaCategory>> getAllCategories() async {
    await loadData();
    return _categories?.values.toList() ?? [];
  }

  /// Get category by ID
  Future<VanillaCategory?> getCategory(String categoryId) async {
    await loadData();
    return _categories?[categoryId];
  }

  /// Map category name (German) to category ID
  String? getCategoryIdByName(String germanName) {
    // Map from CreateProjectScreen categories to vanilla_stats.json categories
    final Map<String, String> categoryMapping = {
      'Waffen': 'weapons',
      'Rüstung': 'armor',
      'Werkzeuge': 'tools',
      'Nahrung': 'food',
      // Note: 'Mobs', 'Blöcke' don't have vanilla items yet
    };

    return categoryMapping[germanName];
  }

  /// Check if data is loaded
  bool get isLoaded => _isLoaded;

  /// Reset cache (for testing)
  void reset() {
    _items = null;
    _categories = null;
    _isLoaded = false;
  }
}
