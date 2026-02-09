import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:archive/archive.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../models/project_item.dart';

/// Service for building complete Minecraft Bedrock Addons (.mcaddon files)
class AddonBuilderService {
  static const _uuid = Uuid();

  /// Build a complete .mcaddon file from a project
  /// Returns the ZIP file as bytes
  static Future<Uint8List> buildAddon(Project project) async {
    if (project.items.isEmpty) {
      throw Exception('Project has no items to export');
    }

    // Create ZIP archive
    final archive = Archive();

    // 1. Add manifest.json
    final manifestJson = await _generateManifest(project);
    final manifestBytes = utf8.encode(manifestJson);
    archive.addFile(
      ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
    );

    // 2. Add items/*.json
    for (final item in project.items) {
      final itemJson = _exportItemToMinecraftJSON(item);
      final itemBytes = utf8.encode(itemJson);
      final itemFilename = 'items/${_sanitizeIdentifier(item.name)}.json';
      archive.addFile(
        ArchiveFile(itemFilename, itemBytes.length, itemBytes),
      );
    }

    // 3. Add pack_icon.png (optional)
    try {
      final iconBytes = await rootBundle.load('assets/templates/pack_icon.png');
      archive.addFile(
        ArchiveFile(
          'pack_icon.png',
          iconBytes.lengthInBytes,
          iconBytes.buffer.asUint8List(),
        ),
      );
    } catch (e) {
      // Icon not found - Minecraft will use a default icon
      // This is not an error, just a missing optional file
    }

    // Encode to ZIP
    final zipEncoder = ZipEncoder();
    final zipBytes = zipEncoder.encode(archive);

    if (zipBytes == null) {
      throw Exception('Failed to create ZIP file');
    }

    return Uint8List.fromList(zipBytes);
  }

  /// Generate manifest.json from template
  static Future<String> _generateManifest(Project project) async {
    // Load template
    final templateString = await rootBundle.loadString(
      'assets/templates/manifest_behavior.json',
    );

    // Generate UUIDs
    final headerUuid = _uuid.v4();
    final moduleUuid = _uuid.v4();

    // Replace placeholders
    final manifestJson = templateString
        .replaceAll('{{NAME}}', project.name)
        .replaceAll('{{DESCRIPTION}}', 'Created with GameForge Studio')
        .replaceAll('{{HEADER_UUID}}', headerUuid)
        .replaceAll('{{MODULE_UUID}}', moduleUuid);

    return manifestJson;
  }

  /// Export a single ProjectItem as Minecraft Bedrock Edition item JSON
  /// (Updated version with format_version 1.21.100)
  static String _exportItemToMinecraftJSON(ProjectItem item) {
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
      components['minecraft:damage'] = {
        'value': damage.toDouble(),
      };
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
      components['minecraft:armor'] = {
        ...?components['minecraft:armor'] as Map<String, dynamic>?,
        'toughness': armorToughness.toDouble(),
      };
    }

    // Add attack speed if available
    final attackSpeed = customStats['attack_speed'] as num?;
    if (attackSpeed != null) {
      components['minecraft:attack_speed'] = {
        'value': attackSpeed.toDouble(),
      };
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

    // Add icon component (texture reference)
    components['minecraft:icon'] = {
      'texture': itemIdentifier,
    };

    // Add display name
    components['minecraft:display_name'] = {
      'value': item.name,
    };

    // Build the complete item JSON
    final itemJson = {
      'format_version': '1.21.100',
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

  /// Get filename for .mcaddon export
  static String getAddonFilename(Project project) {
    final identifier = _sanitizeIdentifier(project.name);
    return '$identifier.mcaddon';
  }
}
