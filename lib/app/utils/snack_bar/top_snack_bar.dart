import 'package:flutter/material.dart';

// Экспорты для удобства использования
export 'top_snack_bar_config.dart';
export 'top_snack_bar_manager.dart';
export 'top_snack_bar_widget.dart';
export 'top_snack_bar_advanced.dart';

// Импорты для внутреннего использования
import 'top_snack_bar_config.dart';
import 'top_snack_bar_manager.dart';

/// Удобные методы для быстрого использования Top Snack Bar
class TopSnackBar {
  /// Показать успешное сообщение
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    String? subtitle,
    Widget? customIcon,
  }) {
    TopSnackBarManager.show(
      context,
      TopSnackBarConfig(
        message: message,
        type: TopSnackBarType.success,
        duration: duration ?? const Duration(seconds: 3),
        onTap: onTap,
        onDismiss: onDismiss,
        subtitle: subtitle,
        customIcon: customIcon,
      ),
    );
  }

  /// Показать сообщение об ошибке
  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    String? subtitle,
    Widget? customIcon,
  }) {
    TopSnackBarManager.show(
      context,
      TopSnackBarConfig(
        message: message,
        type: TopSnackBarType.error,
        duration: duration ?? const Duration(seconds: 4),
        onTap: onTap,
        onDismiss: onDismiss,
        subtitle: subtitle,
        customIcon: customIcon,
      ),
    );
  }

  /// Показать предупреждение
  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    String? subtitle,
    Widget? customIcon,
  }) {
    TopSnackBarManager.show(
      context,
      TopSnackBarConfig(
        message: message,
        type: TopSnackBarType.warning,
        duration: duration ?? const Duration(seconds: 3),
        onTap: onTap,
        onDismiss: onDismiss,
        subtitle: subtitle,
        customIcon: customIcon,
      ),
    );
  }

  /// Показать информационное сообщение
  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    String? subtitle,
    Widget? customIcon,
  }) {
    TopSnackBarManager.show(
      context,
      TopSnackBarConfig(
        message: message,
        type: TopSnackBarType.info,
        duration: duration ?? const Duration(seconds: 3),
        onTap: onTap,
        onDismiss: onDismiss,
        subtitle: subtitle,
        customIcon: customIcon,
      ),
    );
  }

  /// Скрыть текущий Top Snack Bar
  static void hide() {
    TopSnackBarManager.hide();
  }

  /// Очистить очередь сообщений
  static void clearQueue() {
    TopSnackBarManager.clearQueue();
  }

  /// Проверить, показывается ли сейчас Top Snack Bar
  static bool get isShowing => TopSnackBarManager.isShowing;

  /// Получить количество сообщений в очереди
  static int get queueLength => TopSnackBarManager.queueLength;

  /// Освободить ресурсы
  static void dispose() {
    TopSnackBarManager.dispose();
  }
}

/// Пример использования Top Snack Bar
class TopSnackBarExample extends StatelessWidget {
  const TopSnackBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Snack Bar Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Кнопка успешного сообщения
            ElevatedButton.icon(
              onPressed: () {
                TopSnackBar.showSuccess(
                  context,
                  'Операция выполнена успешно!',
                  subtitle: 'Все данные сохранены',
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('Success'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 16),

            // Кнопка сообщения об ошибке
            ElevatedButton.icon(
              onPressed: () {
                TopSnackBar.showError(
                  context,
                  'Произошла ошибка при выполнении операции',
                  subtitle: 'Проверьте подключение к интернету',
                );
              },
              icon: const Icon(Icons.error),
              label: const Text('Error'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            const SizedBox(height: 16),

            // Кнопка предупреждения
            ElevatedButton.icon(
              onPressed: () {
                TopSnackBar.showWarning(
                  context,
                  'Внимание! Проверьте введенные данные',
                  subtitle: 'Некоторые поля заполнены неверно',
                );
              },
              icon: const Icon(Icons.warning),
              label: const Text('Warning'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            const SizedBox(height: 16),

            // Кнопка информационного сообщения
            ElevatedButton.icon(
              onPressed: () {
                TopSnackBar.showInfo(
                  context,
                  'Новая версия приложения доступна',
                  subtitle: 'Нажмите для обновления',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Top Snack Bar нажат!')),
                    );
                  },
                );
              },
              icon: const Icon(Icons.info),
              label: const Text('Info'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            const SizedBox(height: 32),

            // Кнопка с кастомной конфигурацией
            ElevatedButton.icon(
              onPressed: () {
                // Пример с полной кастомной конфигурацией
                TopSnackBarManager.show(
                  context,
                  TopSnackBarConfig(
                    message:
                        'Кастомное уведомление с расширенными возможностями',
                    subtitle: 'Это уведомление с кастомными настройками',
                    type: TopSnackBarType.info,
                    duration: const Duration(seconds: 5),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    borderRadius: 16,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Кастомный Top Snack Bar нажат!'),
                        ),
                      );
                    },
                    onDismiss: () {
                      print('Кастомный Top Snack Bar закрыт');
                    },
                  ),
                );
              },
              icon: const Icon(Icons.touch_app),
              label: const Text('Custom'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
            const SizedBox(height: 24),

            // Кнопки управления
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    TopSnackBar.hide();
                  },
                  icon: const Icon(Icons.visibility_off),
                  label: const Text('Hide'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    TopSnackBar.clearQueue();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Очередь очищена')),
                    );
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear Queue'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Информация о состоянии
            Column(
              children: [
                Text(
                  'Показывается: ${TopSnackBar.isShowing ? "Да" : "Нет"}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'В очереди: ${TopSnackBar.queueLength} сообщений',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
