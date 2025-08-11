import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'toast_models.dart';
import 'toast_widget.dart';

/// Главный класс для управления тостами
class ToastManager {
  static ToastManager? _instance;
  static ToastManager get instance => _instance ??= ToastManager._internal();
  ToastManager._internal();

  /// Очередь всех тостов
  final Queue<ToastConfig> _toastQueue = Queue<ToastConfig>();

  /// Список активных тостов (максимум 3)
  final List<_ActiveToast> _activeToasts = [];

  /// Максимальное количество одновременно отображаемых тостов
  static const int maxActiveToasts = 3;

  /// Задержка между показом тостов
  static const Duration delayBetweenToasts = Duration(milliseconds: 200);

  /// Таймер для обработки очереди
  Timer? _queueProcessor;

  /// Навигационный ключ для получения контекста
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Инициализация с навигационным ключом
  static void initialize(GlobalKey<NavigatorState> navigatorKey) {
    instance._navigatorKey = navigatorKey;
  }

  /// Показать тост с успехом
  static void showSuccess(
    String title, {
    String? subtitle,
    Duration? duration,
    ToastPosition position = ToastPosition.top,
    List<ToastAction> actions = const [],
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    double? width,
    bool dismissible = true,
    bool showCloseButton = true,
  }) {
    show(
      ToastConfig(
        id: _generateId(),
        title: title,
        subtitle: subtitle,
        type: ToastType.success,
        position: position,
        duration: duration ?? const Duration(seconds: 4),
        actions: actions,
        onTap: onTap,
        onDismiss: onDismiss,
        width: width,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
        priority: 1,
      ),
    );
  }

  /// Показать тост с ошибкой
  static void showError(
    String title, {
    String? subtitle,
    Duration? duration,
    ToastPosition position = ToastPosition.top,
    List<ToastAction> actions = const [],
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    double? width,
    bool dismissible = true,
    bool showCloseButton = true,
  }) {
    show(
      ToastConfig(
        id: _generateId(),
        title: title,
        subtitle: subtitle,
        type: ToastType.error,
        position: position,
        duration: duration ?? const Duration(seconds: 6),
        actions: actions,
        onTap: onTap,
        onDismiss: onDismiss,
        width: width,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
        priority: 3, // Высокий приоритет для ошибок
      ),
    );
  }

  /// Показать предупреждение
  static void showWarning(
    String title, {
    String? subtitle,
    Duration? duration,
    ToastPosition position = ToastPosition.top,
    List<ToastAction> actions = const [],
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    double? width,
    bool dismissible = true,
    bool showCloseButton = true,
  }) {
    show(
      ToastConfig(
        id: _generateId(),
        title: title,
        subtitle: subtitle,
        type: ToastType.warning,
        position: position,
        duration: duration ?? const Duration(seconds: 5),
        actions: actions,
        onTap: onTap,
        onDismiss: onDismiss,
        width: width,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
        priority: 2,
      ),
    );
  }

  /// Показать информационный тост
  static void showInfo(
    String title, {
    String? subtitle,
    Duration? duration,
    ToastPosition position = ToastPosition.top,
    List<ToastAction> actions = const [],
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    double? width,
    bool dismissible = true,
    bool showCloseButton = true,
  }) {
    show(
      ToastConfig(
        id: _generateId(),
        title: title,
        subtitle: subtitle,
        type: ToastType.info,
        position: position,
        duration: duration ?? const Duration(seconds: 4),
        actions: actions,
        onTap: onTap,
        onDismiss: onDismiss,
        width: width,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
        priority: 1,
      ),
    );
  }

  /// Показать кастомный тост
  static void show(ToastConfig config) {
    instance._addToQueue(config);
  }

  /// Скрыть тост по ID
  static void dismiss(String id) {
    instance._dismissToast(id);
  }

  /// Скрыть все тосты
  static void dismissAll() {
    instance._dismissAllToasts();
  }

  /// Очистить очередь
  static void clearQueue() {
    instance._clearQueue();
  }

  /// Получить количество тостов в очереди
  static int get queueLength => instance._toastQueue.length;

  /// Получить количество активных тостов
  static int get activeCount => instance._activeToasts.length;

  /// Добавить тост в очередь
  void _addToQueue(ToastConfig config) {
    // Если это приоритетный тост (ошибка), добавляем в начало очереди
    if (config.priority > 2) {
      _toastQueue.addFirst(config);
    } else {
      _toastQueue.add(config);
    }

    _processQueue();
  }

  /// Обработать очередь тостов
  void _processQueue() {
    if (_queueProcessor?.isActive == true) return;

    _queueProcessor = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (_toastQueue.isEmpty) {
        timer.cancel();
        return;
      }

      if (_activeToasts.length < maxActiveToasts) {
        final config = _toastQueue.removeFirst();
        _showToast(config);
      }
    });
  }

  /// Показать тост
  void _showToast(ToastConfig config) {
    final context = _navigatorKey?.currentContext;
    if (context == null) return;

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => ToastWidget(
        config: config,
        onDismiss: () => _dismissToast(config.id),
      ),
    );

    // Создаем активный тост
    final activeToast = _ActiveToast(
      config: config,
      overlayEntry: overlayEntry,
      startTime: DateTime.now(),
    );

    _activeToasts.add(activeToast);
    overlay.insert(overlayEntry);

    // Автоматическое скрытие через заданное время
    Timer(config.duration, () {
      _dismissToast(config.id);
    });
  }

  /// Скрыть тост по ID
  void _dismissToast(String id) {
    final index = _activeToasts.indexWhere((toast) => toast.config.id == id);
    if (index == -1) return;

    final activeToast = _activeToasts[index];

    // Вызываем callback
    activeToast.config.onDismiss?.call();

    // Удаляем из overlay
    activeToast.overlayEntry.remove();

    // Удаляем из активных
    _activeToasts.removeAt(index);

    // Обновляем позиции оставшихся тостов
    _updateToastPositions();

    // Продолжаем обработку очереди
    _processQueue();
  }

  /// Скрыть все активные тосты
  void _dismissAllToasts() {
    for (final activeToast in List.from(_activeToasts)) {
      _dismissToast(activeToast.config.id);
    }
  }

  /// Очистить очередь
  void _clearQueue() {
    _toastQueue.clear();
    _queueProcessor?.cancel();
  }

  /// Обновить позиции тостов после удаления
  void _updateToastPositions() {
    // Пересчитываем позиции оставшихся тостов
    for (int i = 0; i < _activeToasts.length; i++) {
      final activeToast = _activeToasts[i];
      activeToast.overlayEntry.markNeedsBuild();
    }
  }

  /// Получить индекс тоста по позиции
  int _getToastIndex(String id) {
    return _activeToasts.indexWhere((toast) => toast.config.id == id);
  }

  /// Получить смещение для тоста по индексу
  double getToastOffset(String id, ToastPosition position) {
    final index = _getToastIndex(id);
    if (index == -1) return 0;

    const toastHeight = 80.0;
    const spacing = 8.0;

    if (position == ToastPosition.top) {
      return (toastHeight + spacing) * index;
    } else {
      return -(toastHeight + spacing) * (_activeToasts.length - 1 - index);
    }
  }

  /// Сгенерировать уникальный ID
  static String generateId() {
    return 'toast_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  /// Приватный метод для генерации ID (для внутреннего использования)
  static String _generateId() {
    return generateId();
  }

  /// Освободить ресурсы
  static void dispose() {
    instance._queueProcessor?.cancel();
    instance._dismissAllToasts();
    instance._clearQueue();
  }
}

/// Класс для хранения информации об активном тосте
class _ActiveToast {
  final ToastConfig config;
  final OverlayEntry overlayEntry;
  final DateTime startTime;

  _ActiveToast({
    required this.config,
    required this.overlayEntry,
    required this.startTime,
  });
}
