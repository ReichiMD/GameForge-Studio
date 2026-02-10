/// Beschreibt ein einzelnes Eingabefeld im Template-Editor
class TemplateField {
  final String placeholder; // z.B. "{{CORE_HEALTH}}"
  final String label; // z.B. "Kern-Lebenspunkte"
  final String type; // "number" oder "text"
  final dynamic defaultValue; // Standard-Wert
  final int? min; // Minimum (nur für number)
  final int? max; // Maximum (nur für number)

  TemplateField({
    required this.placeholder,
    required this.label,
    required this.type,
    required this.defaultValue,
    this.min,
    this.max,
  });

  factory TemplateField.fromJson(Map<String, dynamic> json) {
    return TemplateField(
      placeholder: json['placeholder'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      defaultValue: json['default'],
      min: json['min'] as int?,
      max: json['max'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeholder': placeholder,
      'label': label,
      'type': type,
      'default': defaultValue,
      if (min != null) 'min': min,
      if (max != null) 'max': max,
    };
  }
}

/// Beschreibt ein komplettes Template (z.B. Base Defense)
class TemplateDefinition {
  final String id; // z.B. "base_defense" (Ordnername)
  final String name; // z.B. "Base Defense Survival"
  final String description; // z.B. "Ein komplettes Tower Defense Spiel..."
  final String category; // z.B. "gameplay"
  final List<TemplateField> editorFields; // Alle Eingabefelder
  final String templatePath; // Pfad zum Template-Ordner

  TemplateDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.editorFields,
    required this.templatePath,
  });

  factory TemplateDefinition.fromJson(
    String id,
    String templatePath,
    Map<String, dynamic> json,
  ) {
    return TemplateDefinition(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      templatePath: templatePath,
      editorFields: (json['editor_fields'] as List)
          .map((field) => TemplateField.fromJson(field as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'editor_fields': editorFields.map((f) => f.toJson()).toList(),
    };
  }
}
