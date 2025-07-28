import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';
import 'formatters.dart';
import 'file_manager.dart';
import 'device_info.dart';
import 'parser.dart';

/// Основной класс логгера
class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance!;

  late final Logger _consoleLogger;
  late final String _sessionId;
  late final SessionInfo _sessionInfo;
  late final LoggerConfig _config;
  late final LogFileManager _fileManager;
  late final LogFormatter _formatter;

  final List<LogEntry> _memoryBuffer = [];
  Timer? _flushTimer;
  bool _isInitialized = false;
  final Completer<void> _initCompleter = Completer<void>();
  int _totalLogsCount = 0;

  AppLogger._();

  // Геттеры для удобства
  bool get isInitialized => _isInitialized;
  String get sessionId => _sessionId;
  DateTime? get sessionStartTime => _sessionInfo.startTime;
  int get totalLogsCount => _totalLogsCount;
  int getBufferSize() => _memoryBuffer.length;

  /// Инициализация логгера
  static Future<AppLogger> initialize({LoggerConfig? config}) async {
    if (_instance != null) {
      return _instance!;
    }

    _instance = AppLogger._();
    await _instance!._init(config ?? const LoggerConfig());
    return _instance!;
  }

  Future<void> _init(LoggerConfig config) async {
    if (_isInitialized) return;

    _config = config;
    _sessionId = const Uuid().v4();

    // Инициализация форматтера
    _formatter = config.prettyFileFormat
        ? PrettyLogFormatter()
        : JsonLogFormatter();

    // Инициализация консольного логгера
    _consoleLogger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );

    // Инициализация файлового менеджера
    if (_config.enableFileLogging) {
      _fileManager = LogFileManager(config: _config, formatter: _formatter);
      await _fileManager.initialize();
    }

    // Создание информации о сессии
    await _initSessionInfo();

    // Запуск таймера для периодического сброса
    if (_config.enableFileLogging) {
      _startFlushTimer();
    }

    // Установка обработчика ошибок
    _setupErrorHandlers();

    _isInitialized = true;
    _initCompleter.complete();
  }

  Future<void> _initSessionInfo() async {
    _sessionInfo = await DeviceInfoCollector.createSessionInfo(_sessionId);

    // Записываем информацию о сессии в файл
    if (_config.enableFileLogging && _config.enableSessionLogging) {
      await _fileManager.writeSessionInfo(_sessionInfo);
    }
  }

  void _setupErrorHandlers() {
    // Обработчик Flutter ошибок
    FlutterError.onError = (FlutterErrorDetails details) {
      crash(
        'Flutter Error: ${details.exceptionAsString()}',
        stackTrace: details.stack.toString(),
        extra: {
          'library': details.library,
          'context': details.context?.toString(),
          'informationCollector': details.informationCollector?.toString(),
        },
      );
    };

    // Обработчик Dart ошибок
    PlatformDispatcher.instance.onError = (error, stack) {
      crash('Dart Error: $error', stackTrace: stack.toString());
      return true;
    };

    // Обработчик изолированных ошибок
    Isolate.current.addErrorListener(
      RawReceivePort((List<dynamic> errorAndStacktrace) {
        crash(
          'Isolate Error: ${errorAndStacktrace[0]}',
          stackTrace: errorAndStacktrace[1].toString(),
        );
      }).sendPort,
    );
  }

  void _startFlushTimer() {
    _flushTimer?.cancel();
    _flushTimer = Timer.periodic(
      Duration(milliseconds: _config.flushIntervalMs),
      (_) => _flushBufferToFile(),
    );
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initCompleter.future;
    }
  }

  // Методы логирования
  void debug(String message, {String? tag, Map<String, dynamic>? extra}) {
    _log(AppLogLevel.debug, message, tag: tag, extra: extra);
  }

  void info(String message, {String? tag, Map<String, dynamic>? extra}) {
    _log(AppLogLevel.info, message, tag: tag, extra: extra);
  }

  void warning(String message, {String? tag, Map<String, dynamic>? extra}) {
    _log(AppLogLevel.warning, message, tag: tag, extra: extra);
  }

  void error(
    String message, {
    String? tag,
    Map<String, dynamic>? extra,
    String? stackTrace,
  }) {
    _log(
      AppLogLevel.error,
      message,
      tag: tag,
      extra: extra,
      stackTrace: stackTrace,
    );
  }

  void fatal(
    String message, {
    String? tag,
    Map<String, dynamic>? extra,
    String? stackTrace,
  }) {
    _log(
      AppLogLevel.fatal,
      message,
      tag: tag,
      extra: extra,
      stackTrace: stackTrace,
    );
  }

  void crash(
    String message, {
    String? tag,
    Map<String, dynamic>? extra,
    String? stackTrace,
  }) {
    _log(
      AppLogLevel.crash,
      message,
      tag: tag,
      extra: extra,
      stackTrace: stackTrace,
    );
    // Немедленно сбрасываем краш-репорты
    if (_config.enableFileLogging) {
      _flushBufferToFile();
    }
  }

  void _log(
    AppLogLevel level,
    String message, {
    String? tag,
    Map<String, dynamic>? extra,
    String? stackTrace,
  }) async {
    await _ensureInitialized();

    if (_shouldLog(level)) {
      final logEntry = LogEntry(
        sessionId: _sessionId,
        timestamp: DateTime.now(),
        level: level,
        message: message,
        tag: tag,
        extra: extra,
        stackTrace: stackTrace,
      );

      // Консольный вывод
      if (_config.enableConsoleLogging) {
        _logToConsole(logEntry);
      }

      // Добавление в память буфер
      if (_config.enableFileLogging) {
        _addToBuffer(logEntry);
      }
    }
  }

  bool _shouldLog(AppLogLevel level) {
    return level.index >= _config.minLevel.index;
  }

  void _logToConsole(LogEntry entry) {
    final tagStr = entry.tag != null ? '[${entry.tag}] ' : '';
    final message = '$tagStr${entry.message}';

    switch (entry.level) {
      case AppLogLevel.debug:
        _consoleLogger.d(
          message,
          stackTrace: entry.stackTrace != null
              ? StackTrace.fromString(entry.stackTrace!)
              : null,
        );
        break;
      case AppLogLevel.info:
        _consoleLogger.i(
          message,
          stackTrace: entry.stackTrace != null
              ? StackTrace.fromString(entry.stackTrace!)
              : null,
        );
        break;
      case AppLogLevel.warning:
        _consoleLogger.w(
          message,
          stackTrace: entry.stackTrace != null
              ? StackTrace.fromString(entry.stackTrace!)
              : null,
        );
        break;
      case AppLogLevel.error:
        _consoleLogger.e(
          message,
          stackTrace: entry.stackTrace != null
              ? StackTrace.fromString(entry.stackTrace!)
              : null,
        );
        break;
      case AppLogLevel.fatal:
      case AppLogLevel.crash:
        _consoleLogger.f(
          message,
          stackTrace: entry.stackTrace != null
              ? StackTrace.fromString(entry.stackTrace!)
              : null,
        );
        break;
    }
  }

  void _addToBuffer(LogEntry entry) {
    _memoryBuffer.add(entry);
    _totalLogsCount++;

    // Если буфер переполнен, принудительно сбрасываем
    if (_memoryBuffer.length >= _config.maxMemoryEntries) {
      _flushBufferToFile();
    }
  }

  Future<void> _flushBufferToFile() async {
    if (_memoryBuffer.isEmpty) return;

    List<LogEntry> entries = [];
    try {
      entries = List<LogEntry>.from(_memoryBuffer);
      _memoryBuffer.clear();

      // Записываем все записи в файлы
      for (final entry in entries) {
        await _fileManager.writeLogEntry(entry);
      }

      // Сбрасываем буферы файлов
      await _fileManager.flushAll();
    } catch (e) {
      debugPrint('Failed to flush buffer to file: $e');
      // В случае ошибки возвращаем записи обратно в буфер
      if (entries.isNotEmpty) {
        _memoryBuffer.addAll(entries);
      }
    }
  }

  // Методы для работы с логами через парсер
  Future<List<LogEntry>> getLogsByDate(DateTime date) async {
    await _ensureInitialized();

    final files = await _fileManager.getLogFiles();
    final dateKey = _formatDateForFile(date);

    final targetFile = files.firstWhere(
      (file) => file.path.contains(dateKey),
      orElse: () => files.isEmpty
          ? files.first
          : files.first, // Возвращаем dummy если файл не найден
    );

    if (!files.any((file) => file.path.contains(dateKey))) {
      return [];
    }

    final parseResult = await LogParser.parseLogFile(targetFile.path);
    return parseResult.entries;
  }

  Future<SessionInfo?> getSessionInfo() async {
    await _ensureInitialized();
    return _sessionInfo;
  }

  Future<Map<String, dynamic>> getLogStatistics({
    DateTime? from,
    DateTime? to,
  }) async {
    await _ensureInitialized();

    final startDate = from ?? DateTime.now().subtract(const Duration(days: 7));
    final endDate = to ?? DateTime.now();

    final allLogs = <LogEntry>[];

    // Собираем все логи за период
    for (
      var date = startDate;
      date.isBefore(endDate.add(const Duration(days: 1)));
      date = date.add(const Duration(days: 1))
    ) {
      final logsForDate = await getLogsByDate(date);
      allLogs.addAll(logsForDate);
    }

    return LogParser.getLogStatistics(allLogs);
  }

  Future<List<LogEntry>> getFilteredLogs({
    DateTime? from,
    DateTime? to,
    List<AppLogLevel>? levels,
    List<String>? tags,
    String? messageContains,
    String? sessionId,
    int? limit,
  }) async {
    await _ensureInitialized();

    final startDate = from ?? DateTime.now().subtract(const Duration(days: 7));
    final endDate = to ?? DateTime.now();

    final allLogs = <LogEntry>[];

    // Собираем все логи за период
    for (
      var date = startDate;
      date.isBefore(endDate.add(const Duration(days: 1)));
      date = date.add(const Duration(days: 1))
    ) {
      final logsForDate = await getLogsByDate(date);
      allLogs.addAll(logsForDate);
    }

    // Фильтруем логи
    var filteredLogs = LogParser.filterLogs(
      allLogs,
      levels: levels,
      tags: tags,
      messageContains: messageContains,
      sessionId: sessionId,
      from: from,
      to: to,
    );

    // Сортировка по времени (новые сначала)
    filteredLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Ограничение количества
    if (limit != null && filteredLogs.length > limit) {
      filteredLogs = filteredLogs.take(limit).toList();
    }

    return filteredLogs;
  }

  Future<String?> exportLogsToJson({
    DateTime? from,
    DateTime? to,
    List<AppLogLevel>? levels,
    List<String>? tags,
    String format = 'json',
  }) async {
    try {
      final logs = await getFilteredLogs(
        from: from,
        to: to,
        levels: levels,
        tags: tags,
      );

      return LogParser.exportLogs(
        logs,
        sessionInfo: _sessionInfo,
        format: format,
      );
    } catch (e) {
      debugPrint('Failed to export logs: $e');
      return null;
    }
  }

  String _formatDateForFile(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  // Принудительный сброс буфера
  Future<void> flush() async {
    await _flushBufferToFile();
  }

  // Очистка ресурсов
  Future<void> dispose() async {
    _flushTimer?.cancel();
    await _flushBufferToFile();
    if (_config.enableFileLogging) {
      await _fileManager.closeAll();
    }
  }
}
