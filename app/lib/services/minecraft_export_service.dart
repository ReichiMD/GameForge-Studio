import 'dart:convert';
import '../models/project.dart';
import '../models/project_item.dart';

/// Service for exporting projects to Minecraft Addon format
class MinecraftExportService {
  /// Export project as Minecraft Bedrock Edition item JSON
  /// If project has multiple items, exports the first item
  static String exportToMinecraftJSON(Project project) {
    if (project.items.isEmpty) {
      throw Exception('Project has no items to export');
    }

    // Export the first item (or all items if needed in the future)
    final item = project.items.first;
    return exportItemToMinecraftJSON(item);
  }

  /// Export a single ProjectItem as Minecraft Bedrock Edition item JSON
  static String exportItemToMinecraftJSON(ProjectItem item) {
    final itemIdentifier = _sanitizeIdentifier(item.name);
    final category = _mapCategory(item.category);

    // Build components based on item data
    final components = <String, dynamic>{
      'minecraft:max_stack_size': 1,
    };

    // Get custom stats
    final customStats = item.customStats;

    // Add durability if available
    final durability = customStats['durability'] as num?;
    if (durability != null && durability > 0) {
      components['minecraft:durability'] = {
        'max_durability': durability.toInt(),
      };
    }

    // Add damage if available
    final damage = customStats['damage'] as num?;
    if (damage != null && damage > 0) {
      components['minecraft:damage'] = damage.toDouble();
    }

    // Add armor if available
    final armor = customStats['armor'] as num?;
    if (armor != null && armor > 0) {
      components['minecraft:armor'] = {
        'protection': armor.toInt(),
      };
    }

    // Add armor toughness if available
    final armorToughness = customStats['armor_toughness'] as num?;
    if (armorToughness != null && armorToughness > 0) {
      components['minecraft:armor_toughness'] = armorToughness.toDouble();
    }

    // Add attack speed if available
    final attackSpeed = customStats['attack_speed'] as num?;
    if (attackSpeed != null) {
      components['minecraft:attack_speed'] = attackSpeed.toDouble();
    }

    // Add mining speed if available
    final miningSpeed = customStats['mining_speed'] as num?;
    if (miningSpeed != null && miningSpeed > 1.0) {
      components['minecraft:digger'] = {
        'use_efficiency': true,
        'destroy_speeds': [
          {
            'speed': miningSpeed.toDouble(),
          }
        ],
      };
    }

    // Add effects
    final effects = item.effects;
    if (effects['fire'] == true) {
      components['minecraft:ignite_on_use'] = {
        'duration': 5.0,
      };
    }
    if (effects['glow'] == true) {
      components['minecraft:foil'] = true; // Enchantment glint effect
    }

    // Build the complete item JSON
    final itemJson = {
      'format_version': '1.20.0',
      'minecraft:item': {
        'description': {
          'identifier': 'custom:$itemIdentifier',
          'category': category,
        },
        'components': components,
      }
    };

    // Convert to formatted JSON string
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(itemJson);
  }

  /// Export project metadata (for GameForge Studio import)
  static String exportToGameForgeJSON(Project project) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(project.toJson());
  }

  /// Sanitize project name to valid Minecraft identifier
  static String _sanitizeIdentifier(String name) {
    // Convert to lowercase and replace spaces/special chars with underscores
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  /// Map GameForge category to Minecraft category
  static String _mapCategory(String category) {
    switch (category.toLowerCase()) {
      case 'waffen':
        return 'equipment';
      case 'rüstung':
        return 'equipment';
      case 'werkzeuge':
        return 'equipment';
      case 'nahrung':
        return 'nature';
      case 'blöcke':
        return 'construction';
      case 'mobs':
        return 'items';
      default:
        return 'items';
    }
  }

  /// Get filename for export
  static String getExportFilename(Project project, {bool isMinecraft = true}) {
    if (project.items.isEmpty) {
      return isMinecraft ? 'empty_project.json' : 'gameforge_empty_project.json';
    }

    final identifier = _sanitizeIdentifier(project.items.first.name);
    if (isMinecraft) {
      return '$identifier.json';
    } else {
      return 'gameforge_$identifier.json';
    }
  }
}
