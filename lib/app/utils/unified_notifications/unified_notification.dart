// Unified Notification System
// Объединенная система уведомлений для Flutter приложений
//
// Поддерживает:
// - Top и Bottom уведомления (Overlay)
// - SnackBar уведомления
// - Приоритетные ошибки
// - Прогресс-бары
// - Анимации
// - Очереди сообщений
// - Расширенные возможности

// Экспорты для удобства использования
export 'notification_config.dart';
export 'notification_manager.dart';
export 'notification_widget.dart';
export 'notification_extensions.dart';

// Импорты для внутреннего использования
import 'package:flutter/material.dart';
import 'notification_config.dart';
import 'notification_manager.dart';

/// Главный класс унифицированной системы уведомлений
///
/// Предоставляет удобные статические методы для быстрого использования.
/// Автоматически выбирает между Overlay и SnackBar в зависимости от позиции.
class UnifiedNotification {
  /// Показать информационное уведомление
  ///
  /// [message] - текст сообщения
  /// [context] - контекст для показа (необязательно для bottom позиции)
  /// [position] - позиция уведомления (top или bottom)
  /// [duration] - длительность показа
  /// [subtitle] - дополнительный текст
  /// [onTap] - обработчик нажатия
  /// [onDismiss] - обработчик закрытия
  /// [customIcon] - кастомная иконка
  static void info(
    String message, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    Widget? customIcon,
  }) {
    UnifiedNotificationManager.showInfo(
      message,
      context: context,
      position: position,
      duration: duration,
      subtitle: subtitle,
      onTap: onTap,
      onDismiss: onDismiss,
      customIcon: customIcon,
    );
  }

  /// Показать уведомление об успехе
  static void success(
    String message, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    Widget? customIcon,
  }) {
    UnifiedNotificationManager.showSuccess(
      message,
      context: context,
      position: position,
      duration: duration,
      subtitle: subtitle,
      onTap: onTap,
      onDismiss: onDismiss,
      customIcon: customIcon,
    );
  }

  /// Показать предупреждение
  static void warning(
    String message, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
    Widget? customIcon,
  }) {
    UnifiedNotificationManager.showWarning(
      message,
      context: context,
      position: position,
      duration: duration,
      subtitle: subtitle,
      onTap: onTap,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
      customIcon: customIcon,
    );
  }

  /// Показать уведомление об ошибке (приоритетное)
  static void error(
    String message, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
    Widget? customIcon,
  }) {
    UnifiedNotificationManager.showError(
      message,
      context: context,
      position: position,
      duration: duration,
      subtitle: subtitle,
      onTap: onTap,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
      customIcon: customIcon,
    );
  }

  /// Показать уведомление с прогресс-баром
  static void progress(
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
    UnifiedNotificationManager.showProgress(
      message,
      context: context,
      type: type,
      position: position,
      duration: duration,
      progress: progress,
      subtitle: subtitle,
      onTap: onTap,
      onDismiss: onDismiss,
    );
  }

  /// Показать уведомление с кастомной конфигурацией
  static void custom(BuildContext context, NotificationConfig config) {
    UnifiedNotificationManager.show(context, config);
  }

  /// Скрыть все уведомления
  static void hideAll() {
    UnifiedNotificationManager.hideAll();
  }

  /// Скрыть overlay уведомления (top/bottom positioned)
  static void hideOverlay() {
    UnifiedNotificationManager.hideOverlay();
  }

  /// Скрыть SnackBar уведомления
  static void hideSnackBar() {
    UnifiedNotificationManager.hideSnackBar();
  }

  /// Очистить все очереди сообщений
  static void clearQueue() {
    UnifiedNotificationManager.clearQueue();
  }

  /// Очистить очередь overlay сообщений
  static void clearOverlayQueue() {
    UnifiedNotificationManager.clearOverlayQueue();
  }

  /// Очистить очередь SnackBar сообщений
  static void clearSnackBarQueue() {
    UnifiedNotificationManager.clearSnackBarQueue();
  }

  /// Получить количество сообщений в очереди overlay
  static int get overlayQueueLength =>
      UnifiedNotificationManager.overlayQueueLength;

  /// Получить количество сообщений в очереди SnackBar
  static int get snackBarQueueLength =>
      UnifiedNotificationManager.snackBarQueueLength;

  /// Получить общее количество сообщений в очередях
  static int get totalQueueLength =>
      UnifiedNotificationManager.totalQueueLength;

  /// Проверить, показывается ли сейчас overlay уведомление
  static bool get isOverlayShowing =>
      UnifiedNotificationManager.isOverlayShowing;

  /// Проверить, показывается ли сейчас SnackBar уведомление
  static bool get isSnackBarShowing =>
      UnifiedNotificationManager.isSnackBarShowing;

  /// Проверить, показывается ли любое уведомление
  static bool get isAnyShowing => UnifiedNotificationManager.isAnyShowing;

  /// Запустить автоматический показ SnackBar сообщений с интервалом
  static void startAutoShow({Duration interval = const Duration(seconds: 2)}) {
    UnifiedNotificationManager.startAutoShow(interval: interval);
  }

  /// Остановить автоматический показ сообщений
  static void stopAutoShow() {
    UnifiedNotificationManager.stopAutoShow();
  }

  /// Освободить ресурсы
  static void dispose() {
    UnifiedNotificationManager.dispose();
  }
}

/// Пример использования унифицированной системы уведомлений
class UnifiedNotificationExample extends StatelessWidget {
  const UnifiedNotificationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unified Notification System'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Заголовок секции
            const Text(
              'Bottom Notifications (SnackBar)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Bottom уведомления
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.success(
                        'Операция выполнена успешно!',
                        context: context,
                        subtitle: 'Все данные сохранены',
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Success'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.error(
                        'Произошла ошибка!',
                        context: context,
                        subtitle: 'Проверьте подключение к интернету',
                      );
                    },
                    icon: const Icon(Icons.error),
                    label: const Text('Error'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.warning(
                        'Внимание! Проверьте данные',
                        context: context,
                        subtitle: 'Некоторые поля заполнены неверно',
                      );
                    },
                    icon: const Icon(Icons.warning),
                    label: const Text('Warning'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.info(
                        'Новая версия доступна',
                        context: context,
                        subtitle: 'Нажмите для подробностей',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Уведомление нажато!'),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.info),
                    label: const Text('Info'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Заголовок секции
            const Text(
              'Top Notifications (Overlay)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Top уведомления
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.success(
                        'Синхронизация завершена!',
                        context: context,
                        position: NotificationPosition.top,
                        subtitle: 'Все изменения сохранены',
                      );
                    },
                    icon: const Icon(Icons.cloud_done),
                    label: const Text('Top Success'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.error(
                        'Критическая ошибка!',
                        context: context,
                        position: NotificationPosition.top,
                        subtitle: 'Необходимо перезапустить приложение',
                      );
                    },
                    icon: const Icon(Icons.bug_report),
                    label: const Text('Top Error'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Заголовок секции
            const Text(
              'Progress Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Прогресс уведомления
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.progress(
                        'Загрузка файлов...',
                        context: context,
                        progress: 45.0,
                        subtitle: '45% завершено',
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Progress 45%'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.progress(
                        'Обработка данных...',
                        context: context,
                        type: NotificationType.warning,
                        subtitle: 'Индикатор прогресса',
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Animated Progress'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Кнопки управления
            const Text(
              'Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.hideAll();
                    },
                    icon: const Icon(Icons.visibility_off),
                    label: const Text('Hide All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      UnifiedNotification.clearQueue();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Очереди очищены')),
                      );
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear Queue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Информация о состоянии
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Статистика',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Overlay: ${UnifiedNotification.isOverlayShowing ? "Показывается" : "Скрыт"}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'SnackBar: ${UnifiedNotification.isSnackBarShowing ? "Показывается" : "Скрыт"}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Очередь Overlay: ${UnifiedNotification.overlayQueueLength} сообщений',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Очередь SnackBar: ${UnifiedNotification.snackBarQueueLength} сообщений',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
