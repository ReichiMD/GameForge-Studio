import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:archive/archive.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/project_item.dart';

/// Service for building complete Minecraft Bedrock Addons (.mcaddon files)
/// with both Behavior Pack and Resource Pack.
///
/// Supports Script API for abilities that can't be done with JSON alone:
/// - Fire Aspect (Custom Component onHitEntity → setOnFire)
/// - Knockback (Custom Component onHitEntity → applyKnockback)
/// - Fireball Shooter (Custom Component onCompleteUse → spawn fireball)
/// - Movement Speed on weapons (runInterval → addEffect speed/slowness)
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

    // Generate UUIDs for both packs + script module
    final behaviorHeaderUuid = _uuid.v4();
    final behaviorModuleUuid = _uuid.v4();
    final resourceHeaderUuid = _uuid.v4();
    final resourceModuleUuid = _uuid.v4();
    final scriptModuleUuid = _uuid.v4();

    // Check if any item needs the Script API
    final needsScript = _needsScriptAPI(project);

    // ========== BEHAVIOR PACK ==========

    // 1. Add behavior pack manifest.json
    final behaviorManifestJson = await _generateBehaviorManifest(
      project,
      behaviorHeaderUuid,
      behaviorModuleUuid,
      resourceHeaderUuid,
      needsScript: needsScript,
      scriptModuleUuid: scriptModuleUuid,
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
      final itemJson = _exportItemToMinecraftJSON(item, needsScript: needsScript);
      final itemBytes = utf8.encode(itemJson);
      final itemFilename = 'behavior_pack/items/${_sanitizeIdentifier(item.name)}.json';
      archive.addFile(
        ArchiveFile(itemFilename, itemBytes.length, itemBytes),
      );
    }

    // 3. Add script file + custom fireball entity if needed
    if (needsScript) {
      final scriptContent = _generateMainScript(project);
      final scriptBytes = utf8.encode(scriptContent);
      archive.addFile(
        ArchiveFile(
          'behavior_pack/scripts/main.js',
          scriptBytes.length,
          scriptBytes,
        ),
      );

      // Add custom fireball entity if any item shoots fireballs
      // Vanilla minecraft:small_fireball has is_summonable: false → can't spawn via Script API
      // Custom entity has is_summonable: true → works without experiments!
      final needsFireballs = project.items.any(
        (item) => item.effects['shoot_fireballs'] == true,
      );
      if (needsFireballs) {
        final fireballBP = _generateFireballEntityBP();
        final fireballBPBytes = utf8.encode(fireballBP);
        archive.addFile(ArchiveFile(
          'behavior_pack/entities/gameforge_fireball.json',
          fireballBPBytes.length,
          fireballBPBytes,
        ));

        final fireballRP = _generateFireballEntityRP();
        final fireballRPBytes = utf8.encode(fireballRP);
        archive.addFile(ArchiveFile(
          'resource_pack/entity/gameforge_fireball.entity.json',
          fireballRPBytes.length,
          fireballRPBytes,
        ));
      }
    }

    // 4. Add behavior pack pack_icon.png (optional)
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

    // 5. Add resource pack manifest.json
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

    // 6. Add resource pack pack_icon.png (optional)
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

    // 7. Download and add item textures
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

    // 8. Add item_texture.json
    final itemTextureJson = _generateItemTextureJson(textureData);
    final itemTextureBytes = utf8.encode(itemTextureJson);
    archive.addFile(
      ArchiveFile(
        'resource_pack/textures/item_texture.json',
        itemTextureBytes.length,
        itemTextureBytes,
      ),
    );

    // 9. Add terrain_texture.json (required even if empty)
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

  // ========== SCRIPT API ==========

  /// Check if any item in the project needs the Script API
  static bool _needsScriptAPI(Project project) {
    for (final item in project.items) {
      final effects = item.effects;
      if (effects['fire_aspect'] == true ||
          effects['knockback'] == true ||
          effects['shoot_fireballs'] == true) {
        return true;
      }
      // Movement speed on weapons needs script (attribute_modifiers only work on armor)
      final movementSpeed = (item.customStats['movement_speed'] as num?)?.toDouble() ?? 0.0;
      if (movementSpeed != 0.0 && item.category.toLowerCase() == 'waffen') {
        return true;
      }
    }
    return false;
  }

  /// Generate the scripts/main.js for the behavior pack.
  /// Uses world.afterEvents (stable @minecraft/server 1.16.0, no experiment needed).
  /// NO system.beforeEvents.startup - avoids "startup of undefined" error.
  static String _generateMainScript(Project project) {
    final buffer = StringBuffer();

    // Collect which items have which abilities
    final fireAspectItems = <String>[];
    final knockbackItems = <String>[];
    final fireballItems = <String>[];
    final speedItems = <String, double>{};

    for (final item in project.items) {
      final effects = item.effects;
      final identifier = _sanitizeIdentifier(item.name);

      if (effects['fire_aspect'] == true) fireAspectItems.add('custom:$identifier');
      if (effects['knockback'] == true) knockbackItems.add('custom:$identifier');
      if (effects['shoot_fireballs'] == true) fireballItems.add('custom:$identifier');

      final movementSpeed = (item.customStats['movement_speed'] as num?)?.toDouble() ?? 0.0;
      if (movementSpeed != 0.0 && item.category.toLowerCase() == 'waffen') {
        speedItems['custom:$identifier'] = movementSpeed;
      }
    }

    final needsCombatEvents = fireAspectItems.isNotEmpty || knockbackItems.isNotEmpty;
    final needsFireballs = fireballItems.isNotEmpty;

    // Header
    buffer.writeln('// Auto-generated by GameForge Studio');
    buffer.writeln('// Nutzt world.afterEvents - kein system.beforeEvents.startup nötig!');
    buffer.writeln('// Kompatibel mit @minecraft/server 1.16.0 (stabil, kein Experiment nötig)');
    buffer.writeln('import { world, system, EquipmentSlot } from "@minecraft/server";');
    buffer.writeln();

    // ===== BAUSTEIN: Feueraspekt + Rückstoß via entityHurt event =====
    if (needsCombatEvents) {
      if (fireAspectItems.isNotEmpty) {
        final ids = fireAspectItems.map((id) => '"$id"').join(', ');
        buffer.writeln('// Items mit Feueraspekt (Gegner brennen 5 Sek)');
        buffer.writeln('const FIRE_ASPECT_ITEMS = [$ids];');
      }
      if (knockbackItems.isNotEmpty) {
        final ids = knockbackItems.map((id) => '"$id"').join(', ');
        buffer.writeln('// Items mit Rückstoß (Gegner fliegen weg)');
        buffer.writeln('const KNOCKBACK_ITEMS = [$ids];');
      }
      buffer.writeln();
      buffer.writeln('// ===== BAUSTEIN: Feueraspekt + Rückstoß =====');
      buffer.writeln('// Reagiert auf entityHurt - funktioniert ohne system.beforeEvents.startup!');
      buffer.writeln('world.afterEvents.entityHurt.subscribe((event) => {');
      buffer.writeln('    try {');
      buffer.writeln('        const attacker = event.damageSource.damagingEntity;');
      buffer.writeln('        if (!attacker || !attacker.isValid()) return;');
      buffer.writeln('        const equipment = attacker.getComponent("minecraft:equippable");');
      buffer.writeln('        if (!equipment) return;');
      buffer.writeln('        const weapon = equipment.getEquipment(EquipmentSlot.Mainhand);');
      buffer.writeln('        if (!weapon) return;');
      buffer.writeln('        const typeId = weapon.typeId;');
      buffer.writeln('        const target = event.hurtEntity;');
      buffer.writeln('        if (!target || !target.isValid()) return;');
      if (fireAspectItems.isNotEmpty) {
        buffer.writeln('        // Feueraspekt: Ziel in Brand setzen');
        buffer.writeln('        if (FIRE_ASPECT_ITEMS.includes(typeId)) {');
        buffer.writeln('            target.setOnFire(5, true);');
        buffer.writeln('        }');
      }
      if (knockbackItems.isNotEmpty) {
        buffer.writeln('        // Rückstoß: Ziel wegschleudern');
        buffer.writeln('        if (KNOCKBACK_ITEMS.includes(typeId)) {');
        buffer.writeln('            const dx = target.location.x - attacker.location.x;');
        buffer.writeln('            const dz = target.location.z - attacker.location.z;');
        buffer.writeln('            const dist = Math.sqrt(dx * dx + dz * dz);');
        buffer.writeln('            if (dist > 0) {');
        buffer.writeln('                target.applyKnockback(dx / dist, dz / dist, 2.0, 0.4);');
        buffer.writeln('            }');
        buffer.writeln('        }');
      }
      buffer.writeln('    } catch (e) {');
      buffer.writeln('        console.warn("Combat Error: " + e.message);');
      buffer.writeln('    }');
      buffer.writeln('});');
      buffer.writeln();
    }

    // ===== BAUSTEIN: Feuerbälle via itemUse event =====
    if (needsFireballs) {
      final ids = fireballItems.map((id) => '"$id"').join(', ');
      buffer.writeln('// ===== BAUSTEIN: Feuerbälle =====');
      buffer.writeln('// Rechtsklick → Feuerball schießen (world.beforeEvents.itemUse + system.run)');
      buffer.writeln('const FIREBALL_ITEMS = [$ids];');
      buffer.writeln();
      buffer.writeln('world.beforeEvents.itemUse.subscribe((event) => {');
      buffer.writeln('    if (!FIREBALL_ITEMS.includes(event.itemStack.typeId)) return;');
      buffer.writeln('    const player = event.source;');
      buffer.writeln('    // system.run() verlässt den read-only Modus um Entities spawnen zu können');
      buffer.writeln('    system.run(() => {');
      buffer.writeln('        try {');
      buffer.writeln('            if (!player || !player.isValid()) return;');
      buffer.writeln('            const viewDir = player.getViewDirection();');
      buffer.writeln('            const headLoc = player.getHeadLocation();');
      buffer.writeln('            const spawnLoc = {');
      buffer.writeln('                x: headLoc.x + viewDir.x * 2,');
      buffer.writeln('                y: headLoc.y + viewDir.y * 2,');
      buffer.writeln('                z: headLoc.z + viewDir.z * 2');
      buffer.writeln('            };');
      buffer.writeln('            const fireball = player.dimension.spawnEntity("custom:gameforge_fireball", spawnLoc);');
      buffer.writeln('            if (fireball && fireball.isValid()) {');
      buffer.writeln('                fireball.applyImpulse({');
      buffer.writeln('                    x: viewDir.x * 1.5,');
      buffer.writeln('                    y: viewDir.y * 1.5,');
      buffer.writeln('                    z: viewDir.z * 1.5');
      buffer.writeln('                });');
      buffer.writeln('            }');
      buffer.writeln('        } catch (e) {');
      buffer.writeln('            console.warn("Fireball Error: " + e.message);');
      buffer.writeln('        }');
      buffer.writeln('    });');
      buffer.writeln('});');
      buffer.writeln();
    }

    // ===== BAUSTEIN: Geschwindigkeit =====
    if (speedItems.isNotEmpty) {
      buffer.writeln('// ===== BAUSTEIN: Geschwindigkeit =====');
      buffer.writeln('// Gibt Speed/Slowness-Effekt basierend auf der gehaltenen Waffe');
      buffer.writeln('// Tick-Drosselung: Läuft nur 1x pro Sekunde (nicht 20x!)');
      buffer.writeln('const SPEED_ITEMS = {');
      for (final entry in speedItems.entries) {
        buffer.writeln('    "${entry.key}": ${entry.value},');
      }
      buffer.writeln('};');
      buffer.writeln();
      buffer.writeln('system.runInterval(() => {');
      buffer.writeln('    try {');
      buffer.writeln('        const players = world.getAllPlayers();');
      buffer.writeln('        for (const player of players) {');
      buffer.writeln('            if (!player || !player.isValid()) continue;');
      buffer.writeln('            const equipment = player.getComponent("minecraft:equippable");');
      buffer.writeln('            if (!equipment) continue;');
      buffer.writeln('            const mainhand = equipment.getEquipment(EquipmentSlot.Mainhand);');
      buffer.writeln('            if (!mainhand) continue;');
      buffer.writeln('            const speedValue = SPEED_ITEMS[mainhand.typeId];');
      buffer.writeln('            if (speedValue === undefined) continue;');
      buffer.writeln('            if (speedValue > 0) {');
      buffer.writeln('                const amplifier = Math.max(0, Math.round(speedValue / 0.2) - 1);');
      buffer.writeln('                player.addEffect("speed", 40, { amplifier: amplifier, showParticles: false });');
      buffer.writeln('            } else if (speedValue < 0) {');
      buffer.writeln('                const amplifier = Math.max(0, Math.round(Math.abs(speedValue) / 0.15) - 1);');
      buffer.writeln('                player.addEffect("slowness", 40, { amplifier: amplifier, showParticles: false });');
      buffer.writeln('            }');
      buffer.writeln('        }');
      buffer.writeln('    } catch (e) {');
      buffer.writeln('        console.warn("SpeedBoost Error: " + e.message);');
      buffer.writeln('    }');
      buffer.writeln('}, 20); // 20 Ticks = 1 Sekunde');
    }

    return buffer.toString();
  }

  // ========== CUSTOM FIREBALL ENTITY ==========

  /// Behavior Pack entity definition for the custom fireball projectile.
  /// is_summonable: true allows spawning via Script API (unlike vanilla minecraft:small_fireball).
  static String _generateFireballEntityBP() {
    final entity = {
      'format_version': '1.21.130',
      'minecraft:entity': {
        'description': {
          'identifier': 'custom:gameforge_fireball',
          'is_spawnable': false,
          'is_summonable': true,
        },
        'components': {
          'minecraft:collision_box': {'width': 0.3125, 'height': 0.3125},
          'minecraft:fire_immune': {},
          'minecraft:projectile': {
            'on_hit': {
              'impact_damage': {'damage': 6, 'knockback': true},
              'ignite': {'fire_affected_by_griefing': false, 'duration': 5},
              'remove_on_hit': {},
            },
            'gravity': 0.0,
            'catch_fire': true,
            'hit_sound': 'mob.ghast.fireball',
          },
          'minecraft:physics': {
            'has_collision': true,
            'has_gravity': false,
          },
        },
      },
    };
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(entity);
  }

  /// Resource Pack client entity definition - uses ghast fireball visuals.
  static String _generateFireballEntityRP() {
    final entity = {
      'format_version': '1.10.0',
      'minecraft:client_entity': {
        'description': {
          'identifier': 'custom:gameforge_fireball',
          'textures': {'default': 'textures/entity/ghast/ghast_fireball'},
          'geometry': {'default': 'geometry.fireball'},
          'render_controllers': ['controller.render.default'],
        },
      },
    };
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(entity);
  }

  // ========== TEXTURE HELPERS ==========

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

  // ========== MANIFEST GENERATION ==========

  /// Generate behavior pack manifest.json
  /// When needsScript is true, adds script module + @minecraft/server dependency
  static Future<String> _generateBehaviorManifest(
    Project project,
    String headerUuid,
    String moduleUuid,
    String resourcePackUuid, {
    bool needsScript = false,
    String? scriptModuleUuid,
  }) async {
    // Load template
    final templateString = await rootBundle.loadString(
      'assets/templates/manifest_behavior.json',
    );

    // Parse JSON to modify programmatically
    final manifestMap = jsonDecode(templateString) as Map<String, dynamic>;

    // Dependencies: Resource Pack + optionally @minecraft/server
    final dependencies = <Map<String, dynamic>>[
      {
        'uuid': resourcePackUuid,
        'version': [0, 0, 1],
      }
    ];

    if (needsScript) {
      dependencies.add({
        'module_name': '@minecraft/server',
        'version': '1.16.0',
      });
    }
    manifestMap['dependencies'] = dependencies;

    // Add script module if needed
    if (needsScript && scriptModuleUuid != null) {
      final modules = manifestMap['modules'] as List<dynamic>;
      modules.add({
        'description': 'GameForge Script Module',
        'type': 'script',
        'language': 'javascript',
        'uuid': scriptModuleUuid,
        'version': [0, 0, 1],
        'entry': 'scripts/main.js',
      });
    }

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

  // ========== TEXTURE JSON ==========

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

  // ========== ITEM JSON EXPORT ==========

  /// Export a single ProjectItem as Minecraft Bedrock Edition item JSON
  /// Updated for format version 1.21.130+
  ///
  /// Abilities are implemented as "Bausteine" (building blocks):
  /// - Fire Aspect → custom:fire_aspect component (Script API)
  /// - Knockback → custom:knockback component (Script API)
  /// - Fireballs → custom:shoot_fireballs component + use_modifiers (Script API)
  /// - Movement Speed on weapons → handled by script interval (NOT attribute_modifiers!)
  static String _exportItemToMinecraftJSON(ProjectItem item, {bool needsScript = false}) {
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
    final nameColor = customStats['name_color'] as String? ?? 'white';
    final miningSpeed = (customStats['mining_speed'] as num?)?.toDouble() ?? 1.0;

    // Build components
    final components = <String, dynamic>{};

    // Display name mit Farbe (Minecraft Format Codes)
    final colorCode = _getMinecraftColorCode(nameColor);
    components['minecraft:display_name'] = {
      'value': '$colorCode${item.name}',
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

    // Damage (for weapons and tools) - Bedrock uses minecraft:damage component
    // Syntax: "minecraft:damage": value (direct number, NOT object!)
    if (damage > 0) {
      components['minecraft:damage'] = damage.toInt();
    }

    // Attribute modifiers (for armor and armor-only movement speed)
    final attributeModifiers = <Map<String, dynamic>>[];

    // Movement speed modifier - ONLY for armor items!
    // For weapons, movement speed is handled by Script API (addEffect)
    // because attribute_modifiers with movement_speed don't work on held items.
    if (movementSpeed != 0.0 && item.category.toLowerCase() != 'waffen') {
      final armorSlot = _getArmorSlot(item.baseItem?.type);
      if (armorSlot != null) {
        attributeModifiers.add({
          'attribute': 'minecraft:player.movement_speed',
          'amount': movementSpeed,
          'operation': 'add_multiplied_base',
          'slot': armorSlot,
        });
      }
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

    // ===== SPEZIAL-FÄHIGKEITEN (via world.afterEvents - keine custom:* Komponenten!) =====
    // Feueraspekt + Rückstoß werden in scripts/main.js via world.afterEvents.entityHurt behandelt.
    // Keine custom:* Komponenten nötig - Script erkennt die Item-ID direkt!
    final effects = item.effects;

    // Feuerbälle: use_modifiers damit Rechtsklick den itemUse event auslöst
    // Der Feuerball wird in main.js via world.beforeEvents.itemUse gespawnt
    if (effects['shoot_fireballs'] == true && needsScript) {
      components['minecraft:use_modifiers'] = {
        'use_duration': 0.5,
        'movement_modifier': 0.5,
      };
    }

    // Legacy effects
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

  // ========== HELPER METHODS ==========

  /// Sanitize project name to valid Minecraft identifier
  static String _sanitizeIdentifier(String name) {
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
        if (itemType == null) return 'armor_torso';

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
        return 'armor_torso';
      default:
        return null;
    }
  }

  /// Get Minecraft color code from color name
  static String _getMinecraftColorCode(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'white':
        return '§f';
      case 'red':
        return '§c';
      case 'gold':
        return '§6';
      case 'yellow':
        return '§e';
      case 'green':
        return '§a';
      case 'aqua':
        return '§b';
      case 'blue':
        return '§9';
      case 'light_purple':
        return '§d';
      case 'dark_purple':
        return '§5';
      default:
        return '§f';
    }
  }

  /// Get filename for .mcaddon export
  static String getAddonFilename(Project project) {
    final identifier = _sanitizeIdentifier(project.name);
    return '$identifier.mcaddon';
  }
}
