import 'dart:io';

import 'package:codexa_pass/app/config/constants.dart';
import 'package:flutter/foundation.dart';

import 'file_manager.dart';
import 'log_buffer.dart';
import 'models.dart';
import 'package:logger/logger.dart';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._();

  AppLogger._();

  late LoggerConfig _config;
  late FileManager _fileManager;
  late LogBuffer _logBuffer;
  late Session _currentSession;
  late Logger _consoleLogger;
  bool _initialized = false;

  LoggerConfig get config => _config;
  Session get currentSession => _currentSession;

  Future<void> initialize({LoggerConfig? config}) async {
    if (_initialized) return;

    _config = config ?? const LoggerConfig();
    _fileManager = FileManager(_config);
    await _fileManager.initialize();

    // Initialize console logger with PrettyPrinter
    _consoleLogger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        levelEmojis: <Level, String>{
          Level.debug: '🐛',
          Level.info: 'ℹ️',
          Level.warning: '⚠️',
          Level.error: '❌',
          Level.verbose: '🔍',
          Level.fatal: '🛑',
          Level.wtf: '🤯',
          Level.off: '🔕',
        },

        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        levelColors: <Level, AnsiColor>{
          Level.debug: AnsiColor.fg(200),
          Level.info: AnsiColor.fg(100),
          Level.warning: AnsiColor.fg(226),
          Level.error: AnsiColor.fg(196),
          Level.verbose: AnsiColor.fg(51),
          Level.fatal: AnsiColor.fg(201),
          Level.wtf: AnsiColor.fg(201),
          Level.off: AnsiColor.fg(240),
        },
      ),
    );

    // Collect device info and create session
    final deviceInfo = await DeviceInfo.collect();
    _currentSession = Session.create(deviceInfo);

    // Initialize buffer
    _logBuffer = LogBuffer(_config, _fileManager);

    // Write session start to file
    await _fileManager.writeSessionStart(_currentSession);

    // Setup crash handler
    if (_config.enableCrashReports) {
      _setupCrashHandler();
    }

    _initialized = true;

    info('Logger initialized', tag: 'AppLogger');
  }

  void _setupCrashHandler() {
    FlutterError.onError = (FlutterErrorDetails details) {
      error(
        'Flutter Error: ${details.exception}',
        error: details.exception,
        stackTrace: details.stack,
        tag: 'FlutterError',
      );

      // Write crash report
      _fileManager.writeCrashReport(
        details.exception,
        details.stack ?? StackTrace.current,
        _currentSession,
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      this.error(
        'Platform Error: $error',
        error: error,
        stackTrace: stack,
        tag: 'PlatformError',
      );

      // Write crash report
      _fileManager.writeCrashReport(error, stack, _currentSession);
      return true;
    };
  }

  void debug(String message, {String? tag, Map<String, dynamic>? data}) {
    if (AppConstants.isDebug) {
      _log(LogLevel.debug, message, tag: tag, additionalData: data);
    }
  }

  void info(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.info, message, tag: tag, additionalData: data);
  }

  void warning(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.warning, message, tag: tag, additionalData: data);
  }

  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    Map<String, dynamic>? data,
  }) {
    _log(
      LogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
      tag: tag,
      additionalData: data,
    );
  }

  void _log(
    LogLevel level,
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    Map<String, dynamic>? additionalData,
  }) {
    if (!_initialized) return;

    // Check if level is enabled
    switch (level) {
      case LogLevel.debug:
        if (!_config.enableDebug) return;
        break;
      case LogLevel.info:
        if (!_config.enableInfo) return;
        break;
      case LogLevel.warning:
        if (!_config.enableWarning) return;
        break;
      case LogLevel.error:
        if (!_config.enableError) return;
        break;
    }

    final entry = LogEntry(
      sessionId: _currentSession.id,
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      additionalData: additionalData,
    );

    // Console output
    if (_config.enableConsoleOutput) {
      final logMessage = tag != null ? '[$tag] $message' : message;
      switch (level) {
        case LogLevel.debug:
          _consoleLogger.d(logMessage, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.info:
          _consoleLogger.i(logMessage, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.warning:
          _consoleLogger.w(logMessage, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.error:
          _consoleLogger.e(logMessage, error: error, stackTrace: stackTrace);
          break;
      }
    }

    // File output
    if (_config.enableFileOutput) {
      _logBuffer.add(entry);
    }
  }

  Future<void> endSession() async {
    if (!_initialized) return;

    _currentSession.end();
    await _fileManager.writeSessionEnd(_currentSession);
    info('Session ended', tag: 'AppLogger');
  }

  Future<void> dispose() async {
    if (!_initialized) return;

    await endSession();
    await _logBuffer.dispose();
    _initialized = false;
  }

  // Utility methods for getting log files
  Future<List<File>> getLogFiles() async {
    final dir = Directory(
      path.join(
        (await getApplicationDocumentsDirectory()).path,
        _config.logDirectory,
      ),
    );
    return dir
        .listSync()
        .where((entity) => entity is File && entity.path.endsWith('.jsonl'))
        .cast<File>()
        .toList();
  }

  Future<List<File>> getCrashReports() async {
    final dir = Directory(
      path.join(
        (await getApplicationDocumentsDirectory()).path,
        _config.crashReportDirectory,
      ),
    );
    return dir
        .listSync()
        .where((entity) => entity is File && entity.path.endsWith('.json'))
        .cast<File>()
        .toList();
  }
}

void logError(
  String message, {
  dynamic error,
  StackTrace? stackTrace,
  String? tag,
  Map<String, dynamic>? data,
}) {
  AppLogger.instance.error(
    message,
    error: error,
    stackTrace: stackTrace,
    tag: tag,
    data: data,
  );
}

void logWarning(String message, {String? tag, Map<String, dynamic>? data}) {
  AppLogger.instance.warning(message, tag: tag, data: data);
}

void logInfo(String message, {String? tag, Map<String, dynamic>? data}) {
  AppLogger.instance.info(message, tag: tag, data: data);
}

void logDebug(String message, {String? tag, Map<String, dynamic>? data}) {
  AppLogger.instance.debug(message, tag: tag, data: data);
}
