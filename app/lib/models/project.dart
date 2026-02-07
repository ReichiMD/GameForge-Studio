import 'package:flutter/foundation.dart';

/// Represents a GameForge project
class Project {
  final String id;
  final String name;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> data; // Flexible data storage for item properties

  Project({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.data,
  });

  /// Create a new project with generated ID and timestamps
  factory Project.create({
    required String name,
    required String category,
    Map<String, dynamic>? data,
  }) {
    final now = DateTime.now();
    return Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      createdAt: now,
      updatedAt: now,
      data: data ?? {},
    );
  }

  /// Create Project from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      data: Map<String, dynamic>.from(json['data'] as Map? ?? {}),
    );
  }

  /// Convert Project to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'data': data,
    };
  }

  /// Create a copy of this project with updated fields
  Project copyWith({
    String? name,
    String? category,
    DateTime? updatedAt,
    Map<String, dynamic>? data,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      data: data ?? this.data,
    );
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
    return other is Project && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, category: $category)';
  }
}
