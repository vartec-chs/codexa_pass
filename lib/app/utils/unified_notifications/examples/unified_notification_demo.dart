import 'package:flutter/material.dart';
import '../unified_notification.dart';
import '../notification_extensions.dart';

/// Демонстрационное приложение для унифицированной системы уведомлений
class UnifiedNotificationDemo extends StatefulWidget {
  const UnifiedNotificationDemo({Key? key}) : super(key: key);

  @override
  State<UnifiedNotificationDemo> createState() =>
      _UnifiedNotificationDemoState();
}

class _UnifiedNotificationDemoState extends State<UnifiedNotificationDemo> {
  int _counter = 0;

  @override
  void dispose() {
    UnifiedNotification.dispose();
    UnifiedNotificationManagerExtensions.disposeExtensions();
    super.dispose();
  }

  void _simulateFileOperation() {
    setState(() => _counter++);

    // Показываем прогресс
    UnifiedNotification.progress(
      'Сохранение файла $_counter...',
      context: context,
      progress: 0,
      subtitle: 'Начинаем сохранение',
    );

    // Симулируем прогресс
    Future.delayed(const Duration(milliseconds: 500), () {
      UnifiedNotification.progress(
        'Сохранение файла $_counter...',
        context: context,
        progress: 30,
        subtitle: '30% завершено',
      );
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      UnifiedNotification.progress(
        'Сохранение файла $_counter...',
        context: context,
        progress: 70,
        subtitle: '70% завершено',
      );
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      UnifiedNotificationTemplates.showFileSaved(
        'document_$_counter.pdf',
        context: context,
      );
    });
  }

  void _simulateNetworkOperation() {
    UnifiedNotificationTemplates.showDataLoading(context: context);

    Future.delayed(const Duration(seconds: 2), () {
      if (_counter % 2 == 0) {
        UnifiedNotificationTemplates.showNetworkSuccess(context: context);
      } else {
        UnifiedNotificationTemplates.showNetworkError(
          context: context,
          onRetry: () => _simulateNetworkOperation(),
        );
      }
    });
  }

  void _showPriorityDemo() {
    // Добавляем несколько обычных сообщений
    UnifiedNotification.info('Первое сообщение', context: context);
    UnifiedNotification.info('Второе сообщение', context: context);
    UnifiedNotification.success('Третье сообщение', context: context);

    // Через секунду показываем ошибку (должна прервать текущие)
    Future.delayed(const Duration(seconds: 1), () {
      UnifiedNotification.error(
        'Критическая ошибка!',
        context: context,
        subtitle: 'Эта ошибка прервала другие уведомления',
      );
    });
  }

  void _showTopNotifications() {
    UnifiedNotification.info(
      'Top уведомление',
      context: context,
      position: NotificationPosition.top,
      subtitle: 'Показывается сверху экрана',
    );

    Future.delayed(const Duration(seconds: 1), () {
      UnifiedNotification.warning(
        'Top предупреждение',
        context: context,
        position: NotificationPosition.top,
        subtitle: 'С действием',
        onAction: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Действие выполнено!')));
        },
        actionLabel: 'Выполнить',
      );
    });
  }

  void _showGroupDemo() {
    UnifiedNotificationManagerExtensions.showGroup([
      (
        message: 'Шаг 1: Инициализация',
        type: NotificationType.info,
        delay: null,
      ),
      (
        message: 'Шаг 2: Загрузка данных',
        type: NotificationType.info,
        delay: const Duration(milliseconds: 800),
      ),
      (
        message: 'Шаг 3: Обработка',
        type: NotificationType.warning,
        delay: const Duration(milliseconds: 1600),
      ),
      (
        message: 'Завершено успешно!',
        type: NotificationType.success,
        delay: const Duration(milliseconds: 2400),
      ),
    ], context: context);
  }

  void _showCountdownDemo() {
    UnifiedNotificationManagerExtensions.showWithCountdown(
      'Автоматическое обновление',
      NotificationType.warning,
      context: context,
      countdownDuration: const Duration(seconds: 5),
      onTimeout: () {
        UnifiedNotification.success('Обновление выполнено!', context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unified Notification Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Информационная карточка
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.notifications_active,
                        size: 48,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Unified Notification System',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Демонстрация возможностей унифицированной системы уведомлений',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Базовые уведомления
              _buildSection('Базовые уведомления', Icons.message, [
                _buildActionButton(
                  'Success',
                  Icons.check_circle,
                  Colors.green,
                  () => UnifiedNotification.success(
                    'Операция выполнена успешно!',
                    context: context,
                    subtitle: 'Все данные сохранены корректно',
                  ),
                ),
                _buildActionButton(
                  'Error',
                  Icons.error,
                  Colors.red,
                  () => UnifiedNotification.error(
                    'Произошла ошибка!',
                    context: context,
                    subtitle: 'Не удалось подключиться к серверу',
                  ),
                ),
                _buildActionButton(
                  'Warning',
                  Icons.warning,
                  Colors.orange,
                  () => UnifiedNotification.warning(
                    'Внимание!',
                    context: context,
                    subtitle: 'Проверьте введенные данные',
                  ),
                ),
                _buildActionButton(
                  'Info',
                  Icons.info,
                  Colors.blue,
                  () => UnifiedNotification.info(
                    'Информация',
                    context: context,
                    subtitle: 'Новая версия приложения доступна',
                  ),
                ),
              ]),

              // Top уведомления
              _buildSection('Top уведомления', Icons.vertical_align_top, [
                _buildActionButton(
                  'Top Notifications',
                  Icons.arrow_upward,
                  Colors.purple,
                  _showTopNotifications,
                ),
              ]),

              // Прогресс и файлы
              _buildSection('Прогресс и файлы', Icons.file_copy, [
                _buildActionButton(
                  'File Operation',
                  Icons.save,
                  Colors.indigo,
                  _simulateFileOperation,
                ),
                _buildActionButton(
                  'Network Operation',
                  Icons.cloud_download,
                  Colors.teal,
                  _simulateNetworkOperation,
                ),
              ]),

              // Специальные демо
              _buildSection('Специальные возможности', Icons.star, [
                _buildActionButton(
                  'Priority Demo',
                  Icons.priority_high,
                  Colors.deepOrange,
                  _showPriorityDemo,
                ),
                _buildActionButton(
                  'Group Demo',
                  Icons.group_work,
                  Colors.green.shade700,
                  _showGroupDemo,
                ),
                _buildActionButton(
                  'Countdown Demo',
                  Icons.timer,
                  Colors.pink,
                  _showCountdownDemo,
                ),
              ]),

              // Управление
              _buildSection('Управление', Icons.settings, [
                _buildActionButton(
                  'Hide All',
                  Icons.visibility_off,
                  Colors.grey,
                  () => UnifiedNotification.hideAll(),
                ),
                _buildActionButton(
                  'Clear Queue',
                  Icons.clear_all,
                  Colors.grey.shade600,
                  () {
                    UnifiedNotification.clearQueue();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Очереди очищены')),
                    );
                  },
                ),
              ]),

              // Статистика
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          const Text(
                            'Статистика',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow('Операций выполнено:', '$_counter'),
                      _buildStatRow(
                        'Overlay показывается:',
                        UnifiedNotification.isOverlayShowing ? 'Да' : 'Нет',
                      ),
                      _buildStatRow(
                        'SnackBar показывается:',
                        UnifiedNotification.isSnackBarShowing ? 'Да' : 'Нет',
                      ),
                      _buildStatRow(
                        'Overlay очередь:',
                        '${UnifiedNotification.overlayQueueLength}',
                      ),
                      _buildStatRow(
                        'SnackBar очередь:',
                        '${UnifiedNotification.snackBarQueueLength}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...children.map(
          (child) =>
              Padding(padding: const EdgeInsets.only(bottom: 8), child: child),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
