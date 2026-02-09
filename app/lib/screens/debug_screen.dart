import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/debug_log_service.dart';
import '../theme/app_colors.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final _debugService = DebugLogService();
  bool _autoRefresh = true;

  @override
  void initState() {
    super.initState();
    // Auto-refresh every 2 seconds if enabled
    if (_autoRefresh) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _autoRefresh) {
          setState(() {});
          initState(); // Recursive refresh
        }
      });
    }
  }

  Future<void> _copyLogsToClipboard() async {
    final text = _debugService.exportLogsAsText();
    await Clipboard.setData(ClipboardData(text: text));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📋 Debug-Logs in Zwischenablage kopiert!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logs löschen?'),
        content: const Text(
          'Möchtest du alle Debug-Logs löschen? Dies kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              _debugService.clearLogs();
              Navigator.pop(context);
              setState(() {});
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = _debugService.getStatistics();
    final logs = _debugService.logs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 Debug-Informationen'),
        actions: [
          IconButton(
            icon: Icon(_autoRefresh ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                _autoRefresh = !_autoRefresh;
              });
            },
            tooltip: _autoRefresh ? 'Auto-Refresh pausieren' : 'Auto-Refresh starten',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Aktualisieren',
          ),
        ],
      ),
      body: Column(
        children: [
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _copyLogsToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text('📋 Alle Logs kopieren'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _clearLogs,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Löschen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 50),
                  ),
                ),
              ],
            ),
          ),

          // Statistics Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 Statistiken',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatRow('Total Logs', stats['totalLogs'].toString()),
                _buildStatRow('Image Load Attempts', stats['imageLoadAttempts'].toString()),
                _buildStatRow('Image Load Successes', stats['imageLoadSuccesses'].toString(), color: AppColors.success),
                _buildStatRow('Image Load Errors', stats['imageLoadErrors'].toString(), color: AppColors.error),
                _buildStatRow('Success Rate', '${stats['successRate']}%'),
                _buildStatRow('Unique URLs Attempted', stats['uniqueUrlsAttempted'].toString()),
                if (stats['errorTypes'] is Map && (stats['errorTypes'] as Map).isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Error Types:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  ...(stats['errorTypes'] as Map).entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                      child: Text(
                        '• ${entry.key}: ${entry.value}x',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Logs Section
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📝 Recent Logs (${logs.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_autoRefresh)
                        const Text(
                          'Auto-Refresh: ON',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.success,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: logs.isEmpty
                        ? const Center(
                            child: Text(
                              'Keine Logs vorhanden.\nVerwende die App, um Logs zu generieren.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            itemCount: logs.length,
                            itemBuilder: (context, index) {
                              final log = logs[index];
                              return _buildLogEntry(log);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntry(DebugLogEntry log) {
    Color levelColor;
    IconData levelIcon;

    switch (log.level) {
      case 'ERROR':
        levelColor = AppColors.error;
        levelIcon = Icons.error;
        break;
      case 'WARNING':
        levelColor = Colors.orange;
        levelIcon = Icons.warning;
        break;
      default:
        levelColor = AppColors.info;
        levelIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: levelColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(levelIcon, size: 14, color: levelColor),
              const SizedBox(width: 6),
              Text(
                log.level,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: levelColor,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  log.category,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}:${log.timestamp.second.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Message
          Text(
            log.message,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
          // Data
          if (log.data != null && log.data!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: log.data!.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      '${entry.key}: ${_formatValue(entry.value)}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value is String && value.length > 100) {
      return '${value.substring(0, 100)}...';
    }
    return value.toString();
  }
}
