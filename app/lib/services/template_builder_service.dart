import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models/template_definition.dart';
import 'template_parser_service.dart';

/// Service zum Erstellen von Addons aus Templates
class TemplateBuilderService {
  final _parser = TemplateParserService();

  /// Erstellt ein .mcaddon aus einem Template
  /// Returns: Dateipfad zur gespeicherten .mcaddon Datei
  Future<String> buildAddon({
    required TemplateDefinition template,
    required String projectName,
    required String projectDescription,
    required Map<String, dynamic> fieldValues,
  }) async {
    print('📦 Starte Template-Addon Export...');
    print('Template: ${template.name}');
    print('Projekt: $projectName');

    // 1. UUIDs einmalig generieren (damit alle Dateien die gleichen UUIDs verwenden)
    final uuidGenerator = const Uuid();
    final generatedUUIDs = {
      '{{HEADER_UUID}}': uuidGenerator.v4(),
      '{{MODULE_UUID}}': uuidGenerator.v4(),
      '{{RESOURCE_PACK_UUID}}': uuidGenerator.v4(),
      '{{RESOURCE_MODULE_UUID}}': uuidGenerator.v4(),
    };

    // 2. Alle UUIDs zu fieldValues hinzufügen
    final allFieldValues = {...fieldValues, ...generatedUUIDs};

    // 3. Alle Dateien im Template laden
    final templateFiles = await _loadTemplateFiles(template);
    print('✅ ${templateFiles.length} Template-Dateien geladen');

    // 4. ZIP-Archive erstellen
    final archive = Archive();

    // 5. Alle Dateien verarbeiten und zum Archive hinzufügen
    for (final entry in templateFiles.entries) {
      final filePath = entry.key;
      final content = entry.value;

      // Platzhalter ersetzen
      final processedContent = _parser.replacePlaceholders(
        content,
        projectName,
        projectDescription,
        allFieldValues,
      );

      // Datei zum Archive hinzufügen
      final bytes = utf8.encode(processedContent);
      archive.addFile(
        ArchiveFile(
          filePath,
          bytes.length,
          bytes,
        ),
      );
      print('  ✓ $filePath');
    }

    // 4. Pack Icon hinzufügen (PNG ist binär, keine Platzhalter-Ersetzung)
    try {
      final iconUrl = '${template.templatePath}/pack_icon.png';
      final response = await http.get(Uri.parse(iconUrl));

      if (response.statusCode == 200) {
        final iconData = response.bodyBytes;

        // Icon für beide Packs
        archive.addFile(
          ArchiveFile(
            'behavior_pack/pack_icon.png',
            iconData.length,
            iconData,
          ),
        );
        archive.addFile(
          ArchiveFile(
            'resource_pack/pack_icon.png',
            iconData.length,
            iconData,
          ),
        );
        print('  ✓ pack_icon.png (beide Packs)');
      } else {
        print('  ⚠️  Kein pack_icon.png gefunden (HTTP ${response.statusCode})');
      }
    } catch (e) {
      print('  ⚠️  Kein pack_icon.png gefunden (optional): $e');
    }

    // 5. ZIP komprimieren
    final zipBytes = ZipEncoder().encode(archive);
    if (zipBytes == null) {
      throw Exception('ZIP-Erstellung fehlgeschlagen');
    }

    // 6. Im Downloads-Ordner speichern
    final fileName = await _saveToDownloads(
      Uint8List.fromList(zipBytes),
      projectName,
    );

    print('✅ Addon erstellt: $fileName');
    return fileName;
  }

  /// Lädt alle Template-Dateien von GitHub
  /// Returns: Map<filePath, content>
  Future<Map<String, String>> _loadTemplateFiles(
      TemplateDefinition template) async {
    final files = <String, String>{};

    // File lists für jedes Template
    final filePaths = _getTemplateFilePaths(template.id);

    for (final filePath in filePaths) {
      try {
        // GitHub URL: template.templatePath ist bereits die vollständige URL
        final url = '${template.templatePath}/$filePath';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          files[filePath] = utf8.decode(response.bodyBytes);
        } else {
          print('⚠️  Fehler beim Laden von $filePath: HTTP ${response.statusCode}');
        }
      } catch (e) {
        print('⚠️  Fehler beim Laden von $filePath: $e');
        // Datei überspringen
      }
    }

    return files;
  }

  /// Gibt die Dateiliste für ein bestimmtes Template zurück
  List<String> _getTemplateFilePaths(String templateId) {
    switch (templateId) {
      case 'leveling_wolf':
        return [
          // Behavior Pack
          'behavior_pack/manifest.json',
          'behavior_pack/entities/wolf.json',
          // Resource Pack
          'resource_pack/manifest.json',
          'resource_pack/entity/wolf.entity.json',
        ];

      case 'base_defense':
        return [
          // Behavior Pack
          'behavior_pack/manifest.json',
          'behavior_pack/entities/defense_core.json',
          'behavior_pack/entities/defense_turret.json',
          'behavior_pack/entities/attacker_mob.json',
          'behavior_pack/items/base_starter.json',
          'behavior_pack/items/defense_turret_item.json',
          'behavior_pack/loot_tables/attacker_rewards.json',
          'behavior_pack/recipes/base_starter_recipe.json',
          'behavior_pack/animation_controllers/core_setup.controller.json',
          'behavior_pack/functions/starter_kit.mcfunction',
          'behavior_pack/functions/tick.json',
          // Resource Pack
          'resource_pack/manifest.json',
          'resource_pack/entity/defense_core.entity.json',
          'resource_pack/entity/defense_turret.entity.json',
          'resource_pack/entity/attacker_mob.entity.json',
          'resource_pack/texts/en_US.lang',
          'resource_pack/textures/item_texture.json',
        ];

      default:
        print('⚠️  Unbekanntes Template: $templateId - verwende leere Liste');
        return [];
    }
  }

  /// Speichert ZIP im Downloads-Ordner
  /// Auf Android 10+ (API 29+) keine Permission nötig!
  Future<String> _saveToDownloads(Uint8List zipBytes, String projectName) async {
    // Downloads-Ordner ermitteln
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      // Direkter Zugriff auf Downloads - funktioniert auf Android 10+ ohne Permission!
      downloadsDir = Directory('/storage/emulated/0/Download');

      // Ordner erstellen falls nicht existent
      if (!downloadsDir.existsSync()) {
        try {
          downloadsDir.createSync(recursive: true);
        } catch (e) {
          throw Exception('Downloads-Ordner konnte nicht erstellt werden: $e');
        }
      }
    } else {
      downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception('Downloads-Ordner nicht gefunden');
      }
    }

    // Dateiname generieren
    final sanitizedName = projectName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${sanitizedName}_$timestamp.mcaddon';
    final filePath = '${downloadsDir.path}/$fileName';

    // Datei schreiben
    try {
      final file = File(filePath);
      await file.writeAsBytes(zipBytes);
      print('✅ Datei gespeichert: $filePath');
      return filePath;
    } catch (e) {
      throw Exception('Datei konnte nicht gespeichert werden: $e');
    }
  }
}
