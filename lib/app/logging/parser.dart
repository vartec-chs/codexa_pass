import 'dart:convert';
import 'dart:io';
import 'models.dart';

/// Результат парсинга файла логов
class LogParseResult {
  final SessionInfo? sessionInfo;
  final List<LogEntry> entries;
  final Map<String, dynamic> metadata;
  final List<String> errors;

  LogParseResult({
    this.sessionInfo,
    required this.entries,
    required this.metadata,
    required this.errors,
  });
}

/// Парсер логов с поддержкой различных форматов
class LogParser {
  /// Парсинг файла логов
  static Future<LogParseResult> parseLogFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return LogParseResult(
        entries: [],
        metadata: {},
        errors: ['File not found: $filePath'],
      );
    }

    try {
      final lines = await file.readAsLines();
      return _parseLines(lines);
    } catch (e) {
      return LogParseResult(
        entries: [],
        metadata: {},
        errors: ['Failed to read file: $e'],
      );
    }
  }

  /// Парсинг строк логов
  static LogParseResult parseLogLines(List<String> lines) {
    return _parseLines(lines);
  }

  /// Парсинг одной строки лога
  static LogEntry? parseLogEntry(String line) {
    return _parseLogLine(line);
  }

  static LogParseResult _parseLines(List<String> lines) {
    final entries = <LogEntry>[];
    final errors = <String>[];
    final metadata = <String, dynamic>{};
    SessionInfo? sessionInfo;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      try {
        // Парсинг заголовка файла
        if (line.startsWith('// File Header:')) {
          final headerJson = line.substring('// File Header:'.length).trim();
          final header = jsonDecode(headerJson);
          metadata.addAll(header);
          if (header['sessionInfo'] != null) {
            sessionInfo = SessionInfo.fromJson(header['sessionInfo']);
          }
          continue;
        }

        // Парсинг информации о сессии (старый формат)
        if (line.startsWith('// Session Info:')) {
          final sessionJson = line.substring('// Session Info:'.length).trim();
          final sessionData = jsonDecode(sessionJson);
          sessionInfo = SessionInfo.fromJson(sessionData);
          continue;
        }

        // Пропуск комментариев и разделителей
        if (line.startsWith('//') ||
            line.startsWith('/*') ||
            line.startsWith('*') ||
            line.startsWith('┌') ||
            line.startsWith('│') ||
            line.startsWith('└') ||
            line.contains('═') ||
            line.contains('─')) {
          continue;
        }

        // Парсинг записи лога
        final entry = _parseLogLine(line);
        if (entry != null) {
          entries.add(entry);
        }
      } catch (e) {
        errors.add('Error parsing line ${i + 1}: $e');
      }
    }

    return LogParseResult(
      sessionInfo: sessionInfo,
      entries: entries,
      metadata: metadata,
      errors: errors,
    );
  }

  static LogEntry? _parseLogLine(String line) {
    if (line.trim().isEmpty) return null;

    try {
      // Попытка парсинга как JSON
      final json = jsonDecode(line);
      if (json is Map<String, dynamic>) {
        return LogEntry.fromJson(json);
      }
    } catch (e) {
      // Если не JSON, пытаемся парсить как текст
      return _parseTextLogLine(line);
    }

    return null;
  }

  static LogEntry? _parseTextLogLine(String line) {
    // Простой парсер для текстового формата
    // Формат: [timestamp] [LEVEL] [tag] message

    final regex = RegExp(
      r'\[([^\]]+)\]\s*\[([^\]]+)\]\s*(?:\[([^\]]+)\]\s*)?(.+)',
    );
    final match = regex.firstMatch(line);

    if (match == null) return null;

    try {
      final timestampStr = match.group(1)!;
      final levelStr = match.group(2)!;
      final tag = match.group(3);
      final message = match.group(4)!;

      final timestamp = DateTime.parse(timestampStr);
      final level = AppLogLevel.values.firstWhere(
        (l) => l.name.toUpperCase() == levelStr.toUpperCase(),
        orElse: () => AppLogLevel.info,
      );

      return LogEntry(
        sessionId: 'unknown',
        timestamp: timestamp,
        level: level,
        message: message.trim(),
        tag: tag,
      );
    } catch (e) {
      return null;
    }
  }

  /// Получение статистики из распарсенных логов
  static Map<String, dynamic> getLogStatistics(List<LogEntry> entries) {
    if (entries.isEmpty) {
      return {
        'totalEntries': 0,
        'levelCounts': <String, int>{},
        'tagCounts': <String, int>{},
        'sessionIds': <String>[],
        'timeRange': null,
      };
    }

    final levelCounts = <AppLogLevel, int>{};
    final tagCounts = <String, int>{};
    final sessionIds = <String>{};

    DateTime? earliest, latest;

    for (final entry in entries) {
      // Подсчет по уровням
      levelCounts[entry.level] = (levelCounts[entry.level] ?? 0) + 1;

      // Подсчет по тегам
      if (entry.tag != null) {
        tagCounts[entry.tag!] = (tagCounts[entry.tag!] ?? 0) + 1;
      }

      // Сбор ID сессий
      sessionIds.add(entry.sessionId);

      // Временной диапазон
      if (earliest == null || entry.timestamp.isBefore(earliest)) {
        earliest = entry.timestamp;
      }
      if (latest == null || entry.timestamp.isAfter(latest)) {
        latest = entry.timestamp;
      }
    }

    return {
      'totalEntries': entries.length,
      'levelCounts': levelCounts.map((k, v) => MapEntry(k.name, v)),
      'tagCounts': tagCounts,
      'sessionIds': sessionIds.toList(),
      'uniqueSessions': sessionIds.length,
      'timeRange': {
        'earliest': earliest?.toIso8601String(),
        'latest': latest?.toIso8601String(),
        'duration': latest != null && earliest != null
            ? latest.difference(earliest).inMilliseconds
            : 0,
      },
    };
  }

  /// Фильтрация логов
  static List<LogEntry> filterLogs(
    List<LogEntry> entries, {
    List<AppLogLevel>? levels,
    List<String>? tags,
    String? messageContains,
    String? sessionId,
    DateTime? from,
    DateTime? to,
  }) {
    return entries.where((entry) {
      // Фильтр по уровню
      if (levels != null && !levels.contains(entry.level)) {
        return false;
      }

      // Фильтр по тегу
      if (tags != null && (entry.tag == null || !tags.contains(entry.tag))) {
        return false;
      }

      // Фильтр по содержимому сообщения
      if (messageContains != null &&
          !entry.message.toLowerCase().contains(
            messageContains.toLowerCase(),
          )) {
        return false;
      }

      // Фильтр по ID сессии
      if (sessionId != null && entry.sessionId != sessionId) {
        return false;
      }

      // Фильтр по времени
      if (from != null && entry.timestamp.isBefore(from)) {
        return false;
      }
      if (to != null && entry.timestamp.isAfter(to)) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Экспорт логов в различные форматы
  static String exportLogs(
    List<LogEntry> entries, {
    SessionInfo? sessionInfo,
    String format = 'json', // json, csv, txt
  }) {
    switch (format.toLowerCase()) {
      case 'csv':
        return _exportToCsv(entries);
      case 'txt':
        return _exportToText(entries);
      case 'json':
      default:
        return _exportToJson(entries, sessionInfo);
    }
  }

  static String _exportToJson(
    List<LogEntry> entries,
    SessionInfo? sessionInfo,
  ) {
    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'sessionInfo': sessionInfo?.toJson(),
      'totalEntries': entries.length,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  static String _exportToCsv(List<LogEntry> entries) {
    final buffer = StringBuffer();
    buffer.writeln('Timestamp,Level,Tag,SessionId,Message,Extra,StackTrace');

    for (final entry in entries) {
      final fields = [
        entry.timestamp.toIso8601String(),
        entry.level.name,
        entry.tag ?? '',
        entry.sessionId,
        '"${entry.message.replaceAll('"', '""')}"',
        entry.extra != null
            ? '"${jsonEncode(entry.extra).replaceAll('"', '""')}"'
            : '',
        entry.stackTrace != null
            ? '"${entry.stackTrace!.replaceAll('"', '""')}"'
            : '',
      ];
      buffer.writeln(fields.join(','));
    }

    return buffer.toString();
  }

  static String _exportToText(List<LogEntry> entries) {
    final buffer = StringBuffer();
    buffer.writeln('Application Log Export');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Total entries: ${entries.length}');
    buffer.writeln('${'=' * 80}');
    buffer.writeln();

    for (final entry in entries) {
      buffer.writeln(entry.toString());
      buffer.writeln();
    }

    return buffer.toString();
  }
}
