import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../models/template_definition.dart';
import '../services/template_builder_service.dart';

class TemplateEditorScreen extends StatefulWidget {
  final TemplateDefinition template;

  const TemplateEditorScreen({super.key, required this.template});

  @override
  State<TemplateEditorScreen> createState() => _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends State<TemplateEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _templateBuilder = TemplateBuilderService();

  // Werte für Template-Felder (Platzhalter -> Wert)
  final Map<String, dynamic> _fieldValues = {};
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    // Standard-Werte setzen
    _projectDescriptionController.text = widget.template.description;
    for (final field in widget.template.editorFields) {
      _fieldValues[field.placeholder] = field.defaultValue;
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleExport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      // Addon exportieren
      final filePath = await _templateBuilder.buildAddon(
        template: widget.template,
        projectName: _projectNameController.text.trim(),
        projectDescription: _projectDescriptionController.text.trim(),
        fieldValues: _fieldValues,
      );

      if (mounted) {
        setState(() {
          _isExporting = false;
        });

        // Erfolgs-Dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF374151),
            title: const Text(
              '✅ Addon erstellt!',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Dein Addon wurde gespeichert:\n$filePath',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true); // Zurück zum HomeScreen
                },
                child: const Text('Fertig'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });

        // Fehler-Dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF374151),
            title: const Text(
              '❌ Fehler',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Addon konnte nicht erstellt werden:\n$e',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildForm(context),
            ),
            _buildExportButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            iconSize: 28,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.template.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.template.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Projekt-Name
          _buildTextField(
            controller: _projectNameController,
            label: 'Projekt-Name',
            hint: 'z.B. Meine Base Defense',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Bitte gib einen Namen ein';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Projekt-Beschreibung
          _buildTextField(
            controller: _projectDescriptionController,
            label: 'Beschreibung',
            hint: 'Was macht dein Addon?',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Überschrift für Template-Felder
          const Text(
            'Einstellungen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Dynamische Template-Felder
          ...widget.template.editorFields.map((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildTemplateField(field),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30),
            filled: true,
            fillColor: const Color(0xFF374151),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateField(TemplateField field) {
    if (field.type == 'number') {
      return _buildNumberField(field);
    } else {
      return _buildTextFieldForTemplate(field);
    }
  }

  Widget _buildNumberField(TemplateField field) {
    // Prüfe ob Dezimalzahlen unterstützt werden
    final isDecimal = (field.min is double) ||
                      (field.max is double) ||
                      (field.defaultValue is double);

    // Min/Max Werte als double
    final minValue = (field.min ?? 0).toDouble();
    final maxValue = (field.max ?? 100).toDouble();
    final currentValue = (_fieldValues[field.placeholder] as num).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                field.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isDecimal
                    ? currentValue.toStringAsFixed(1)
                    : currentValue.toInt().toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Text(
              isDecimal ? minValue.toStringAsFixed(0) : minValue.toInt().toString(),
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.primary.withOpacity(0.3),
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withOpacity(0.2),
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                ),
                child: Slider(
                  value: currentValue.clamp(minValue, maxValue),
                  min: minValue,
                  max: maxValue,
                  divisions: isDecimal
                      ? ((maxValue - minValue) * 10).toInt()
                      : (maxValue - minValue).toInt(),
                  onChanged: (value) {
                    setState(() {
                      _fieldValues[field.placeholder] = isDecimal
                          ? double.parse(value.toStringAsFixed(1))
                          : value.toInt();
                    });
                  },
                ),
              ),
            ),
            Text(
              isDecimal ? maxValue.toStringAsFixed(0) : maxValue.toInt().toString(),
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFieldForTemplate(TemplateField field) {
    final controller = TextEditingController(
      text: _fieldValues[field.placeholder].toString(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF374151),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _fieldValues[field.placeholder] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: Color(0xFF1F2937),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isExporting ? null : _handleExport,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isExporting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Erstelle Addon...',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.file_download),
                      SizedBox(width: 8),
                      Text(
                        'Addon exportieren',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
