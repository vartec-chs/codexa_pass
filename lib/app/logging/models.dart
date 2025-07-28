import 'dart:convert';

/// Уровни логирования
enum AppLogLevel { debug, info, warning, error, fatal, crash }

/// Модель лог записи
class LogEntry {
  final String sessionId;
  final DateTime timestamp;
  final AppLogLevel level;
  final String message;
  final String? tag;
  final Map<String, dynamic>? extra;
  final String? stackTrace;

  LogEntry({
    required this.sessionId,
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
    this.extra,
    this.stackTrace,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'timestamp': timestamp.toIso8601String(),
      'level': level.name,
      'message': message,
      'tag': tag,
      'extra': extra,
      'stackTrace': stackTrace,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      sessionId: json['sessionId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      level: AppLogLevel.values.firstWhere((l) => l.name == json['level']),
      message: json['message'] as String,
      tag: json['tag'] as String?,
      extra: json['extra'] as Map<String, dynamic>?,
      stackTrace: json['stackTrace'] as String?,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[${timestamp.toIso8601String()}] ');
    buffer.write('[${level.name.toUpperCase()}] ');
    if (tag != null) buffer.write('[$tag] ');
    buffer.write(message);
    if (extra != null && extra!.isNotEmpty) {
      buffer.write(' | Extra: $extra');
    }
    if (stackTrace != null) {
      buffer.write('\nStack trace:\n$stackTrace');
    }
    return buffer.toString();
  }
}

/// Информация о сессии
class SessionInfo {
  final String sessionId;
  final DateTime startTime;
  final Map<String, dynamic> deviceInfo;
  final Map<String, dynamic> appInfo;

  SessionInfo({
    required this.sessionId,
    required this.startTime,
    required this.deviceInfo,
    required this.appInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'startTime': startTime.toIso8601String(),
      'deviceInfo': deviceInfo,
      'appInfo': appInfo,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory SessionInfo.fromJson(Map<String, dynamic> json) {
    return SessionInfo(
      sessionId: json['sessionId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      deviceInfo: json['deviceInfo'] as Map<String, dynamic>,
      appInfo: json['appInfo'] as Map<String, dynamic>,
    );
  }
}

/// Конфигурация логгера
class LoggerConfig {
  final bool enableFileLogging;
  final bool enableConsoleLogging;
  final int maxFileSize; // в байтах
  final int maxTotalSize; // в байтах
  final int flushIntervalMs;
  final int maxMemoryEntries;
  final AppLogLevel minLevel;
  final bool enableSessionLogging;
  final bool prettyFileFormat;

  const LoggerConfig({
    this.enableFileLogging = true,
    this.enableConsoleLogging = true,
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.maxTotalSize = 100 * 1024 * 1024, // 100MB
    this.flushIntervalMs = 5000, // 5 секунд
    this.maxMemoryEntries = 100,
    this.minLevel = AppLogLevel.debug,
    this.enableSessionLogging = true,
    this.prettyFileFormat = true,
  });
}
