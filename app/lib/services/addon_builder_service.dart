import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:archive/archive.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/project_item.dart';

/// Service for building complete Minecraft Bedrock Addons (.mcaddon files)
/// with both Behavior Pack and Resource Pack
class AddonBuilderService {
  static const _uuid = Uuid();
  static const _githubRawUrl = 'https://raw.githubusercontent.com/ReichiMD/fabrik-library/main';

  /// Build a complete .mcaddon file from a project
  /// Returns the ZIP file as bytes
  static Future<Uint8List> buildAddon(Project project) async {
    if (project.items.isEmpty) {
      throw Exception('Project has no items to export');
    }

    // Create ZIP archive
    final archive = Archive();

    // Generate UUIDs for both packs
    final behaviorHeaderUuid = _uuid.v4();
    final behaviorModuleUuid = _uuid.v4();
    final resourceHeaderUuid = _uuid.v4();
    final resourceModuleUuid = _uuid.v4();

    // ========== BEHAVIOR PACK ==========

    // 1. Add behavior pack manifest.json
    final behaviorManifestJson = await _generateBehaviorManifest(
      project,
      behaviorHeaderUuid,
      behaviorModuleUuid,
      resourceHeaderUuid, // Dependency on resource pack
    );
    final behaviorManifestBytes = utf8.encode(behaviorManifestJson);
    archive.addFile(
      ArchiveFile(
        'behavior_pack/manifest.json',
        behaviorManifestBytes.length,
        behaviorManifestBytes,
      ),
    );

    // 2. Add behavior pack items/*.json
    for (final item in project.items) {
      final itemJson = _exportItemToMinecraftJSON(item);
      final itemBytes = utf8.encode(itemJson);
      final itemFilename = 'behavior_pack/items/${_sanitizeIdentifier(item.name)}.json';
      archive.addFile(
        ArchiveFile(itemFilename, itemBytes.length, itemBytes),
      );
    }

    // 3. Add behavior pack pack_icon.png (optional)
    try {
      final iconBytes = await rootBundle.load('assets/templates/pack_icon.png');
      archive.addFile(
        ArchiveFile(
          'behavior_pack/pack_icon.png',
          iconBytes.lengthInBytes,
          iconBytes.buffer.asUint8List(),
        ),
      );
    } catch (e) {
      // Icon not found - Minecraft will use a default icon
    }

    // ========== RESOURCE PACK ==========

    // 4. Add resource pack manifest.json
    final resourceManifestJson = await _generateResourceManifest(
      project,
      resourceHeaderUuid,
      resourceModuleUuid,
    );
    final resourceManifestBytes = utf8.encode(resourceManifestJson);
    archive.addFile(
      ArchiveFile(
        'resource_pack/manifest.json',
        resourceManifestBytes.length,
        resourceManifestBytes,
      ),
    );

    // 5. Add resource pack pack_icon.png (optional)
    try {
      final iconBytes = await rootBundle.load('assets/templates/pack_icon.png');
      archive.addFile(
        ArchiveFile(
          'resource_pack/pack_icon.png',
          iconBytes.lengthInBytes,
          iconBytes.buffer.asUint8List(),
        ),
      );
    } catch (e) {
      // Icon not found - Minecraft will use a default icon
    }

    // 6. Download and add item textures
    final textureData = <String, dynamic>{};
    for (final item in project.items) {
      final itemIdentifier = _sanitizeIdentifier(item.name);

      try {
        // Download texture from GitHub
        final imageBytes = await _downloadItemTexture(item);

        // Add to archive
        final texturePath = 'resource_pack/textures/items/$itemIdentifier.png';
        archive.addFile(
          ArchiveFile(texturePath, imageBytes.length, imageBytes),
        );

        // Add to texture data for item_texture.json
        textureData[itemIdentifier] = {
          'textures': 'textures/items/$itemIdentifier',
        };
      } catch (e) {
        // If texture download fails, skip this item's texture
        // Minecraft will use a default/missing texture
        print('Warning: Could not download texture for ${item.name}: $e');
      }
    }

    // 7. Add item_texture.json
    final itemTextureJson = _generateItemTextureJson(textureData);
    final itemTextureBytes = utf8.encode(itemTextureJson);
    archive.addFile(
      ArchiveFile(
        'resource_pack/textures/item_texture.json',
        itemTextureBytes.length,
        itemTextureBytes,
      ),
    );

    // 8. Add terrain_texture.json (required even if empty)
    final terrainTextureJson = _generateTerrainTextureJson();
    final terrainTextureBytes = utf8.encode(terrainTextureJson);
    archive.addFile(
      ArchiveFile(
        'resource_pack/textures/terrain_texture.json',
        terrainTextureBytes.length,
        terrainTextureBytes,
      ),
    );

    // Encode to ZIP
    final zipEncoder = ZipEncoder();
    final zipBytes = zipEncoder.encode(archive);

    if (zipBytes == null) {
      throw Exception('Failed to create ZIP file');
    }

    return Uint8List.fromList(zipBytes);
  }

  /// Download item texture from GitHub
  /// Uses custom icon if available, otherwise falls back to vanilla texture
  static Future<Uint8List> _downloadItemTexture(ProjectItem item) async {
    String imageUrl;

    if (item.customIconUrl != null && item.customIconUrl!.isNotEmpty) {
      // Use custom icon
      imageUrl = item.customIconUrl!;
    } else if (item.baseItem != null && item.baseItem!.textureUrl != null) {
      // Use vanilla item texture
      imageUrl = item.baseItem!.textureUrl!;
    } else {
      throw Exception('Item has no texture source');
    }

    // Download image
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download texture: HTTP ${response.statusCode}');
    }
  }

  /// Generate behavior pack manifest.json from template
  static Future<String> _generateBehaviorManifest(
    Project project,
    String headerUuid,
    String moduleUuid,
    String resourcePackUuid,
  ) async {
    // Load template
    final templateString = await rootBundle.loadString(
      'assets/templates/manifest_behavior.json',
    );

    // Parse JSON to add dependency
    final manifestMap = jsonDecode(templateString) as Map<String, dynamic>;

    // Add dependency on resource pack
    manifestMap['dependencies'] = [
      {
        'uuid': resourcePackUuid,
        'version': [0, 0, 1],
      }
    ];

    // Replace placeholders
    String manifestJson = jsonEncode(manifestMap);
    manifestJson = manifestJson
        .replaceAll('{{NAME}}', project.name)
        .replaceAll('{{DESCRIPTION}}', 'Created with GameForge Studio')
        .replaceAll('{{HEADER_UUID}}', headerUuid)
        .replaceAll('{{MODULE_UUID}}', moduleUuid);

    // Format nicely
    final encoder = JsonEncoder.withIndent('    ');
    return encoder.convert(jsonDecode(manifestJson));
  }

  /// Generate resource pack manifest.json from template
  static Future<String> _generateResourceManifest(
    Project project,
    String headerUuid,
    String moduleUuid,
  ) async {
    // Load template
    final templateString = await rootBundle.loadString(
      'assets/templates/manifest_resource.json',
    );

    // Replace placeholders
    final manifestJson = templateString
        .replaceAll('{{NAME}}', project.name)
        .replaceAll('{{DESCRIPTION}}', 'Created with GameForge Studio')
        .replaceAll('{{HEADER_UUID}}', headerUuid)
        .replaceAll('{{MODULE_UUID}}', moduleUuid);

    return manifestJson;
  }

  /// Generate item_texture.json
  static String _generateItemTextureJson(Map<String, dynamic> textureData) {
    final itemTextureJson = {
      'resource_pack_name': 'vanilla',
      'texture_name': 'atlas.items',
      'texture_data': textureData,
    };

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(itemTextureJson);
  }

  /// Generate terrain_texture.json (empty but required)
  static String _generateTerrainTextureJson() {
    final terrainTextureJson = {
      'resource_pack_name': 'vanilla',
      'texture_name': 'atlas.terrain',
      'texture_data': <String, dynamic>{},
    };

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(terrainTextureJson);
  }

  /// Export a single ProjectItem as Minecraft Bedrock Edition item JSON
  /// Updated for format version 1.21.130 (compatible with 1.21.131)
  ///
  /// Key changes in 1.21.130+:
  /// - Icon format: textures: { default: "name" } instead of texture: "name"
  /// - Attribute modifiers: New way to set attack_damage, armor, armor_toughness
  /// - minecraft:armor component is deprecated - use attribute_modifiers instead
  /// - menu_category: Defines creative inventory placement
  static String _exportItemToMinecraftJSON(ProjectItem item) {
    final itemIdentifier = _sanitizeIdentifier(item.name);
    final menuCategory = _getMenuCategory(item.category);

    // Get custom stats
    final customStats = item.customStats;
    final damage = (customStats['damage'] as num?)?.toDouble() ?? 0.0;
    final durability = (customStats['durability'] as num?)?.toInt() ?? 100;
    final armor = (customStats['armor'] as num?)?.toDouble() ?? 0.0;
    final armorToughness = (customStats['armor_toughness'] as num?)?.toDouble() ?? 0.0;
    final enchantability = (customStats['enchantability'] as num?)?.toInt() ?? 10;
    final movementSpeed = (customStats['movement_speed'] as num?)?.toDouble() ?? 0.0;

    // Advanced stats (noch nicht verwendet)
    final miningSpeed = (customStats['mining_speed'] as num?)?.toDouble() ?? 1.0;

    // Build components
    final components = <String, dynamic>{};

    // Display name
    components['minecraft:display_name'] = {
      'value': item.name,
    };

    // Icon - NEW FORMAT in 1.21.130+
    components['minecraft:icon'] = {
      'textures': {
        'default': itemIdentifier,
      }
    };

    // Max stack size
    components['minecraft:max_stack_size'] = 1;

    // Durability
    if (durability > 0) {
      components['minecraft:durability'] = {
        'max_durability': durability,
      };
    }

    // Hand equipped (for weapons and tools)
    if (item.category.toLowerCase() == 'waffen' ||
        item.category.toLowerCase() == 'werkzeuge') {
      components['minecraft:hand_equipped'] = true;
    }

    // Attribute modifiers - NEW in 1.21.130+
    final attributeModifiers = <Map<String, dynamic>>[];

    // Attack damage (for weapons and tools)
    if (damage > 0) {
      attributeModifiers.add({
        'attribute': 'minecraft:player.attack_damage',
        'amount': damage,
        'operation': 'add_value',
        'slot': 'mainhand',
      });
    }

    // Movement speed modifier
    if (movementSpeed != 0.0) {
      attributeModifiers.add({
        'attribute': 'minecraft:player.movement_speed',
        'amount': movementSpeed,
        'operation': 'add_value',
        'slot': 'any',
      });
    }

    // Armor and toughness (for armor items)
    if (armor > 0 || armorToughness > 0) {
      final armorSlot = _getArmorSlot(item.baseItem?.type);

      // Wearable component (required for armor)
      if (armorSlot != null) {
        components['minecraft:wearable'] = {
          'slot': armorSlot,
        };

        // Armor protection
        if (armor > 0) {
          attributeModifiers.add({
            'attribute': 'minecraft:player.armor',
            'amount': armor,
            'operation': 'add_value',
            'slot': armorSlot,
          });
        }

        // Armor toughness
        if (armorToughness > 0) {
          attributeModifiers.add({
            'attribute': 'minecraft:player.armor_toughness',
            'amount': armorToughness,
            'operation': 'add_value',
            'slot': armorSlot,
          });
        }
      }
    }

    // Add attribute modifiers if any exist
    if (attributeModifiers.isNotEmpty) {
      components['minecraft:attribute_modifiers'] = {
        'modifiers': attributeModifiers,
      };
    }

    // Mining speed (for tools)
    if (miningSpeed > 1.0) {
      components['minecraft:digger'] = {
        'use_efficiency': true,
        'destroy_speeds': [
          {
            'speed': miningSpeed,
          }
        ],
      };
    }

    // Enchantability (mit korrektem slot-Parameter!)
    if (enchantability > 0) {
      final enchantableSlot = _getEnchantableSlot(item.category, item.baseItem?.type);
      if (enchantableSlot != null) {
        components['minecraft:enchantable'] = {
          'slot': enchantableSlot,
          'value': enchantability,
        };
      }
    }

    // Effects
    final effects = item.effects;
    if (effects['fire'] == true) {
      components['minecraft:ignite_on_use'] = {
        'duration': 5.0,
      };
    }
    if (effects['glow'] == true) {
      components['minecraft:foil'] = true;
    }

    // Can destroy in creative (prevent accidental deletion)
    components['minecraft:can_destroy_in_creative'] = false;

    // Build the complete item JSON with menu_category
    final itemJson = {
      'format_version': '1.21.130',
      'minecraft:item': {
        'description': {
          'identifier': 'custom:$itemIdentifier',
          'menu_category': menuCategory,
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

  /// Get menu category for creative inventory (1.21.130+ format)
  static Map<String, dynamic> _getMenuCategory(String category) {
    switch (category.toLowerCase()) {
      case 'waffen':
        return {
          'category': 'equipment',
          'group': 'minecraft:itemGroup.name.sword',
        };
      case 'rüstung':
        return {
          'category': 'equipment',
          'group': 'minecraft:itemGroup.name.chestplate',
        };
      case 'werkzeuge':
        return {
          'category': 'equipment',
          'group': 'minecraft:itemGroup.name.pickaxe',
        };
      case 'nahrung':
        return {
          'category': 'nature',
          'group': 'minecraft:itemGroup.name.food',
        };
      case 'blöcke':
        return {
          'category': 'construction',
        };
      default:
        return {
          'category': 'items',
        };
    }
  }

  /// Get armor slot based on item type
  static String? _getArmorSlot(String? itemType) {
    if (itemType == null) return null;

    final type = itemType.toLowerCase();
    if (type.contains('helmet') || type.contains('helm')) {
      return 'slot.armor.head';
    } else if (type.contains('chestplate') || type.contains('brustpanzer')) {
      return 'slot.armor.chest';
    } else if (type.contains('leggings') || type.contains('hose')) {
      return 'slot.armor.legs';
    } else if (type.contains('boots') || type.contains('stiefel')) {
      return 'slot.armor.feet';
    }
    return null;
  }

  /// Get enchantable slot based on item category and type
  static String? _getEnchantableSlot(String category, String? itemType) {
    switch (category.toLowerCase()) {
      case 'waffen':
        return 'sword';
      case 'werkzeuge':
        return 'pickaxe';
      case 'rüstung':
        // Determine armor slot based on item type
        if (itemType == null) return 'armor_torso'; // Default to chestplate

        final type = itemType.toLowerCase();
        if (type.contains('helmet') || type.contains('helm')) {
          return 'armor_head';
        } else if (type.contains('chestplate') || type.contains('brustpanzer')) {
          return 'armor_torso';
        } else if (type.contains('leggings') || type.contains('hose')) {
          return 'armor_legs';
        } else if (type.contains('boots') || type.contains('stiefel')) {
          return 'armor_feet';
        }
        return 'armor_torso'; // Default
      default:
        return null; // No enchantability for other categories
    }
  }

  /// Get filename for .mcaddon export
  static String getAddonFilename(Project project) {
    final identifier = _sanitizeIdentifier(project.name);
    return '$identifier.mcaddon';
  }
}
