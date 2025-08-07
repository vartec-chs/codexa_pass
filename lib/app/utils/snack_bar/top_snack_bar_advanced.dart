import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'top_snack_bar_config.dart';
import 'top_snack_bar_widget.dart';

/// Расширенный менеджер Top Snack Bar с очередью и приоритетами
class TopSnackBarAdvancedManager {
  static final TopSnackBarAdvancedManager _instance =
      TopSnackBarAdvancedManager._internal();
  factory TopSnackBarAdvancedManager() => _instance;
  TopSnackBarAdvancedManager._internal();

  static OverlayEntry? _currentEntry;
  static bool _isShowing = false;
  final Queue<_PriorityMessage> _messageQueue = Queue<_PriorityMessage>();
  Timer? _autoShowTimer;
  Timer? _queueProcessTimer;

  /// Показать сообщение с приоритетом
  static void showWithPriority(
    BuildContext context,
    TopSnackBarConfig config, {
    int priority = 0,
    bool interruptCurrent = false,
  }) {
    final priorityMessage = _PriorityMessage(
      config: config,
      priority: priority,
      context: context,
    );

    // Если нужно прервать текущее сообщение или это ошибка
    if (interruptCurrent || config.type == TopSnackBarType.error) {
      _instance._interruptAndShow(priorityMessage);
      return;
    }

    // Добавляем в очередь
    _instance._addToQueue(priorityMessage);
  }

  /// Показать множественные сообщения с задержкой
  static void showMultiple(
    BuildContext context,
    List<TopSnackBarConfig> configs, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    for (int i = 0; i < configs.length; i++) {
      Timer(Duration(milliseconds: i * delay.inMilliseconds), () {
        final priorityMessage = _PriorityMessage(
          config: configs[i],
          priority: TopSnackBarUtils.getTypePriority(configs[i].type),
          context: context,
        );
        _instance._addToQueue(priorityMessage);
      });
    }
  }

  /// Прервать текущее и показать новое
  void _interruptAndShow(_PriorityMessage priorityMessage) {
    if (_isShowing) {
      _hideCurrentImmediately();
    }

    // Добавляем в начало очереди для немедленного показа
    _messageQueue.addFirst(priorityMessage);
    _processQueue();
  }

  /// Добавить в очередь с сортировкой по приоритету
  void _addToQueue(_PriorityMessage priorityMessage) {
    _messageQueue.add(priorityMessage);
    _sortQueueByPriority();
    _processQueue();
  }

  /// Сортировать очередь по приоритету
  void _sortQueueByPriority() {
    if (_messageQueue.length <= 1) return;

    final messages = _messageQueue.toList();
    _messageQueue.clear();

    // Сортируем: сначала по типу (ошибки первыми), потом по приоритету
    messages.sort((a, b) {
      final typeComparison = TopSnackBarUtils.getTypePriority(
        a.config.type,
      ).compareTo(TopSnackBarUtils.getTypePriority(b.config.type));

      if (typeComparison != 0) return typeComparison;

      // Если типы одинаковые, сортируем по приоритету (меньше = выше приоритет)
      return a.priority.compareTo(b.priority);
    });

    for (final message in messages) {
      _messageQueue.add(message);
    }
  }

  /// Обработать очередь сообщений
  void _processQueue() {
    if (_isShowing || _messageQueue.isEmpty) return;

    _queueProcessTimer?.cancel();
    _queueProcessTimer = Timer(const Duration(milliseconds: 100), () {
      if (_messageQueue.isNotEmpty && !_isShowing) {
        final nextMessage = _messageQueue.removeFirst();
        _showMessage(nextMessage);
      }
    });
  }

  /// Показать сообщение
  void _showMessage(_PriorityMessage priorityMessage) {
    if (!priorityMessage.context.mounted) {
      _processQueue();
      return;
    }

    _isShowing = true;
    _currentEntry = OverlayEntry(
      builder: (context) => TopSnackBarWidget(
        config: priorityMessage.config,
        onDismiss: () {
          _hideCurrentImmediately();
          priorityMessage.config.onDismiss?.call();
          // Обработать очередь после закрытия
          Timer(const Duration(milliseconds: 200), () {
            _processQueue();
          });
        },
      ),
    );

    Overlay.of(priorityMessage.context).insert(_currentEntry!);

    // Автоматическое скрытие
    Timer(priorityMessage.config.duration, () {
      if (_isShowing) {
        _hideCurrentImmediately();
        // Обработать очередь после автоматического закрытия
        Timer(const Duration(milliseconds: 200), () {
          _processQueue();
        });
      }
    });
  }

  /// Немедленно скрыть текущее сообщение
  void _hideCurrentImmediately() {
    if (_isShowing && _currentEntry != null) {
      _currentEntry!.remove();
      _currentEntry = null;
      _isShowing = false;
    }
  }

  /// Скрыть текущее сообщение
  static void hide() {
    _instance._hideCurrentImmediately();
  }

  /// Очистить очередь
  static void clearQueue() {
    _instance._messageQueue.clear();
    _instance._queueProcessTimer?.cancel();
  }

  /// Пауза обработки очереди
  static void pauseQueue() {
    _instance._queueProcessTimer?.cancel();
  }

  /// Возобновить обработку очереди
  static void resumeQueue() {
    _instance._processQueue();
  }

  /// Получить информацию об очереди
  static QueueInfo getQueueInfo() {
    final queue = _instance._messageQueue.toList();
    final errorCount = queue
        .where((m) => m.config.type == TopSnackBarType.error)
        .length;
    final warningCount = queue
        .where((m) => m.config.type == TopSnackBarType.warning)
        .length;
    final infoCount = queue
        .where((m) => m.config.type == TopSnackBarType.info)
        .length;
    final successCount = queue
        .where((m) => m.config.type == TopSnackBarType.success)
        .length;

    return QueueInfo(
      totalCount: queue.length,
      errorCount: errorCount,
      warningCount: warningCount,
      infoCount: infoCount,
      successCount: successCount,
      isShowing: _isShowing,
      nextMessageType: queue.isNotEmpty ? queue.first.config.type : null,
    );
  }

  /// Автоматический показ с интервалом
  static void startAutoShow({Duration interval = const Duration(seconds: 2)}) {
    _instance._autoShowTimer?.cancel();
    _instance._autoShowTimer = Timer.periodic(interval, (_) {
      _instance._processQueue();
    });
  }

  /// Остановить автоматический показ
  static void stopAutoShow() {
    _instance._autoShowTimer?.cancel();
  }

  /// Освободить ресурсы
  static void dispose() {
    _instance._autoShowTimer?.cancel();
    _instance._queueProcessTimer?.cancel();
    _instance._messageQueue.clear();
    _instance._hideCurrentImmediately();
  }
}

/// Сообщение с приоритетом
class _PriorityMessage {
  final TopSnackBarConfig config;
  final int priority;
  final BuildContext context;

  _PriorityMessage({
    required this.config,
    required this.priority,
    required this.context,
  });
}

/// Информация об очереди сообщений
class QueueInfo {
  final int totalCount;
  final int errorCount;
  final int warningCount;
  final int infoCount;
  final int successCount;
  final bool isShowing;
  final TopSnackBarType? nextMessageType;

  const QueueInfo({
    required this.totalCount,
    required this.errorCount,
    required this.warningCount,
    required this.infoCount,
    required this.successCount,
    required this.isShowing,
    this.nextMessageType,
  });

  @override
  String toString() {
    return 'QueueInfo(total: $totalCount, errors: $errorCount, warnings: $warningCount, '
        'info: $infoCount, success: $successCount, showing: $isShowing, '
        'next: $nextMessageType)';
  }
}

/// Расширенные удобные методы
class TopSnackBarAdvanced {
  /// Показать критическую ошибку (прерывает текущее сообщение)
  static void showCriticalError(
    BuildContext context,
    String message, {
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    TopSnackBarAdvancedManager.showWithPriority(
      context,
      TopSnackBarConfig(
        message: message,
        subtitle: subtitle,
        type: TopSnackBarType.error,
        duration: const Duration(seconds: 6),
        onTap: onTap,
        onDismiss: onDismiss,
      ),
      priority: -100, // Наивысший приоритет
      interruptCurrent: true,
    );
  }

  /// Показать важное предупреждение
  static void showImportantWarning(
    BuildContext context,
    String message, {
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    TopSnackBarAdvancedManager.showWithPriority(
      context,
      TopSnackBarConfig(
        message: message,
        subtitle: subtitle,
        type: TopSnackBarType.warning,
        duration: const Duration(seconds: 5),
        onTap: onTap,
        onDismiss: onDismiss,
      ),
      priority: -50, // Высокий приоритет
    );
  }

  /// Показать последовательность сообщений
  static void showSequence(
    BuildContext context,
    List<String> messages, {
    TopSnackBarType type = TopSnackBarType.info,
    Duration delayBetween = const Duration(milliseconds: 800),
  }) {
    final configs = messages
        .map(
          (message) => TopSnackBarConfig(
            message: message,
            type: type,
            duration: const Duration(seconds: 3),
          ),
        )
        .toList();

    TopSnackBarAdvancedManager.showMultiple(
      context,
      configs,
      delay: delayBetween,
    );
  }

  /// Показать прогресс операции
  static void showProgress(
    BuildContext context,
    String operation, {
    required VoidCallback onComplete,
    VoidCallback? onCancel,
  }) {
    // Показываем начальное сообщение
    TopSnackBarAdvancedManager.showWithPriority(
      context,
      TopSnackBarConfig(
        message: 'Начинаем: $operation',
        type: TopSnackBarType.info,
        duration: const Duration(seconds: 2),
      ),
      priority: 0,
    );

    // Симулируем прогресс (в реальном приложении это будет связано с реальной операцией)
    Timer(const Duration(seconds: 2), () {
      TopSnackBarAdvancedManager.showWithPriority(
        context,
        TopSnackBarConfig(
          message: 'Выполняется: $operation',
          subtitle: 'Пожалуйста, подождите...',
          type: TopSnackBarType.warning,
          duration: const Duration(seconds: 3),
          showCloseButton: onCancel != null,
          onTap: onCancel,
        ),
        priority: 10,
      );
    });

    Timer(const Duration(seconds: 5), () {
      TopSnackBarAdvancedManager.showWithPriority(
        context,
        TopSnackBarConfig(
          message: 'Завершено: $operation',
          subtitle: 'Операция выполнена успешно',
          type: TopSnackBarType.success,
          duration: const Duration(seconds: 3),
          onTap: onComplete,
        ),
        priority: -10,
      );
    });
  }

  /// Получить информацию об очереди
  static QueueInfo getQueueInfo() => TopSnackBarAdvancedManager.getQueueInfo();

  /// Очистить очередь
  static void clearQueue() => TopSnackBarAdvancedManager.clearQueue();

  /// Скрыть текущее
  static void hide() => TopSnackBarAdvancedManager.hide();

  /// Пауза/возобновление очереди
  static void pauseQueue() => TopSnackBarAdvancedManager.pauseQueue();
  static void resumeQueue() => TopSnackBarAdvancedManager.resumeQueue();
}
