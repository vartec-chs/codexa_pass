import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'toast_models.dart';
import 'toast_ui_new.dart';

/// Главный класс для управления тостами
class ToastManager {
  static ToastManager? _instance;
  static ToastManager get instance => _instance ??= ToastManager._internal();
  ToastManager._internal();

  /// Очередь всех тостов
  final Queue<ToastConfig> _toastQueue = Queue<ToastConfig>();

  /// Список активных тостов (максимум 3)
  final List<_ActiveToast> _activeToasts = [];

  /// Очередь отложенных тостов (до инициализации)
  static final Queue<ToastConfig> _pendingToasts = Queue<ToastConfig>();

  /// Флаг инициализации
  static bool _isInitialized = false;

  /// Максимальное количество одновременно отображаемых тостов
  static const int maxActiveToasts = 3;

  /// Задержка между показом тостов
  static const Duration delayBetweenToasts = Duration(milliseconds: 200);

  /// Таймер для обработки очереди
  Timer? _queueProcessor;

  /// Навигационный ключ для получения контекста
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Статический OverlayState для прямого доступа
  static OverlayState? _overlayState;

  /// Инициализация с навигационным ключом
  static void initialize(GlobalKey<NavigatorState> navigatorKey) {
    print('Toast Manager: Initializing with navigatorKey');
    instance._navigatorKey = navigatorKey;
    _isInitialized = true;

    // Пытаемся сразу получить OverlayState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Toast Manager: Post frame callback - updating overlay state');
      _updateOverlayState();

      // Обрабатываем отложенные тосты
      _processPendingToasts();
    });
  }

  /// Обрабатываем отложенные тосты после инициализации
  static void _processPendingToasts() {
    print('Toast Manager: Processing ${_pendingToasts.length} pending toasts');
    while (_pendingToasts.isNotEmpty) {
      final config = _pendingToasts.removeFirst();
      instance._addToQueue(config);
    }
  }

  /// Показать отложенный тост (до инициализации MaterialApp)
  static void showPending(ToastConfig config) {
    if (_isInitialized) {
      // Если уже инициализированы, показываем сразу
      show(config);
    } else {
      // Иначе добавляем в очередь отложенных
      _pendingToasts.add(config);
      print('Toast Manager: Added pending toast: ${config.title}');
    }
  }

  /// Показать отложенный тост об ошибке (удобный метод)
  static void showPendingError(
    String title, {
    String? subtitle,
    Duration? duration,
    bool showCopyButton = true,
  }) {
    showPending(
      ToastConfig(
        id: _generateId(),
        title: title,
        subtitle: subtitle,
        type: ToastType.error,
        position: ToastPosition.top,
        duration: duration ?? const Duration(seconds: 8),
        priority: 3,
        showProgressBar: true,
        showCloseButton: true,
        showCopyButton: showCopyButton,
      ),
    );
  }

  /// Обновляем ссылку на OverlayState
  static void _updateOverlayState() {
    final navigatorState = instance._navigatorKey?.currentState;
    print(
      'Toast Manager: Navigator state: ${navigatorState != null ? "available" : "null"}',
    );
    if (navigatorState != null) {
      _overlayState = navigatorState.overlay;
      print(
        'Toast Manager: Overlay state: ${_overlayState != null ? "available" : "null"}',
      );
    }
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
    bool showCopyButton = false,
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
        showCopyButton: showCopyButton,
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
    bool showCopyButton = true,
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
        showCopyButton: showCopyButton,
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
    bool showCopyButton = false,
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
        showCopyButton: showCopyButton,
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
    bool showCopyButton = false,
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
        showCopyButton: showCopyButton,
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
    // Обновляем OverlayState перед показом
    _updateOverlayState();

    // Попробуем использовать статический OverlayState
    if (_overlayState != null) {
      try {
        final overlayEntry = OverlayEntry(
          builder: (context) => ToastUI(config: config),
        );

        // Создаем активный тост с управлением временем
        final activeToast = _ActiveToast(
          config: config,
          overlayEntry: overlayEntry,
          startTime: DateTime.now(),
        );

        _activeToasts.add(activeToast);
        _overlayState!.insert(overlayEntry);

        // Автоматическое скрытие через заданное время (управляется в UI)
        // Timer будет управляться самим ToastUI компонентом
        return;
      } catch (e) {
        print('Toast Manager: Error with static OverlayState: $e');
      }
    }

    // Fallback: используем NavigatorState
    final navigatorState = _navigatorKey?.currentState;
    if (navigatorState == null) {
      print('Toast Manager: NavigatorState is null');
      return;
    }

    try {
      // Получаем OverlayState напрямую из NavigatorState
      final overlayState = navigatorState.overlay;
      if (overlayState == null) {
        print('Toast Manager: OverlayState from Navigator is null');
        return;
      }

      final overlayEntry = OverlayEntry(
        builder: (context) => ToastUI(config: config),
      );

      // Создаем активный тост
      final activeToast = _ActiveToast(
        config: config,
        overlayEntry: overlayEntry,
        startTime: DateTime.now(),
      );

      _activeToasts.add(activeToast);
      overlayState.insert(overlayEntry);
    } catch (e) {
      print('Toast Manager: Error showing toast: $e');
    }
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

    // Учитываем реальную высоту тостов для правильного расчета
    double totalOffset = 0;

    // Суммируем высоты всех предыдущих тостов
    for (int i = 0; i < index; i++) {
      final toastConfig = _activeToasts[i].config;
      double toastHeight = 64; // Минимальная высота

      // Увеличиваем высоту если есть subtitle
      if (toastConfig.subtitle != null && toastConfig.subtitle!.isNotEmpty) {
        toastHeight += 24; // Дополнительные строки для subtitle
      }

      // Добавляем отступ между тостами
      totalOffset += toastHeight + 12; // 12px между тостами
    }

    switch (position) {
      case ToastPosition.top:
      case ToastPosition.topLeft:
      case ToastPosition.topRight:
      case ToastPosition.left:
      case ToastPosition.right:
        return totalOffset;
      case ToastPosition.bottom:
      case ToastPosition.bottomLeft:
      case ToastPosition.bottomRight:
        // Для нижних позиций инвертируем порядок
        double bottomOffset = 0;
        for (int i = index + 1; i < _activeToasts.length; i++) {
          final toastConfig = _activeToasts[i].config;
          double toastHeight = 64;
          if (toastConfig.subtitle != null &&
              toastConfig.subtitle!.isNotEmpty) {
            toastHeight += 24;
          }
          bottomOffset += toastHeight + 12;
        }
        return bottomOffset;
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
