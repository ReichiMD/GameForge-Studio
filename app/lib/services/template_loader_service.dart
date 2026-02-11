import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/template_definition.dart';
import 'debug_log_service.dart';

/// Service zum Laden von Templates von GitHub
class TemplateLoaderService {
  static final TemplateLoaderService _instance =
      TemplateLoaderService._internal();
  factory TemplateLoaderService() => _instance;
  TemplateLoaderService._internal();

  final _debugLog = DebugLogService();

  // GitHub Repository URL (raw content)
  // TEMPORÄR: Feature-Branch für Testing - später auf 'main' ändern!
  static const String _baseUrl =
      'https://raw.githubusercontent.com/ReichiMD/GameForge-Studio/main/templates';

  // Cache für geladene Templates
  Map<String, TemplateDefinition>? _templates;
  bool _isLoaded = false;
  bool _isLoading = false;

  // SharedPreferences Keys
  static const String _cacheKeyPrefix = 'template_';
  static const String _cacheKeyIndex = 'template_index';
  static const String _cacheKeyTimestamp = 'template_timestamp';

  /// Lädt alle Templates von GitHub (mit Caching)
  Future<void> loadTemplates({bool forceReload = false}) async {
    if (_isLoaded && !forceReload) return; // Schon geladen
    if (_isLoading) return; // Bereits am Laden

    _isLoading = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Versuche zuerst aus Cache zu laden (wenn nicht forceReload)
      if (!forceReload) {
        final cachedTemplates = await _loadFromCache(prefs);
        if (cachedTemplates != null) {
          _templates = cachedTemplates;
          _isLoaded = true;
          _isLoading = false;
          print('✅ ${_templates!.length} Templates aus Cache geladen');
          return;
        }
      }

      // Lade von GitHub
      _templates = {};

      // 1. Lade index.json für Template-Liste
      final templateIds = await _loadTemplateIndex();

      // 2. Lade jedes Template
      for (final templateId in templateIds) {
        try {
          final template = await _loadTemplateFromGitHub(templateId);
          _templates![templateId] = template;
          print('✅ Template geladen: $templateId (${template.name})');
        } catch (e) {
          print('❌ Fehler beim Laden von Template $templateId: $e');
          // Template überspringen, aber weiter laden
        }
      }

      // 3. Templates im Cache speichern
      await _saveToCache(prefs);

      _isLoaded = true;
      print('✅ ${_templates!.length} Templates von GitHub geladen');
    } catch (e) {
      print('❌ Fehler beim Laden der Templates: $e');
      // Versuche aus Cache zu laden als Fallback
      final prefs = await SharedPreferences.getInstance();
      final cachedTemplates = await _loadFromCache(prefs);
      if (cachedTemplates != null) {
        _templates = cachedTemplates;
        _isLoaded = true;
        print('⚠️ Fallback: ${_templates!.length} Templates aus Cache geladen');
      } else {
        _templates = {};
        _isLoaded = false;
      }
    } finally {
      _isLoading = false;
    }
  }

  /// Lädt die Template-Liste von index.json
  Future<List<String>> _loadTemplateIndex() async {
    final url = '$_baseUrl/index.json';
    _debugLog.addLog(
      level: 'INFO',
      category: 'TEMPLATE',
      message: 'Loading template index',
      data: {'url': url},
    );

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final templates = (json['templates'] as List).cast<String>();
      print('✅ Template-Index geladen: ${templates.length} Templates gefunden');
      _debugLog.logTemplateIndexLoad(templates.length, 'GitHub');
      return templates;
    } else {
      final error = 'HTTP ${response.statusCode}';
      _debugLog.addLog(
        level: 'ERROR',
        category: 'TEMPLATE',
        message: 'Failed to load template index',
        data: {'url': url, 'statusCode': response.statusCode},
      );
      throw Exception('Fehler beim Laden von index.json: $error');
    }
  }

  /// Lädt ein einzelnes Template von GitHub
  Future<TemplateDefinition> _loadTemplateFromGitHub(String templateId) async {
    _debugLog.logTemplateLoadAttempt(templateId);

    final url = '$_baseUrl/$templateId/template.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final template = TemplateDefinition.fromJson(
        templateId,
        '$_baseUrl/$templateId',
        json,
      );
      _debugLog.logTemplateLoadSuccess(templateId, template.name);
      return template;
    } else {
      final error = Exception('HTTP ${response.statusCode}');
      _debugLog.logTemplateLoadError(templateId, error);
      throw Exception(
          'Fehler beim Laden von template.json für $templateId: ${response.statusCode}');
    }
  }

  /// Lädt Templates aus Cache
  Future<Map<String, TemplateDefinition>?> _loadFromCache(
      SharedPreferences prefs) async {
    try {
      // Prüfe ob Cache existiert
      final indexJson = prefs.getString(_cacheKeyIndex);
      if (indexJson == null) return null;

      final templateIds = (jsonDecode(indexJson) as List).cast<String>();
      final templates = <String, TemplateDefinition>{};

      for (final templateId in templateIds) {
        final cacheKey = '$_cacheKeyPrefix$templateId';
        final templateJson = prefs.getString(cacheKey);
        if (templateJson != null) {
          final json = jsonDecode(templateJson) as Map<String, dynamic>;
          templates[templateId] = TemplateDefinition.fromJson(
            templateId,
            '$_baseUrl/$templateId',
            json,
          );
        }
      }

      if (templates.isEmpty) return null;

      _debugLog.logTemplateCacheHit(templates.length);
      return templates;
    } catch (e) {
      print('❌ Fehler beim Laden aus Cache: $e');
      _debugLog.addLog(
        level: 'ERROR',
        category: 'CACHE',
        message: 'Failed to load templates from cache',
        data: {'error': e.toString()},
      );
      return null;
    }
  }

  /// Speichert Templates im Cache
  Future<void> _saveToCache(SharedPreferences prefs) async {
    try {
      if (_templates == null || _templates!.isEmpty) return;

      // Speichere Index
      final templateIds = _templates!.keys.toList();
      await prefs.setString(_cacheKeyIndex, jsonEncode(templateIds));

      // Speichere jedes Template
      for (final entry in _templates!.entries) {
        final cacheKey = '$_cacheKeyPrefix${entry.key}';
        final templateJson = jsonEncode({
          'name': entry.value.name,
          'description': entry.value.description,
          'category': entry.value.category,
          'editor_fields': entry.value.editorFields
              .map((f) => {
                    'placeholder': f.placeholder,
                    'label': f.label,
                    'type': f.type,
                    'default': f.defaultValue,
                    if (f.min != null) 'min': f.min,
                    if (f.max != null) 'max': f.max,
                  })
              .toList(),
        });
        await prefs.setString(cacheKey, templateJson);
      }

      // Speichere Timestamp
      await prefs.setInt(_cacheKeyTimestamp,
          DateTime.now().millisecondsSinceEpoch);

      print('✅ Templates im Cache gespeichert');
    } catch (e) {
      print('❌ Fehler beim Speichern im Cache: $e');
    }
  }

  /// Lädt Templates neu von GitHub (erzwingt Reload)
  Future<void> reloadTemplates() async {
    print('🔄 Templates werden neu geladen...');
    _isLoaded = false;
    await loadTemplates(forceReload: true);
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

  /// Prüft ob Templates gerade geladen werden
  bool get isLoading => _isLoading;

  /// Cache zurücksetzen (für Testing)
  Future<void> reset() async {
    _templates = null;
    _isLoaded = false;
    _isLoading = false;

    // Lösche auch Cache
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_cacheKeyPrefix) || key == _cacheKeyIndex) {
        await prefs.remove(key);
      }
    }
    print('✅ Template-Cache gelöscht');
  }

  /// Gibt das Alter des Caches zurück (in Stunden)
  Future<int?> getCacheAge() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_cacheKeyTimestamp);
    if (timestamp == null) return null;

    final age =
        DateTime.now().millisecondsSinceEpoch - timestamp;
    return (age / (1000 * 60 * 60)).round(); // Stunden
  }
}
