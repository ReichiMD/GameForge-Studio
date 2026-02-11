import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../services/project_service.dart';
import '../services/template_loader_service.dart';
import 'debug_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const SettingsScreen({
    super.key,
    this.onLogout,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  String? _githubToken;
  bool _isDarkMode = true;
  String _buttonSize = 'Groß';
  String _language = 'Deutsch';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _githubToken = _prefs.getString('githubToken');
      _isDarkMode = _prefs.getBool('darkMode') ?? true;
      _buttonSize = _prefs.getString('buttonSize') ?? 'Groß';
      _language = _prefs.getString('language') ?? 'Deutsch';
      _isLoading = false;
    });
  }

  Future<void> _saveButtonSize(String size) async {
    await _prefs.setString('buttonSize', size);
    setState(() => _buttonSize = size);
  }

  Future<void> _saveLanguage(String lang) async {
    await _prefs.setString('language', lang);
    setState(() => _language = lang);
  }

  Future<void> _saveDarkMode(bool value) async {
    await _prefs.setBool('darkMode', value);
    setState(() => _isDarkMode = value);
  }

  Future<void> _showDeleteConfirmation() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Alle Projekte löschen?',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Diese Aktion kann nicht rückgängig gemacht werden. Alle deine Projekte werden gelöscht.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Abbrechen',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ProjectService().clearAllProjects();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alle Projekte gelöscht')),
                );
              }
            },
            child: const Text(
              'Löschen',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _reloadTemplates() async {
    // Zeige Loading-Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      // Lade Templates neu von GitHub
      final templateLoader = TemplateLoaderService();
      await templateLoader.reloadTemplates();

      // Schließe Loading-Dialog
      if (mounted) Navigator.pop(context);

      // Zeige Erfolgs-Snackbar
      if (mounted) {
        final templates = await templateLoader.getAllTemplates();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${templates.length} Templates aktualisiert'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      // Schließe Loading-Dialog
      if (mounted) Navigator.pop(context);

      // Zeige Fehler-Dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text(
              '❌ Fehler',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'Templates konnten nicht geladen werden.\n\n'
              'Fehler: $e\n\n'
              'Bitte überprüfe deine Internetverbindung.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: const Row(
        children: [
          Text('⚙️', style: TextStyle(fontSize: 28)),
          SizedBox(width: AppSpacing.md),
          Text(
            'Einstellungen',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // GitHub Verbindung
          _buildSectionTitle('🔗 GITHUB VERBINDUNG'),
          const SizedBox(height: AppSpacing.lg),
          _buildSettingsCard(
            title: 'GitHub Token',
            subtitle: _githubToken != null
                ? '●●●●●●●●●●●●●●●●●●●●●●●●'
                : 'Nicht verbunden',
            icon: '🔑',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSettingsCard(
            title: 'Repository',
            subtitle: 'GameForge-Studio',
            icon: '📁',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildStatusCard(
            title: 'Werkstatt Status',
            status: 'Verbunden',
            statusColor: AppColors.success,
            icon: '🔗',
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Darstellung
          _buildSectionTitle('🎨 DARSTELLUNG'),
          const SizedBox(height: AppSpacing.lg),
          _buildToggleSetting(
            title: 'Dark Mode',
            value: _isDarkMode,
            onChanged: _saveDarkMode,
            icon: '🌙',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDropdownSetting(
            title: 'Button Größe',
            value: _buttonSize,
            options: ['Klein (44px)', 'Medium (60px)', 'Groß (60px)'],
            displayOptions: ['Klein', 'Medium', 'Groß'],
            onChanged: _saveButtonSize,
            icon: '📏',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDropdownSetting(
            title: 'Sprache',
            value: _language,
            options: ['Deutsch', 'English'],
            displayOptions: ['Deutsch', 'English'],
            onChanged: _saveLanguage,
            icon: '🌍',
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Info
          _buildSectionTitle('ℹ️ INFO'),
          const SizedBox(height: AppSpacing.lg),
          _buildSettingsCard(
            title: 'App Version',
            subtitle: '0.0.1',
            icon: '📱',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildClickableCard(
            title: 'Hilfe',
            subtitle: 'Anleitung und FAQs',
            icon: '❓',
            onTap: () => _showHelpDialog(),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildClickableCard(
            title: 'Feedback',
            subtitle: 'Schreib uns deine Gedanken',
            icon: '💬',
            onTap: () => _showFeedbackDialog(),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Entwickler-Tools
          _buildSectionTitle('🔧 ENTWICKLER-TOOLS'),
          const SizedBox(height: AppSpacing.lg),
          _buildClickableCard(
            title: 'Debug-Informationen',
            subtitle: 'Technische Logs für Fehlersuche',
            icon: '🐛',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DebugScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Templates
          _buildSectionTitle('🎮 TEMPLATES'),
          const SizedBox(height: AppSpacing.lg),
          _buildClickableCard(
            title: 'Templates aktualisieren',
            subtitle: 'Neue Templates von GitHub laden',
            icon: '🔄',
            onTap: _reloadTemplates,
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Logout
          ElevatedButton(
            onPressed: widget.onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.text,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🚪', style: TextStyle(fontSize: 24)),
                SizedBox(width: AppSpacing.md),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Gefahrenzone
          _buildSectionTitle('⚠️ GEFAHRENZONE'),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: _showDeleteConfirmation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.text,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🗑️', style: TextStyle(fontSize: 24)),
                SizedBox(width: AppSpacing.md),
                Text(
                  'Alle Projekte löschen',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String status,
    required Color statusColor,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 13,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.lg),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting({
    required String title,
    required String value,
    required List<String> options,
    required List<String> displayOptions,
    required Function(String) onChanged,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.lg),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            dropdownColor: AppColors.surface,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
            items: List.generate(options.length, (index) {
              return DropdownMenuItem(
                value: options[index],
                child: Text(displayOptions[index]),
              );
            }),
            onChanged: (newValue) {
              if (newValue != null) onChanged(newValue);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClickableCard({
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          '❓ Hilfe',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'GameForge Studio hilft dir, Minecraft Add-ons zu erstellen!\n\n'
            '1. Erstelle ein neues Projekt\n'
            '2. Wähle deine Items aus\n'
            '3. Bearbeite die Eigenschaften\n'
            '4. Speichern und teilen!\n\n'
            'Weitere Hilfe findest du auf GitHub.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          '💬 Feedback',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Dein Feedback ist wichtig für uns! Schreib uns auf GitHub oder per Email.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
