import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import 'models.dart';
import 'formatters.dart';

/// Интерфейс для записи логов в файлы
abstract class LogFileWriter {
  Future<void> initialize();
  Future<void> writeLogEntry(LogEntry entry);
  Future<void> writeSessionInfo(SessionInfo sessionInfo);
  Future<void> flush();
  Future<void> close();
}

/// Менеджер файлов логов
class LogFileManager {
  final LoggerConfig config;
  final LogFormatter formatter;
  String? _logDirectory;
  final Map<String, LogFileWriter> _writers = {};

  LogFileManager({required this.config, required this.formatter});

  /// Инициализация файлового менеджера
  Future<void> initialize() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      _logDirectory = path.join(appDocDir.path, 'logs');
      await Directory(_logDirectory!).create(recursive: true);

      // Очистка старых логов
      await _cleanupOldLogs();
    } catch (e) {
      debugPrint('Failed to initialize log file manager: $e');
    }
  }

  /// Запись лога в файл
  Future<void> writeLogEntry(LogEntry entry) async {
    if (_logDirectory == null) return;

    final dateKey = _formatDateForFile(entry.timestamp);
    final writer = await _getWriter(dateKey, entry.sessionId);
    await writer.writeLogEntry(entry);
  }

  /// Запись информации о сессии
  Future<void> writeSessionInfo(SessionInfo sessionInfo) async {
    if (_logDirectory == null) return;

    final dateKey = _formatDateForFile(sessionInfo.startTime);
    final writer = await _getWriter(dateKey, sessionInfo.sessionId);
    await writer.writeSessionInfo(sessionInfo);
  }

  /// Принудительный сброс всех буферов
  Future<void> flushAll() async {
    final futures = _writers.values.map((writer) => writer.flush());
    await Future.wait(futures);
  }

  /// Закрытие всех файлов
  Future<void> closeAll() async {
    final futures = _writers.values.map((writer) => writer.close());
    await Future.wait(futures);
    _writers.clear();
  }

  /// Получение списка файлов логов
  Future<List<File>> getLogFiles() async {
    if (_logDirectory == null) return [];

    try {
      final logDir = Directory(_logDirectory!);
      final entities = await logDir.list().toList();
      return entities
          .whereType<File>()
          .where((file) => path.basename(file.path).startsWith('app_log_'))
          .toList();
    } catch (e) {
      debugPrint('Failed to get log files: $e');
      return [];
    }
  }

  /// Получение размера всех файлов логов
  Future<int> getTotalLogSize() async {
    final files = await getLogFiles();
    int totalSize = 0;

    for (final file in files) {
      try {
        final stat = await file.stat();
        totalSize += stat.size;
      } catch (e) {
        debugPrint('Failed to get file size for ${file.path}: $e');
      }
    }

    return totalSize;
  }

  /// Очистка старых файлов логов
  Future<void> _cleanupOldLogs() async {
    if (_logDirectory == null) return;

    try {
      final files = await getLogFiles();
      int totalSize = 0;
      final filesWithSize = <MapEntry<File, int>>[];

      for (final file in files) {
        final stat = await file.stat();
        totalSize += stat.size;
        filesWithSize.add(MapEntry(file, stat.size));
      }

      if (totalSize > config.maxTotalSize) {
        // Сортируем по дате модификации (старые сначала)
        filesWithSize.sort(
          (a, b) =>
              a.key.statSync().modified.compareTo(b.key.statSync().modified),
        );

        // Удаляем старые файлы, пока не достигнем лимита
        for (final entry in filesWithSize) {
          if (totalSize <= config.maxTotalSize * 0.8) break;

          try {
            await entry.key.delete();
            totalSize -= entry.value;
            debugPrint('Deleted old log file: ${entry.key.path}');
          } catch (e) {
            debugPrint('Failed to delete old log file ${entry.key.path}: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to cleanup old logs: $e');
    }
  }

  /// Получение писателя файлов для конкретной даты
  Future<LogFileWriter> _getWriter(String dateKey, String sessionId) async {
    final writerKey = dateKey;

    if (_writers.containsKey(writerKey)) {
      return _writers[writerKey]!;
    }

    final fileName = config.prettyFileFormat
        ? 'app_log_$dateKey.txt'
        : 'app_log_$dateKey.jsonl';

    final filePath = path.join(_logDirectory!, fileName);
    final writer = config.prettyFileFormat
        ? PrettyLogFileWriter(filePath, formatter, config)
        : JsonLogFileWriter(filePath, formatter, config);

    await writer.initialize();
    _writers[writerKey] = writer;

    return writer;
  }

  String _formatDateForFile(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  /// Ротация файла при превышении размера
  Future<void> rotateFileIfNeeded(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return;

    final stat = await file.stat();
    if (stat.size <= config.maxFileSize) return;

    try {
      final baseName = path.basenameWithoutExtension(filePath);
      final extension = path.extension(filePath);
      final dirPath = path.dirname(filePath);

      int rotateNumber = 1;
      String newFileName;
      File newFile;

      do {
        newFileName = '${baseName}_$rotateNumber$extension';
        newFile = File(path.join(dirPath, newFileName));
        rotateNumber++;
      } while (await newFile.exists());

      await file.rename(newFile.path);
      debugPrint('Rotated log file: ${file.path} -> ${newFile.path}');
    } catch (e) {
      debugPrint('Failed to rotate file $filePath: $e');
    }
  }
}

/// JSON писатель файлов логов
class JsonLogFileWriter implements LogFileWriter {
  final String filePath;
  final LogFormatter formatter;
  final LoggerConfig config;
  IOSink? _sink;
  bool _initialized = false;

  JsonLogFileWriter(this.filePath, this.formatter, this.config);

  Future<void> initialize() async {
    if (_initialized) return;

    final file = File(filePath);
    final fileExists = await file.exists();

    _sink = file.openWrite(mode: FileMode.append);

    if (!fileExists) {
      // Записываем заголовок файла только если файл новый
      _sink!.writeln(
        '// JSON Log File - Created: ${DateTime.now().toIso8601String()}',
      );
    }

    _initialized = true;
  }

  @override
  Future<void> writeLogEntry(LogEntry entry) async {
    if (_sink == null) await initialize();
    _sink!.writeln(formatter.formatLogEntry(entry));
  }

  @override
  Future<void> writeSessionInfo(SessionInfo sessionInfo) async {
    if (_sink == null) await initialize();
    _sink!.writeln(
      '// Session Info: ${formatter.formatSessionInfo(sessionInfo)}',
    );
  }

  @override
  Future<void> flush() async {
    await _sink?.flush();
  }

  @override
  Future<void> close() async {
    await _sink?.close();
    _sink = null;
    _initialized = false;
  }
}

/// Красивый писатель файлов логов
class PrettyLogFileWriter implements LogFileWriter {
  final String filePath;
  final LogFormatter formatter;
  final LoggerConfig config;
  IOSink? _sink;
  bool _initialized = false;
  bool _sessionInfoWritten = false;

  PrettyLogFileWriter(this.filePath, this.formatter, this.config);

  Future<void> initialize() async {
    if (_initialized) return;

    final file = File(filePath);
    final fileExists = await file.exists();

    _sink = file.openWrite(mode: FileMode.append);

    if (!fileExists) {
      _sink!.writeln('Application Log File');
      _sink!.writeln('Generated: ${DateTime.now()}');
      _sink!.writeln('Format: Pretty Text');
      _sink!.writeln('${'=' * 80}');
      _sink!.writeln();
    }

    _initialized = true;
  }

  @override
  Future<void> writeSessionInfo(SessionInfo sessionInfo) async {
    if (_sink == null) await initialize();
    if (_sessionInfoWritten)
      return; // Записываем информацию о сессии только один раз

    _sink!.write(formatter.formatSessionInfo(sessionInfo));
    _sessionInfoWritten = true;
  }

  @override
  Future<void> writeLogEntry(LogEntry entry) async {
    if (_sink == null) await initialize();
    _sink!.write(formatter.formatLogEntry(entry));
    _sink!.writeln(); // Дополнительная пустая строка между записями
  }

  @override
  Future<void> flush() async {
    await _sink?.flush();
  }

  @override
  Future<void> close() async {
    await _sink?.close();
    _sink = null;
    _initialized = false;
    _sessionInfoWritten = false;
  }
}
