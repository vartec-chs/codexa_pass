import 'dart:async';

import 'package:codexa_pass/app/logger/file_manager.dart';
import 'package:codexa_pass/app/logger/models.dart';

class LogBuffer {
  final LoggerConfig config;
  final FileManager fileManager;
  final List<LogEntry> _buffer = [];
  Timer? _flushTimer;

  LogBuffer(this.config, this.fileManager) {
    _startFlushTimer();
  }

  void add(LogEntry entry) {
    _buffer.add(entry);
    if (_buffer.length >= config.bufferSize) {
      _flush();
    }
  }

  void _startFlushTimer() {
    _flushTimer = Timer.periodic(config.bufferFlushInterval, (_) => _flush());
  }

  Future<void> _flush() async {
    if (_buffer.isEmpty) return;

    final entries = List<LogEntry>.from(_buffer);
    _buffer.clear();

    for (final entry in entries) {
      await fileManager.writeLogEntry(entry);
    }
  }

  Future<void> dispose() async {
    _flushTimer?.cancel();
    await _flush();
  }
}
