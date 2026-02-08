/// Represents a Minecraft vanilla item from vanilla_stats.json
class VanillaItem {
  final String key; // JSON key (e.g., "wooden_sword")
  final String id; // Minecraft ID (e.g., "minecraft:wooden_sword")
  final String name; // German name
  final String nameEn; // English name
  final String category; // Category ID (e.g., "weapons")
  final String type; // Item type (e.g., "sword")
  final String emoji; // Emoji representation
  final String rarity; // Rarity level
  final Map<String, dynamic> stats; // Item stats
  final String? texture; // Texture path

  VanillaItem({
    required this.key,
    required this.id,
    required this.name,
    required this.nameEn,
    required this.category,
    required this.type,
    required this.emoji,
    required this.rarity,
    required this.stats,
    this.texture,
  });

  /// Create VanillaItem from JSON
  factory VanillaItem.fromJson(String key, Map<String, dynamic> json) {
    return VanillaItem(
      key: key,
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
      emoji: json['emoji'] as String,
      rarity: json['rarity'] as String,
      stats: Map<String, dynamic>.from(json['stats'] as Map),
      texture: json['texture'] as String?,
    );
  }

  /// Convert VanillaItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'id': id,
      'name': name,
      'name_en': nameEn,
      'category': category,
      'type': type,
      'emoji': emoji,
      'rarity': rarity,
      'stats': stats,
      if (texture != null) 'texture': texture,
    };
  }

  /// Get display name (German)
  String get displayName => name;

  /// Get stat value by key
  dynamic getStat(String key) => stats[key];

  /// Check if item has a specific stat
  bool hasStat(String key) => stats.containsKey(key);

  /// Get full texture URL from GitHub repository
  /// Returns null if no texture is defined
  String? get textureUrl {
    if (texture == null) return null;

    // Base URL for fabrik-library repository
    const baseUrl = 'https://raw.githubusercontent.com/ReichiMD/fabrik-library/main';

    // Extract filename from texture path
    // Example: "assets/vanilla/textures/items/wood_sword.png" -> "wood_sword.png"
    final filename = texture!.split('/').last;

    return '$baseUrl/assets/vanilla/textures/items/$filename';
  }

  /// Check if item has a texture
  bool get hasTexture => texture != null;

  @override
  String toString() {
    return 'VanillaItem(key: $key, name: $name, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VanillaItem && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// Represents a category from vanilla_stats.json
class VanillaCategory {
  final String id; // Category ID (e.g., "weapons")
  final String name; // German name
  final String nameEn; // English name
  final String emoji; // Emoji representation
  final String description; // Category description

  VanillaCategory({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.emoji,
    required this.description,
  });

  /// Create VanillaCategory from JSON
  factory VanillaCategory.fromJson(String id, Map<String, dynamic> json) {
    return VanillaCategory(
      id: id,
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      emoji: json['emoji'] as String,
      description: json['description'] as String,
    );
  }

  /// Convert VanillaCategory to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'emoji': emoji,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'VanillaCategory(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VanillaCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
