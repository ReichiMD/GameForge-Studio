import 'package:flutter/foundation.dart';
import 'project_item.dart';

/// Represents a GameForge project (collection of custom items)
class Project {
  final String id;
  final String name;
  final List<ProjectItem> items; // List of custom items in this project
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new project with generated ID and timestamps
  factory Project.create({
    required String name,
    List<ProjectItem>? items,
  }) {
    final now = DateTime.now();
    return Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      items: items ?? [],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create Project from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List?;
    final items = itemsList?.map((item) => ProjectItem.fromJson(item as Map<String, dynamic>)).toList() ?? [];

    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      items: items,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert Project to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of this project with updated fields
  Project copyWith({
    String? name,
    List<ProjectItem>? items,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Add an item to the project
  Project addItem(ProjectItem item) {
    return copyWith(items: [...items, item]);
  }

  /// Remove an item from the project
  Project removeItem(String itemId) {
    return copyWith(items: items.where((item) => item.id != itemId).toList());
  }

  /// Update an item in the project
  Project updateItem(ProjectItem updatedItem) {
    final updatedItems = items.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();
    return copyWith(items: updatedItems);
  }

  /// Get item by ID
  ProjectItem? getItem(String itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  /// Get emoji icon for project (first item's emoji or default)
  String get emoji {
    if (items.isEmpty) return '📦';
    return items.first.emoji;
  }

  /// Get item count
  int get itemCount => items.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, itemCount: ${items.length})';
  }
}
