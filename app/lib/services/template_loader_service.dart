import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/template_definition.dart';

/// Service zum Laden von Templates aus assets/templates/
class TemplateLoaderService {
  static final TemplateLoaderService _instance =
      TemplateLoaderService._internal();
  factory TemplateLoaderService() => _instance;
  TemplateLoaderService._internal();

  // Cache für geladene Templates
  Map<String, TemplateDefinition>? _templates;
  bool _isLoaded = false;

  // Liste aller verfügbaren Template-IDs (Ordnernamen in assets/templates/)
  // TODO: Später aus einer Konfigurationsdatei laden
  static const List<String> _availableTemplates = [
    'base_defense',
  ];

  /// Lädt alle Templates aus assets/templates/
  Future<void> loadTemplates() async {
    if (_isLoaded) return; // Schon geladen

    _templates = {};

    for (final templateId in _availableTemplates) {
      try {
        // Lade template.json für dieses Template
        final String templateJsonPath =
            'assets/templates/$templateId/template.json';
        final String jsonString = await rootBundle.loadString(templateJsonPath);
        final Map<String, dynamic> json = jsonDecode(jsonString);

        // Erstelle TemplateDefinition
        final template = TemplateDefinition.fromJson(
          templateId,
          'assets/templates/$templateId',
          json,
        );

        _templates![templateId] = template;
        print('✅ Template geladen: $templateId (${template.name})');
      } catch (e) {
        print('❌ Fehler beim Laden von Template $templateId: $e');
        // Template überspringen, aber weiter laden
      }
    }

    _isLoaded = true;
    print('✅ ${_templates!.length} Templates geladen');
  }

  /// Gibt alle verfügbaren Templates zurück
  Future<List<TemplateDefinition>> getAllTemplates() async {
    await loadTemplates();
    return _templates?.values.toList() ?? [];
  }

  /// Gibt ein bestimmtes Template zurück
  Future<TemplateDefinition?> getTemplate(String templateId) async {
    await loadTemplates();
    return _templates?[templateId];
  }

  /// Prüft ob Templates geladen sind
  bool get isLoaded => _isLoaded;

  /// Cache zurücksetzen (für Testing)
  void reset() {
    _templates = null;
    _isLoaded = false;
  }
}
