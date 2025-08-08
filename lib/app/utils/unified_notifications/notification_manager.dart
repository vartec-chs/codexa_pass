import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:codexa_pass/app/logger/app_logger.dart';
import 'notification_config.dart';
import 'notification_widget.dart';

/// Глобальный ключ для ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> globalSnackbarKey =
    GlobalKey<ScaffoldMessengerState>();

/// Главный класс для управления уведомлениями
class UnifiedNotificationManager {
  static final UnifiedNotificationManager _instance =
      UnifiedNotificationManager._internal();
  factory UnifiedNotificationManager() => _instance;
  UnifiedNotificationManager._internal();

  // Управление Overlay уведомлениями (Top/Bottom)
  static OverlayEntry? _currentOverlayEntry;
  static bool _isOverlayShowing = false;
  final Queue<NotificationConfig> _overlayQueue = Queue<NotificationConfig>();

  // Управление SnackBar уведомлениями
  final Queue<NotificationConfig> _snackBarQueue = Queue<NotificationConfig>();
  bool _isSnackBarShowing = false;
  Timer? _autoShowTimer;

  /// Показать уведомление с заданной конфигурацией
  static void show(BuildContext context, NotificationConfig config) {
    logDebug('Showing unified notification: ${config.message}');

    if (config.position == NotificationPosition.top) {
      _instance._showOverlayNotification(context, config);
    } else {
      _instance._showSnackBarNotification(context, config);
    }
  }

  /// Показать информационное уведомление
  static void showInfo(
    String message, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    String? subtitle,
    Widget? customIcon,
  }) {
    final config = NotificationConfig.info(
      message,
      position: position,
      duration: duration,
      onTap: onTap,
      onDismiss: onDismiss,
      subtitle: subtitle,
      customIcon: customIcon,
    );

    if (context != null) {
      show(context, config);
    } else {
      _instance._showSnackBarNotificationGlobal(config);
    }
  }

  /// Показать уведомление об успехе
  static void showSuccess(
    String message, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    String? subtitle,
    Widget? customIcon,
  }) {
    final config = NotificationConfig.success(
      message,
      position: position,
      duration: duration,
      onTap: onTap,
      onDismiss: onDismiss,
      subtitle: subtitle,
      customIcon: customIcon,
    );

    if (context != null) {
      show(context, config);
    } else {
      _instance._showSnackBarNotificationGlobal(config);
    }
  }

  /// Показать предупреждение
  static void showWarning(
    String message, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
    String? subtitle,
    Widget? customIcon,
  }) {
    final config = NotificationConfig.warning(
      message,
      position: position,
      duration: duration,
      onTap: onTap,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
      subtitle: subtitle,
      customIcon: customIcon,
    );

    if (context != null) {
      show(context, config);
    } else {
      _instance._showSnackBarNotificationGlobal(config);
    }
  }

  /// Показать уведомление об ошибке
  static void showError(
    String message, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
    String? subtitle,
    Widget? customIcon,
  }) {
    final config = NotificationConfig.error(
      message,
      position: position,
      duration: duration,
      onTap: onTap,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
      subtitle: subtitle,
      customIcon: customIcon,
    );

    if (context != null) {
      show(context, config);
    } else {
      _instance._showSnackBarNotificationGlobal(config);
    }
  }

  /// Показать уведомление с прогрессом
  static void showProgress(
    String message, {
    BuildContext? context,
    NotificationType type = NotificationType.info,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    double? progress,
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    final config = NotificationConfig.withProgress(
      message,
      type: type,
      position: position,
      duration: duration,
      progress: progress,
      subtitle: subtitle,
      onTap: onTap,
      onDismiss: onDismiss,
    );

    if (context != null) {
      show(context, config);
    } else {
      _instance._showSnackBarNotificationGlobal(config);
    }
  }

  /// Показать Overlay уведомление (Top/Bottom позиционированные)
  void _showOverlayNotification(
    BuildContext context,
    NotificationConfig config,
  ) {
    // Если уже показывается overlay уведомление
    if (_isOverlayShowing) {
      // Для ошибок прерываем текущее сообщение
      if (config.type == NotificationType.error) {
        hideOverlay();
        _showOverlayImmediately(context, config);
        return;
      }

      // Для остальных типов добавляем в очередь
      _addToOverlayQueue(config, context);
      return;
    }

    _showOverlayImmediately(context, config);
  }

  /// Немедленно показать overlay уведомление
  void _showOverlayImmediately(
    BuildContext context,
    NotificationConfig config,
  ) {
    _isOverlayShowing = true;
    _currentOverlayEntry = OverlayEntry(
      builder: (context) => NotificationWidget(
        config: config,
        onDismiss: () {
          hideOverlay();
          config.onDismiss?.call();
          // Обработать очередь после закрытия
          _processOverlayQueue(context);
        },
      ),
    );

    Overlay.of(context).insert(_currentOverlayEntry!);

    // Автоматическое скрытие
    Future.delayed(config.duration, () {
      if (_isOverlayShowing) {
        hideOverlay();
        // Обработать очередь после автоматического закрытия
        _processOverlayQueue(context);
      }
    });
  }

  /// Показать SnackBar уведомление
  void _showSnackBarNotification(
    BuildContext context,
    NotificationConfig config,
  ) {
    // Если это ошибка и есть отображаемое сообщение - скрываем его и показываем ошибку
    if (config.type == NotificationType.error && _isSnackBarShowing) {
      logDebug('Priority error message: interrupting current snackbar');
      // Добавляем ошибку в начало очереди для приоритетного показа
      _snackBarQueue.addFirst(config);
      // Принудительно скрываем текущее сообщение
      _hideCurrentSnackBarAndShowNextGlobal();
      return;
    }

    // Для ошибок добавляем в начало очереди, для остальных - в конец
    if (config.type == NotificationType.error) {
      logDebug('Adding priority error message to front of queue');
      _snackBarQueue.addFirst(config);
    } else {
      _snackBarQueue.add(config);
    }

    _processSnackBarQueue(context);
  }

  /// Показать SnackBar уведомление глобально (без контекста)
  void _showSnackBarNotificationGlobal(NotificationConfig config) {
    // Если это ошибка и есть отображаемое сообщение - скрываем его и показываем ошибку
    if (config.type == NotificationType.error && _isSnackBarShowing) {
      logDebug('Priority error message: interrupting current snackbar');
      // Добавляем ошибку в начало очереди для приоритетного показа
      _snackBarQueue.addFirst(config);
      // Принудительно скрываем текущее сообщение
      _hideCurrentSnackBarAndShowNextGlobal();
      return;
    }

    // Для ошибок добавляем в начало очереди, для остальных - в конец
    if (config.type == NotificationType.error) {
      logDebug('Adding priority error message to front of queue');
      _snackBarQueue.addFirst(config);
    } else {
      _snackBarQueue.add(config);
    }

    _processSnackBarQueueGlobal();
  }

  /// Добавить в очередь overlay уведомлений
  void _addToOverlayQueue(NotificationConfig config, BuildContext context) {
    // Для ошибок добавляем в начало очереди
    if (config.type == NotificationType.error) {
      _overlayQueue.addFirst(config);
    } else {
      _overlayQueue.add(config);
    }

    // Сортируем очередь по приоритету
    _sortOverlayQueueByPriority();
  }

  /// Сортировать очередь overlay по приоритету типов сообщений
  void _sortOverlayQueueByPriority() {
    if (_overlayQueue.length <= 1) return;

    final messages = _overlayQueue.toList();
    _overlayQueue.clear();

    // Сортируем по приоритету: error > warning > info > success
    messages.sort(
      (a, b) => NotificationUtils.getTypePriority(
        a.type,
      ).compareTo(NotificationUtils.getTypePriority(b.type)),
    );

    for (final message in messages) {
      _overlayQueue.add(message);
    }
  }

  /// Сортировать очередь SnackBar по приоритету типов сообщений
  void _sortSnackBarQueueByPriority() {
    if (_snackBarQueue.length <= 1) return;

    final messages = _snackBarQueue.toList();
    _snackBarQueue.clear();

    // Сортируем по приоритету: error > warning > info > success
    messages.sort(
      (a, b) => NotificationUtils.getTypePriority(
        a.type,
      ).compareTo(NotificationUtils.getTypePriority(b.type)),
    );

    for (final message in messages) {
      _snackBarQueue.add(message);
    }
  }

  /// Обработать очередь overlay уведомлений
  void _processOverlayQueue(BuildContext context) {
    if (_isOverlayShowing || _overlayQueue.isEmpty) return;

    // Небольшая задержка перед показом следующего сообщения
    Timer(const Duration(milliseconds: 300), () {
      if (_overlayQueue.isNotEmpty && !_isOverlayShowing) {
        final nextConfig = _overlayQueue.removeFirst();
        _showOverlayImmediately(context, nextConfig);
      }
    });
  }

  /// Обработать очередь SnackBar сообщений
  void _processSnackBarQueue(BuildContext context) {
    if (_isSnackBarShowing || _snackBarQueue.isEmpty) return;

    // Сортируем очередь по приоритету
    _sortSnackBarQueueByPriority();
    _showNextSnackBarMessage(context);
  }

  /// Обработать очередь SnackBar сообщений глобально
  void _processSnackBarQueueGlobal() {
    if (_isSnackBarShowing || _snackBarQueue.isEmpty) return;

    // Сортируем очередь по приоритету
    _sortSnackBarQueueByPriority();
    _showNextSnackBarMessageGlobal();
  }

  /// Показать следующее SnackBar сообщение из очереди
  void _showNextSnackBarMessage(BuildContext context) {
    if (_snackBarQueue.isEmpty) return;

    final message = _snackBarQueue.removeFirst();
    _isSnackBarShowing = true;

    final snackBar = _buildSnackBar(message);

    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
      _isSnackBarShowing = false;
      // Небольшая задержка перед показом следующего сообщения
      Timer(const Duration(milliseconds: 300), () {
        _processSnackBarQueue(context);
      });
    });
  }

  /// Показать следующее SnackBar сообщение из очереди глобально
  void _showNextSnackBarMessageGlobal() {
    if (_snackBarQueue.isEmpty) return;

    final message = _snackBarQueue.removeFirst();
    _isSnackBarShowing = true;

    final snackBar = _buildSnackBar(message);

    globalSnackbarKey.currentState?.showSnackBar(snackBar).closed.then((_) {
      _isSnackBarShowing = false;
      // Небольшая задержка перед показом следующего сообщения
      Timer(const Duration(milliseconds: 300), () {
        _processSnackBarQueueGlobal();
      });
    });
  }

  /// Построить SnackBar для сообщения
  SnackBar _buildSnackBar(NotificationConfig config) {
    final colors = NotificationColors.forType(config.type);
    final theme = NotificationTheme.forType(config.type);

    return SnackBar(
      content: _buildSnackBarContent(config, colors, theme),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: config.margin,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
      ),
      duration: config.duration,
      action: null,
      dismissDirection: config.isDismissible
          ? DismissDirection.horizontal
          : DismissDirection.none,
    );
  }

  /// Построить содержимое SnackBar
  Widget _buildSnackBarContent(
    NotificationConfig config,
    NotificationColors colors,
    NotificationTheme theme,
  ) {
    return Container(
      padding: config.padding,
      decoration: BoxDecoration(
        gradient: theme.gradient,
        borderRadius: BorderRadius.circular(config.borderRadius),
        border: Border.all(
          color: colors.borderColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: theme.shadows,
      ),
      child: Row(
        children: [
          // Иконка
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              config.customIcon != null
                  ? (config.customIcon as Icon).icon
                  : NotificationUtils.getIconForType(config.type),
              color: colors.iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Контент сообщения
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Основное сообщение
                Text(
                  config.message,
                  style: TextStyle(
                    color: colors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Подзаголовок
                if (config.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    config.subtitle!,
                    style: TextStyle(
                      color: colors.textColor.withOpacity(0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Прогресс-бар
                if (config.showProgress) ...[
                  const SizedBox(height: 12),
                  _buildProgressIndicator(config.progress, colors),
                ],
              ],
            ),
          ),

          // Кнопка действия
          if (config.actionLabel != null && config.onAction != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: config.onAction,
              style: TextButton.styleFrom(
                foregroundColor: colors.actionColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
              child: Text(
                config.actionLabel!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Построить индикатор прогресса
  Widget _buildProgressIndicator(double? progress, NotificationColors colors) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: progress != null
          ? FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (progress / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )
          : const LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
    );
  }

  /// Скрыть overlay уведомление
  static void hideOverlay() {
    if (_isOverlayShowing && _currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
      _currentOverlayEntry = null;
      _isOverlayShowing = false;
    }
  }

  /// Скрыть SnackBar уведомление
  static void hideSnackBar() {
    globalSnackbarKey.currentState?.hideCurrentSnackBar();
    _instance._isSnackBarShowing = false;
  }

  /// Скрыть все уведомления
  static void hideAll() {
    hideOverlay();
    hideSnackBar();
  }

  /// Скрыть текущий SnackBar и немедленно показать следующий глобально (для приоритетных сообщений)
  void _hideCurrentSnackBarAndShowNextGlobal() {
    globalSnackbarKey.currentState?.hideCurrentSnackBar();
    _isSnackBarShowing = false;
    // Минимальная задержка для приоритетных сообщений (ошибок)
    Timer(const Duration(milliseconds: 50), () {
      _processSnackBarQueueGlobal();
    });
  }

  /// Очистить все очереди сообщений
  static void clearQueue() {
    _instance._overlayQueue.clear();
    _instance._snackBarQueue.clear();
  }

  /// Очистить очередь overlay сообщений
  static void clearOverlayQueue() {
    _instance._overlayQueue.clear();
  }

  /// Очистить очередь SnackBar сообщений
  static void clearSnackBarQueue() {
    _instance._snackBarQueue.clear();
  }

  /// Получить количество сообщений в очереди overlay
  static int get overlayQueueLength => _instance._overlayQueue.length;

  /// Получить количество сообщений в очереди SnackBar
  static int get snackBarQueueLength => _instance._snackBarQueue.length;

  /// Получить общее количество сообщений в очередях
  static int get totalQueueLength => overlayQueueLength + snackBarQueueLength;

  /// Проверить, показывается ли сейчас overlay уведомление
  static bool get isOverlayShowing => _isOverlayShowing;

  /// Проверить, показывается ли сейчас SnackBar уведомление
  static bool get isSnackBarShowing => _instance._isSnackBarShowing;

  /// Проверить, показывается ли любое уведомление
  static bool get isAnyShowing => isOverlayShowing || isSnackBarShowing;

  /// Запустить автоматический показ SnackBar сообщений с интервалом
  static void startAutoShow({Duration interval = const Duration(seconds: 2)}) {
    _instance._autoShowTimer?.cancel();
    _instance._autoShowTimer = Timer.periodic(interval, (_) {
      _instance._processSnackBarQueueGlobal();
    });
  }

  /// Остановить автоматический показ сообщений
  static void stopAutoShow() {
    _instance._autoShowTimer?.cancel();
    _instance._autoShowTimer = null;
  }

  /// Освободить ресурсы
  static void dispose() {
    _instance._autoShowTimer?.cancel();
    _instance._overlayQueue.clear();
    _instance._snackBarQueue.clear();
    hideAll();
  }
}
