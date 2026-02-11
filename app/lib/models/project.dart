import 'package:flutter/foundation.dart';
import 'project_item.dart';

/// Project type enum
enum ProjectType {
  items, // Traditional item-based project
  template, // Template-based project (e.g., leveling_wolf)
}

/// Represents a GameForge project (collection of custom items OR template-based project)
class Project {
  final String id;
  final String name;
  final List<ProjectItem> items; // List of custom items in this project (for items projects)
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProjectType projectType; // Type of project
  final String? templateId; // Template ID (e.g., "leveling_wolf") - only for template projects
  final Map<String, dynamic>? templateData; // Template field values - only for template projects

  Project({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.projectType = ProjectType.items, // Default to items for backwards compatibility
    this.templateId,
    this.templateData,
  });

  /// Create a new item-based project with generated ID and timestamps
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
      projectType: ProjectType.items,
    );
  }

  /// Create a new template-based project with generated ID and timestamps
  factory Project.createFromTemplate({
    required String name,
    required String templateId,
    required Map<String, dynamic> templateData,
  }) {
    final now = DateTime.now();
    return Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      items: [], // Template projects don't have items
      createdAt: now,
      updatedAt: now,
      projectType: ProjectType.template,
      templateId: templateId,
      templateData: templateData,
    );
  }

  /// Create Project from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List?;
    final items = itemsList?.map((item) => ProjectItem.fromJson(item as Map<String, dynamic>)).toList() ?? [];

    // Parse project type (default to items for backwards compatibility)
    final projectTypeStr = json['projectType'] as String?;
    final projectType = projectTypeStr == 'template' ? ProjectType.template : ProjectType.items;

    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      items: items,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      projectType: projectType,
      templateId: json['templateId'] as String?,
      templateData: json['templateData'] as Map<String, dynamic>?,
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
      'projectType': projectType == ProjectType.template ? 'template' : 'items',
      if (templateId != null) 'templateId': templateId,
      if (templateData != null) 'templateData': templateData,
    };
  }

  /// Create a copy of this project with updated fields
  Project copyWith({
    String? name,
    List<ProjectItem>? items,
    DateTime? updatedAt,
    ProjectType? projectType,
    String? templateId,
    Map<String, dynamic>? templateData,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      projectType: projectType ?? this.projectType,
      templateId: templateId ?? this.templateId,
      templateData: templateData ?? this.templateData,
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

  /// Get emoji icon for project
  String get emoji {
    // Template projects get special icons based on template ID
    if (projectType == ProjectType.template) {
      if (templateId == 'leveling_wolf') return '🐺';
      return '📋'; // Default template icon
    }

    // Item projects use first item's emoji or default
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
