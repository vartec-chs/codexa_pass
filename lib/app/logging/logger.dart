// Экспорт всех необходимых классов и функций из подсистемы логирования
export 'models.dart';
export 'formatters.dart';
export 'parser.dart';
export 'app_logger.dart';
export 'device_info.dart';

import 'models.dart';
import 'app_logger.dart';

// Глобальная переменная для удобства использования
late AppLogger _logger;
bool _isInitialized = false;

/// Геттер для безопасного доступа к логгеру
AppLogger get logger {
  if (!_isInitialized) {
    throw StateError(
      'Logger не инициализирован. Вызовите initLogger() в main() перед использованием.',
    );
  }
  return _logger;
}

/// Безопасный геттер для логгера (возвращает null если не инициализирован)
AppLogger? get loggerSafe => _isInitialized ? _logger : null;

/// Проверка инициализации логгера
bool get isLoggerInitialized => _isInitialized;

/// Инициализация логгера
/// Должна вызываться в main.dart перед использованием
Future<void> initLogger({LoggerConfig? config}) async {
  _logger = await AppLogger.initialize(config: config);
  _isInitialized = true;
}

/// Принудительная инициализация логгера (если ещё не инициализирован)
/// Полезно для функций, которые могут вызываться до main()
Future<void> ensureLoggerInitialized({LoggerConfig? config}) async {
  if (!_isInitialized) {
    await initLogger(config: config);
  }
}

// === УДОБНЫЕ ФУНКЦИИ ДЛЯ ЛОГИРОВАНИЯ ===

/// Отладочное сообщение
void logDebug(String message, {String? tag, Map<String, dynamic>? extra}) {
  if (!_isInitialized) return;
  logger.debug(message, tag: tag, extra: extra);
}

/// Информационное сообщение
void logInfo(String message, {String? tag, Map<String, dynamic>? extra}) {
  if (!_isInitialized) return;
  logger.info(message, tag: tag, extra: extra);
}

/// Предупреждение
void logWarning(String message, {String? tag, Map<String, dynamic>? extra}) {
  if (!_isInitialized) return;
  logger.warning(message, tag: tag, extra: extra);
}

/// Ошибка
void logError(
  String message, {
  String? tag,
  Map<String, dynamic>? extra,
  String? stackTrace,
}) {
  if (!_isInitialized) return;
  logger.error(message, tag: tag, extra: extra, stackTrace: stackTrace);
}

/// Критическая ошибка
void logFatal(
  String message, {
  String? tag,
  Map<String, dynamic>? extra,
  String? stackTrace,
}) {
  if (!_isInitialized) return;
  logger.fatal(message, tag: tag, extra: extra, stackTrace: stackTrace);
}

/// Краш приложения
void logCrash(
  String message, {
  String? tag,
  Map<String, dynamic>? extra,
  String? stackTrace,
}) {
  if (!_isInitialized) return;
  logger.crash(message, tag: tag, extra: extra, stackTrace: stackTrace);
}

// === ДОПОЛНИТЕЛЬНЫЕ УДОБНЫЕ ФУНКЦИИ ===

/// Получить статистику логов за период
Future<Map<String, dynamic>> getLogStats({DateTime? from, DateTime? to}) async {
  if (!_isInitialized) return <String, dynamic>{};
  return await logger.getLogStatistics(from: from, to: to);
}

/// Получить отфильтрованные логи
Future<List<LogEntry>> getFilteredLogs({
  DateTime? from,
  DateTime? to,
  List<AppLogLevel>? levels,
  List<String>? tags,
  String? messageContains,
  String? sessionId,
  int? limit,
}) {
  if (!_isInitialized) return Future.value(<LogEntry>[]);
  return logger.getFilteredLogs(
    from: from,
    to: to,
    levels: levels,
    tags: tags,
    messageContains: messageContains,
    sessionId: sessionId,
    limit: limit,
  );
}

/// Экспорт логов в различных форматах
Future<String?> exportLogs({
  DateTime? from,
  DateTime? to,
  List<AppLogLevel>? levels,
  List<String>? tags,
  String format = 'json', // json, csv, txt
}) async {
  if (!_isInitialized) return null;
  return await logger.exportLogsToJson(
    from: from,
    to: to,
    levels: levels,
    tags: tags,
  );
}

/// Получить краш-репорты за период
Future<List<LogEntry>> getCrashReports({DateTime? from, DateTime? to}) async {
  return await getFilteredLogs(
    from: from,
    to: to,
    levels: [AppLogLevel.crash, AppLogLevel.fatal],
  );
}

/// Получить ошибки за период (включая предупреждения и выше)
Future<List<LogEntry>> getErrors({DateTime? from, DateTime? to}) async {
  return await getFilteredLogs(
    from: from,
    to: to,
    levels: [AppLogLevel.error, AppLogLevel.fatal, AppLogLevel.crash],
  );
}

/// Получить логи за сегодня
Future<List<LogEntry>> getTodayLogs({
  List<AppLogLevel>? levels,
  List<String>? tags,
}) async {
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return await getFilteredLogs(
    from: startOfDay,
    to: endOfDay,
    levels: levels,
    tags: tags,
  );
}

/// Получить логи за последний час
Future<List<LogEntry>> getRecentLogs({
  int hoursBack = 1,
  List<AppLogLevel>? levels,
  List<String>? tags,
}) async {
  final now = DateTime.now();
  final from = now.subtract(Duration(hours: hoursBack));

  return await getFilteredLogs(from: from, to: now, levels: levels, tags: tags);
}

/// Получить информацию о текущей сессии
Future<SessionInfo?> getCurrentSessionInfo() async {
  if (!_isInitialized) return null;
  return await logger.getSessionInfo();
}

/// Принудительно сбросить буфер логов в файл
Future<void> flushLogs() async {
  if (!_isInitialized) return;
  await logger.flush();
}

/// Получить количество записей в буфере
int getBufferSize() {
  if (!_isInitialized) return 0;
  return logger.getBufferSize();
}

/// Получить статус логгера
Map<String, dynamic> getLoggerStatus() {
  if (!_isInitialized) {
    return {
      'isInitialized': false,
      'bufferSize': 0,
      'sessionId': null,
      'startTime': null,
      'totalLogs': 0,
    };
  }
  return {
    'isInitialized': logger.isInitialized,
    'bufferSize': logger.getBufferSize(),
    'sessionId': logger.sessionId,
    'startTime': logger.sessionStartTime?.toIso8601String(),
    'totalLogs': logger.totalLogsCount,
  };
}

// === СПЕЦИАЛИЗИРОВАННЫЕ ФУНКЦИИ ЛОГИРОВАНИЯ ===

/// Логирование API запроса
void logApiRequest(
  String method,
  String url, {
  Map<String, dynamic>? headers,
  Map<String, dynamic>? body,
  int? statusCode,
  String? responseTime,
}) {
  logInfo(
    'API Request: $method $url',
    tag: 'API',
    extra: {
      'method': method,
      'url': url,
      'headers': headers,
      'body': body,
      'statusCode': statusCode,
      'responseTime': responseTime,
    },
  );
}

/// Логирование API ответа
void logApiResponse(
  String method,
  String url,
  int statusCode,
  String responseTime, {
  Map<String, dynamic>? response,
  String? error,
}) {
  final isError = statusCode >= 400;
  final message = 'API Response: $method $url - $statusCode ($responseTime)';

  if (isError) {
    logError(
      message,
      tag: 'API',
      extra: {
        'method': method,
        'url': url,
        'statusCode': statusCode,
        'responseTime': responseTime,
        'response': response,
        'error': error,
      },
    );
  } else {
    logInfo(
      message,
      tag: 'API',
      extra: {
        'method': method,
        'url': url,
        'statusCode': statusCode,
        'responseTime': responseTime,
        'response': response,
      },
    );
  }
}

/// Логирование навигации
void logNavigation(String from, String to, {Map<String, dynamic>? arguments}) {
  logInfo(
    'Navigation: $from -> $to',
    tag: 'NAVIGATION',
    extra: {'from': from, 'to': to, 'arguments': arguments},
  );
}

/// Логирование действий пользователя
void logUserAction(
  String action, {
  String? screen,
  Map<String, dynamic>? data,
}) {
  logInfo(
    'User Action: $action',
    tag: 'USER_ACTION',
    extra: {
      'action': action,
      'screen': screen,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}

/// Логирование производительности
void logPerformance(
  String operation,
  Duration duration, {
  Map<String, dynamic>? metrics,
}) {
  logInfo(
    'Performance: $operation took ${duration.inMilliseconds}ms',
    tag: 'PERFORMANCE',
    extra: {
      'operation': operation,
      'durationMs': duration.inMilliseconds,
      'metrics': metrics,
    },
  );
}

/// Логирование бизнес событий
void logBusinessEvent(String event, {Map<String, dynamic>? data}) {
  logInfo(
    'Business Event: $event',
    tag: 'BUSINESS',
    extra: {
      'event': event,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}

/// Логирование безопасности
void logSecurity(
  String event, {
  String? userId,
  String? details,
  Map<String, dynamic>? extra,
}) {
  logWarning(
    'Security Event: $event',
    tag: 'SECURITY',
    extra: {
      'event': event,
      'userId': userId,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
      ...?extra,
    },
  );
}

// === УТИЛИТЫ ДЛЯ РАЗРАБОТКИ ===

/// Логирование с замером времени выполнения
Future<T> logTimed<T>(
  String operation,
  Future<T> Function() function, {
  String? tag,
}) async {
  final stopwatch = Stopwatch()..start();

  if (_isInitialized) {
    logDebug('Started: $operation', tag: tag ?? 'TIMER');
  }

  try {
    final result = await function();
    stopwatch.stop();

    if (_isInitialized) {
      logInfo(
        'Completed: $operation in ${stopwatch.elapsedMilliseconds}ms',
        tag: tag ?? 'TIMER',
        extra: {'durationMs': stopwatch.elapsedMilliseconds},
      );
    }

    return result;
  } catch (e, stackTrace) {
    stopwatch.stop();

    if (_isInitialized) {
      logError(
        'Failed: $operation after ${stopwatch.elapsedMilliseconds}ms - $e',
        tag: tag ?? 'TIMER',
        extra: {'durationMs': stopwatch.elapsedMilliseconds},
        stackTrace: stackTrace.toString(),
      );
    }

    rethrow;
  }
}

/// Логирование входа и выхода из функции
void logFunctionEntry(String functionName, {Map<String, dynamic>? parameters}) {
  if (!_isInitialized) return;
  logDebug(
    'Entering $functionName',
    tag: 'FUNCTION',
    extra: {'function': functionName, 'parameters': parameters},
  );
}

void logFunctionExit(String functionName, {dynamic result}) {
  if (!_isInitialized) return;
  logDebug(
    'Exiting $functionName',
    tag: 'FUNCTION',
    extra: {'function': functionName, 'result': result?.toString()},
  );
}
