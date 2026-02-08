import 'vanilla_item.dart';

/// Represents a custom item within a project
class ProjectItem {
  final String id;
  final String name;
  final String category;
  final String emoji;
  final VanillaItem? baseItem;
  final Map<String, dynamic> customStats;
  final Map<String, dynamic> effects;
  final DateTime createdAt;

  ProjectItem({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    this.baseItem,
    required this.customStats,
    required this.effects,
    required this.createdAt,
  });

  /// Create a new item with generated ID and timestamp
  factory ProjectItem.create({
    required String name,
    required String category,
    required String emoji,
    VanillaItem? baseItem,
    Map<String, dynamic>? customStats,
    Map<String, dynamic>? effects,
  }) {
    return ProjectItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      emoji: emoji,
      baseItem: baseItem,
      customStats: customStats ?? _defaultStatsForCategory(category),
      effects: effects ?? {'fire': false, 'glow': false},
      createdAt: DateTime.now(),
    );
  }

  /// Create ProjectItem from JSON
  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    VanillaItem? baseItem;
    if (json['baseItem'] != null) {
      try {
        final baseItemMap = json['baseItem'] as Map<String, dynamic>;
        final key = baseItemMap['key'] as String;
        baseItem = VanillaItem.fromJson(key, baseItemMap);
      } catch (e) {
        baseItem = null;
      }
    }

    return ProjectItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      emoji: json['emoji'] as String? ?? '📦',
      baseItem: baseItem,
      customStats: Map<String, dynamic>.from(json['customStats'] as Map? ?? {}),
      effects: Map<String, dynamic>.from(json['effects'] as Map? ?? {}),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert ProjectItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'emoji': emoji,
      'baseItem': baseItem?.toJson(),
      'customStats': customStats,
      'effects': effects,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  ProjectItem copyWith({
    String? name,
    String? category,
    String? emoji,
    VanillaItem? baseItem,
    Map<String, dynamic>? customStats,
    Map<String, dynamic>? effects,
  }) {
    return ProjectItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      baseItem: baseItem ?? this.baseItem,
      customStats: customStats ?? this.customStats,
      effects: effects ?? this.effects,
      createdAt: createdAt,
    );
  }

  /// Get default stats based on category
  static Map<String, dynamic> _defaultStatsForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'waffen':
        return {
          'damage': 7.0,
          'durability': 1561.0,
          'attack_speed': 1.6,
          'armor': 0.0,
          'armor_toughness': 0.0,
          'mining_speed': 1.0,
        };
      case 'rüstung':
        return {
          'damage': 0.0,
          'durability': 500.0,
          'attack_speed': 0.0,
          'armor': 8.0,
          'armor_toughness': 3.0,
          'mining_speed': 1.0,
        };
      case 'werkzeuge':
        return {
          'damage': 2.0,
          'durability': 1561.0,
          'attack_speed': 1.0,
          'armor': 0.0,
          'armor_toughness': 0.0,
          'mining_speed': 8.0,
        };
      default:
        return {
          'damage': 1.0,
          'durability': 100.0,
          'attack_speed': 1.0,
          'armor': 0.0,
          'armor_toughness': 0.0,
          'mining_speed': 1.0,
        };
    }
  }

  /// Get the emoji icon for the category
  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'waffen':
        return '⚔️';
      case 'rüstung':
        return '🛡️';
      case 'mobs':
        return '👾';
      case 'nahrung':
        return '🍖';
      case 'blöcke':
        return '🧱';
      case 'werkzeuge':
        return '⚒️';
      default:
        return '📦';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProjectItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProjectItem(id: $id, name: $name, category: $category)';
  }
}
