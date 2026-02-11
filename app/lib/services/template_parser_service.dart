import 'package:uuid/uuid.dart';

/// Service zum Ersetzen von Platzhaltern in Template-Dateien
class TemplateParserService {
  static final TemplateParserService _instance =
      TemplateParserService._internal();
  factory TemplateParserService() => _instance;
  TemplateParserService._internal();

  final _uuid = const Uuid();

  /// Ersetzt alle Platzhalter in einem String
  ///
  /// Ersetzt sowohl User-Werte (aus fieldValues) als auch System-Werte:
  /// - {{PROJECT_NAME}} - Projekt-Name (klein, ohne Leerzeichen)
  /// - {{DESCRIPTION}} - Projekt-Beschreibung
  /// - Alle anderen Platzhalter aus fieldValues (inkl. UUIDs)
  ///
  /// WICHTIG: UUIDs werden vom TemplateBuilderService generiert und
  /// über fieldValues übergeben, damit alle Dateien die gleichen UUIDs verwenden!
  String replacePlaceholders(
    String content,
    String projectName,
    String projectDescription,
    Map<String, dynamic> fieldValues,
  ) {
    String result = content;

    // System-Platzhalter ersetzen (PROJECT_NAME und DESCRIPTION)
    final systemPlaceholders = {
      '{{PROJECT_NAME}}': _sanitizeProjectName(projectName),
      '{{DESCRIPTION}}': projectDescription,
    };

    systemPlaceholders.forEach((placeholder, value) {
      result = result.replaceAll(placeholder, value.toString());
    });

    // User-Platzhalter + UUIDs ersetzen (aus fieldValues)
    fieldValues.forEach((placeholder, value) {
      result = result.replaceAll(placeholder, value.toString());
    });

    return result;
  }

  /// Macht aus "Mein Projekt" -> "mein_projekt" (für IDs)
  String _sanitizeProjectName(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), ''); // Entferne _ am Anfang/Ende
  }

  /// Prüft ob ein String Platzhalter enthält
  bool hasPlaceholders(String content) {
    return RegExp(r'\{\{[A-Z_]+\}\}').hasMatch(content);
  }

  /// Findet alle Platzhalter in einem String
  List<String> findPlaceholders(String content) {
    final regex = RegExp(r'\{\{([A-Z_]+)\}\}');
    final matches = regex.allMatches(content);
    return matches.map((m) => m.group(0)!).toList();
  }
}
