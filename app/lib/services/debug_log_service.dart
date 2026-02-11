import 'package:flutter/foundation.dart';

/// Debug Log Entry Model
class DebugLogEntry {
  final DateTime timestamp;
  final String level; // INFO, WARNING, ERROR
  final String category; // NETWORK, CACHE, PERMISSION, GENERAL
  final String message;
  final Map<String, dynamic>? data;

  DebugLogEntry({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.data,
  });

  String toFormattedString() {
    final timeStr = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
    final dataStr = data != null ? '\n  Data: ${data.toString()}' : '';
    return '[$timeStr] [$level] [$category] $message$dataStr';
  }
}

/// Singleton Debug Log Service
/// Sammelt alle Debug-Informationen für Fehlersuche
class DebugLogService {
  static final DebugLogService _instance = DebugLogService._internal();
  factory DebugLogService() => _instance;
  DebugLogService._internal();

  final List<DebugLogEntry> _logs = [];
  final int maxLogs = 500; // Maximal 500 Logs speichern

  // Statistics
  int _imageLoadAttempts = 0;
  int _imageLoadSuccesses = 0;
  int _imageLoadErrors = 0;
  final Set<String> _attemptedUrls = {};
  final Map<String, int> _errorCounts = {};

  // Template Statistics
  int _templateLoadAttempts = 0;
  int _templateLoadSuccesses = 0;
  int _templateLoadErrors = 0;
  int _templateCacheHits = 0;
  final Set<String> _loadedTemplateIds = {};
  String? _lastTemplateError;

  /// Add a log entry
  void addLog({
    required String level,
    required String category,
    required String message,
    Map<String, dynamic>? data,
  }) {
    final entry = DebugLogEntry(
      timestamp: DateTime.now(),
      level: level,
      category: category,
      message: message,
      data: data,
    );

    _logs.insert(0, entry); // Neueste zuerst

    // Limit log size
    if (_logs.length > maxLogs) {
      _logs.removeLast();
    }

    // Log to console in debug mode
    if (kDebugMode) {
      debugPrint('[DebugLog] ${entry.toFormattedString()}');
    }
  }

  /// Log image loading attempt
  void logImageLoadAttempt(String url) {
    _imageLoadAttempts++;
    _attemptedUrls.add(url);
    addLog(
      level: 'INFO',
      category: 'NETWORK',
      message: 'Image load attempt',
      data: {'url': url, 'attemptNumber': _imageLoadAttempts},
    );
  }

  /// Log image loading success
  void logImageLoadSuccess(String url) {
    _imageLoadSuccesses++;
    addLog(
      level: 'INFO',
      category: 'NETWORK',
      message: 'Image loaded successfully',
      data: {'url': url},
    );
  }

  /// Log image loading error
  void logImageLoadError(String url, Object error, {StackTrace? stackTrace}) {
    _imageLoadErrors++;

    // Count error types
    final errorType = error.runtimeType.toString();
    _errorCounts[errorType] = (_errorCounts[errorType] ?? 0) + 1;

    addLog(
      level: 'ERROR',
      category: 'NETWORK',
      message: 'Image load failed',
      data: {
        'url': url,
        'error': error.toString(),
        'errorType': errorType,
        'stackTrace': stackTrace?.toString(),
      },
    );
  }

  /// Log cache info
  void logCacheInfo(String message, {Map<String, dynamic>? data}) {
    addLog(
      level: 'INFO',
      category: 'CACHE',
      message: message,
      data: data,
    );
  }

  /// Log permission info
  void logPermissionInfo(String message, {Map<String, dynamic>? data}) {
    addLog(
      level: 'INFO',
      category: 'PERMISSION',
      message: message,
      data: data,
    );
  }

  /// Log template loading attempt
  void logTemplateLoadAttempt(String templateId) {
    _templateLoadAttempts++;
    addLog(
      level: 'INFO',
      category: 'TEMPLATE',
      message: 'Template load attempt',
      data: {'templateId': templateId, 'attemptNumber': _templateLoadAttempts},
    );
  }

  /// Log template loading success
  void logTemplateLoadSuccess(String templateId, String name) {
    _templateLoadSuccesses++;
    _loadedTemplateIds.add(templateId);
    addLog(
      level: 'INFO',
      category: 'TEMPLATE',
      message: 'Template loaded successfully',
      data: {'templateId': templateId, 'name': name},
    );
  }

  /// Log template loading error
  void logTemplateLoadError(String templateId, Object error, {StackTrace? stackTrace}) {
    _templateLoadErrors++;
    _lastTemplateError = error.toString();

    final errorType = error.runtimeType.toString();
    _errorCounts[errorType] = (_errorCounts[errorType] ?? 0) + 1;

    addLog(
      level: 'ERROR',
      category: 'TEMPLATE',
      message: 'Template load failed',
      data: {
        'templateId': templateId,
        'error': error.toString(),
        'errorType': errorType,
        'stackTrace': stackTrace?.toString(),
      },
    );
  }

  /// Log template cache hit
  void logTemplateCacheHit(int count) {
    _templateCacheHits++;
    addLog(
      level: 'INFO',
      category: 'CACHE',
      message: 'Templates loaded from cache',
      data: {'count': count, 'totalCacheHits': _templateCacheHits},
    );
  }

  /// Log template index loading
  void logTemplateIndexLoad(int count, String source) {
    addLog(
      level: 'INFO',
      category: 'TEMPLATE',
      message: 'Template index loaded',
      data: {'count': count, 'source': source},
    );
  }

  /// Get all logs
  List<DebugLogEntry> get logs => List.unmodifiable(_logs);

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalLogs': _logs.length,
      // Image Statistics
      'imageLoadAttempts': _imageLoadAttempts,
      'imageLoadSuccesses': _imageLoadSuccesses,
      'imageLoadErrors': _imageLoadErrors,
      'imageSuccessRate': _imageLoadAttempts > 0
          ? ((_imageLoadSuccesses / _imageLoadAttempts) * 100).toStringAsFixed(1)
          : '0.0',
      'uniqueUrlsAttempted': _attemptedUrls.length,
      // Template Statistics
      'templateLoadAttempts': _templateLoadAttempts,
      'templateLoadSuccesses': _templateLoadSuccesses,
      'templateLoadErrors': _templateLoadErrors,
      'templateSuccessRate': _templateLoadAttempts > 0
          ? ((_templateLoadSuccesses / _templateLoadAttempts) * 100).toStringAsFixed(1)
          : '0.0',
      'templateCacheHits': _templateCacheHits,
      'loadedTemplates': _loadedTemplateIds.length,
      'loadedTemplateIds': _loadedTemplateIds.toList(),
      'lastTemplateError': _lastTemplateError,
      // Error Types
      'errorTypes': _errorCounts,
    };
  }

  /// Get all attempted URLs
  List<String> get attemptedUrls => _attemptedUrls.toList();

  /// Clear all logs
  void clearLogs() {
    _logs.clear();
    _imageLoadAttempts = 0;
    _imageLoadSuccesses = 0;
    _imageLoadErrors = 0;
    _attemptedUrls.clear();
    _templateLoadAttempts = 0;
    _templateLoadSuccesses = 0;
    _templateLoadErrors = 0;
    _templateCacheHits = 0;
    _loadedTemplateIds.clear();
    _lastTemplateError = null;
    _errorCounts.clear();
    addLog(
      level: 'INFO',
      category: 'GENERAL',
      message: 'Debug logs cleared',
    );
  }

  /// Export all logs as formatted text
  String exportLogsAsText() {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('=== GameForge Studio Debug Log ===');
    buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
    buffer.writeln('');

    // Statistics
    buffer.writeln('--- Statistics ---');
    final stats = getStatistics();
    stats.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    buffer.writeln('');

    // Attempted URLs
    if (_attemptedUrls.isNotEmpty) {
      buffer.writeln('--- Attempted URLs (${_attemptedUrls.length}) ---');
      for (final url in _attemptedUrls.take(20)) {
        buffer.writeln('  - $url');
      }
      if (_attemptedUrls.length > 20) {
        buffer.writeln('  ... and ${_attemptedUrls.length - 20} more');
      }
      buffer.writeln('');
    }

    // Recent logs
    buffer.writeln('--- Recent Logs (${_logs.length}) ---');
    for (final log in _logs.take(100)) {
      buffer.writeln(log.toFormattedString());
    }
    if (_logs.length > 100) {
      buffer.writeln('... and ${_logs.length - 100} older logs');
    }

    return buffer.toString();
  }
}
