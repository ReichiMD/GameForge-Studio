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

  /// Get all logs
  List<DebugLogEntry> get logs => List.unmodifiable(_logs);

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalLogs': _logs.length,
      'imageLoadAttempts': _imageLoadAttempts,
      'imageLoadSuccesses': _imageLoadSuccesses,
      'imageLoadErrors': _imageLoadErrors,
      'successRate': _imageLoadAttempts > 0
          ? ((_imageLoadSuccesses / _imageLoadAttempts) * 100).toStringAsFixed(1)
          : '0.0',
      'uniqueUrlsAttempted': _attemptedUrls.length,
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
