import 'dart:convert';
import 'models.dart';

/// Интерфейс для форматирования логов
abstract class LogFormatter {
  String formatLogEntry(LogEntry entry);
  String formatSessionInfo(SessionInfo sessionInfo);
  String formatFileHeader(SessionInfo sessionInfo, LoggerConfig config);
}

/// JSON форматтер для логов
class JsonLogFormatter implements LogFormatter {
  @override
  String formatLogEntry(LogEntry entry) {
    return entry.toJsonString();
  }

  @override
  String formatSessionInfo(SessionInfo sessionInfo) {
    return sessionInfo.toJsonString();
  }

  @override
  String formatFileHeader(SessionInfo sessionInfo, LoggerConfig config) {
    final header = {
      'fileType': 'application_log',
      'version': '1.0',
      'createdAt': DateTime.now().toIso8601String(),
      'sessionInfo': sessionInfo.toJson(),
      'config': {
        'maxFileSize': config.maxFileSize,
        'maxTotalSize': config.maxTotalSize,
        'flushIntervalMs': config.flushIntervalMs,
        'maxMemoryEntries': config.maxMemoryEntries,
        'minLevel': config.minLevel.name,
        'prettyFileFormat': config.prettyFileFormat,
      },
    };
    return '// File Header: ${jsonEncode(header)}';
  }
}

/// Красивый форматтер для логов с визуальным разделением
class PrettyLogFormatter implements LogFormatter {
  static final String _separator = '═' * 80;
  static final String _minorSeparator = '─' * 40;

  @override
  String formatLogEntry(LogEntry entry) {
    final buffer = StringBuffer();

    // Timestamp и основная информация
    buffer.writeln(
      '┌─ ${_getLevelIcon(entry.level)} ${entry.level.name.toUpperCase()} ─ ${_formatTimestamp(entry.timestamp)} ─',
    );

    // Сессия и тег
    buffer.writeln('│ Session: ${entry.sessionId.substring(0, 8)}...');
    if (entry.tag != null) {
      buffer.writeln('│ Tag: ${entry.tag}');
    }

    // Сообщение
    buffer.writeln('│');
    final messageLines = entry.message.split('\n');
    for (final line in messageLines) {
      buffer.writeln('│ $line');
    }

    // Дополнительные данные
    if (entry.extra != null && entry.extra!.isNotEmpty) {
      buffer.writeln('│');
      buffer.writeln('│ Extra Data:');
      final prettyExtra = const JsonEncoder.withIndent(
        '  ',
      ).convert(entry.extra);
      final extraLines = prettyExtra.split('\n');
      for (final line in extraLines) {
        buffer.writeln('│   $line');
      }
    }

    // Стек вызовов
    if (entry.stackTrace != null) {
      buffer.writeln('│');
      buffer.writeln('│ Stack Trace:');
      final stackLines = entry.stackTrace!.split('\n');
      for (final line in stackLines.take(10)) {
        // Ограничиваем количество строк
        if (line.trim().isNotEmpty) {
          buffer.writeln('│   $line');
        }
      }
      if (stackLines.length > 10) {
        buffer.writeln('│   ... (${stackLines.length - 10} more lines)');
      }
    }

    buffer.writeln('└${'─' * 78}');

    return buffer.toString();
  }

  @override
  String formatSessionInfo(SessionInfo sessionInfo) {
    final buffer = StringBuffer();

    buffer.writeln(_separator);
    buffer.writeln('🚀 SESSION STARTED');
    buffer.writeln(_separator);
    buffer.writeln('Session ID: ${sessionInfo.sessionId}');
    buffer.writeln('Start Time: ${_formatTimestamp(sessionInfo.startTime)}');
    buffer.writeln();

    // Информация о приложении
    buffer.writeln('📱 APPLICATION INFO');
    buffer.writeln(_minorSeparator);
    final appInfo = sessionInfo.appInfo;
    buffer.writeln('Name: ${appInfo['appName'] ?? 'Unknown'}');
    buffer.writeln('Package: ${appInfo['packageName'] ?? 'Unknown'}');
    buffer.writeln(
      'Version: ${appInfo['version'] ?? 'Unknown'} (${appInfo['buildNumber'] ?? 'Unknown'})',
    );
    buffer.writeln();

    // Информация об устройстве
    buffer.writeln('💻 DEVICE INFO');
    buffer.writeln(_minorSeparator);
    final deviceInfo = sessionInfo.deviceInfo;
    buffer.writeln('Platform: ${deviceInfo['platform'] ?? 'Unknown'}');
    buffer.writeln('Model: ${deviceInfo['model'] ?? 'Unknown'}');
    if (deviceInfo['manufacturer'] != null) {
      buffer.writeln('Manufacturer: ${deviceInfo['manufacturer']}');
    }
    if (deviceInfo['version'] != null) {
      buffer.writeln('OS Version: ${deviceInfo['version']}');
    }
    buffer.writeln();
    buffer.writeln(_separator);

    return buffer.toString();
  }

  @override
  String formatFileHeader(SessionInfo sessionInfo, LoggerConfig config) {
    final buffer = StringBuffer();

    buffer.writeln('/*');
    buffer.writeln(' * Application Log File');
    buffer.writeln(' * Generated: ${DateTime.now().toIso8601String()}');
    buffer.writeln(' * Session: ${sessionInfo.sessionId}');
    buffer.writeln(' * Format: Pretty Text');
    buffer.writeln(' */');
    buffer.writeln();

    return buffer.toString();
  }

  String _getLevelIcon(AppLogLevel level) {
    switch (level) {
      case AppLogLevel.debug:
        return '🐛';
      case AppLogLevel.info:
        return 'ℹ️';
      case AppLogLevel.warning:
        return '⚠️';
      case AppLogLevel.error:
        return '❌';
      case AppLogLevel.fatal:
        return '💀';
      case AppLogLevel.crash:
        return '💥';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day.toString().padLeft(2, '0')}/'
        '${timestamp.month.toString().padLeft(2, '0')}/'
        '${timestamp.year} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}.'
        '${timestamp.millisecond.toString().padLeft(3, '0')}';
  }
}
