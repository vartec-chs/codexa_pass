import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'snack_bar_message.dart';

/// Примеры использования улучшенного UI для SnackBarManager
class SnackBarUIExamplesPage extends StatefulWidget {
  const SnackBarUIExamplesPage({super.key});

  @override
  State<SnackBarUIExamplesPage> createState() => _SnackBarUIExamplesPageState();
}

class _SnackBarUIExamplesPageState extends State<SnackBarUIExamplesPage> {
  double _progress = 0.0;
  Timer? _progressTimer;

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Улучшенный UI SnackBar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Базовые сообщения с улучшенным дизайном
            _buildSection('Базовые сообщения с новым дизайном', [
              _buildButton(
                'Info с градиентом',
                Colors.blue,
                () => SnackBarManager.showInfo(
                  'Информационное сообщение с красивым градиентом и тенями',
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Warning с анимацией',
                Colors.orange,
                () => SnackBarManager.showWarning(
                  'Предупреждение с улучшенной анимацией и эффектами',
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Error стильный',
                Colors.red,
                () => SnackBarManager.showError(
                  'Ошибка с современным дизайном и градиентом',
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Success элегантный',
                Colors.green,
                () => SnackBarManager.showSuccess(
                  'Успешная операция с красивыми эффектами',
                ),
              ),
            ]),

            // Сообщения с подзаголовками
            _buildSection('Сообщения с подзаголовками', [
              _buildButton(
                'Info с описанием',
                Colors.blue.shade600,
                () => SnackBarManager.showInfo(
                  'Синхронизация данных',
                  subtitle:
                      'Обновление информации о пользователе и настройках приложения',
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Warning с деталями',
                Colors.orange.shade600,
                () => SnackBarManager.showWarning(
                  'Низкий заряд батареи',
                  subtitle:
                      'Рекомендуется подключить устройство к зарядному устройству',
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Error с решением',
                Colors.red.shade600,
                () => SnackBarManager.showError(
                  'Ошибка подключения',
                  subtitle: 'Проверьте интернет-соединение и попробуйте снова',
                ),
              ),
            ]),

            // Прогресс-бары
            _buildSection('Индикаторы прогресса', [
              _buildButton(
                'Фиксированный прогресс',
                Colors.purple,
                () => SnackBarManager.showInfo(
                  'Загрузка файла',
                  subtitle: 'document.pdf (2.5 MB)',
                  showProgress: true,
                  progress: 65.0,
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Неопределенный прогресс',
                Colors.indigo,
                () => SnackBarManager.showInfo(
                  'Обработка данных',
                  subtitle: 'Пожалуйста, подождите...',
                  showProgress: true,
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Анимированный прогресс',
                Colors.teal,
                () => _showAnimatedProgress(),
              ),
            ]),

            // Сообщения с действиями
            _buildSection('Сообщения с кнопками действий', [
              _buildButton(
                'Подтверждение действия',
                Colors.deepOrange,
                () => SnackBarManager.showWarning(
                  'Удалить выбранные файлы?',
                  subtitle: 'Это действие нельзя будет отменить',
                  actionLabel: 'Удалить',
                  onAction: () {
                    SnackBarManager.showSuccess('Файлы удалены');
                  },
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Действие с обратной связью',
                Colors.brown,
                () => SnackBarManager.showInfo(
                  'Новое обновление доступно',
                  subtitle:
                      'Версия 2.1.0 содержит улучшения производительности',
                  actionLabel: 'Обновить',
                  onAction: () {
                    SnackBarManager.showInfo(
                      'Загрузка обновления...',
                      showProgress: true,
                    );
                  },
                ),
              ),
            ]),

            // Кастомные иконки
            _buildSection('Кастомные иконки', [
              _buildButton(
                'Уведомление почты',
                Colors.blueAccent,
                () => SnackBarManager.showInfo(
                  'Новое сообщение',
                  subtitle: 'От: john.doe@example.com',
                  customIcon: const Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Загрузка в облако',
                Colors.lightBlue,
                () => SnackBarManager.showSuccess(
                  'Файл загружен в облако',
                  subtitle: 'Доступен для совместного использования',
                  customIcon: const Icon(Icons.cloud_upload_outlined),
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Безопасность',
                Colors.amber,
                () => SnackBarManager.showWarning(
                  'Требуется двухфакторная аутентификация',
                  subtitle: 'Для повышения безопасности аккаунта',
                  customIcon: const Icon(Icons.security_outlined),
                ),
              ),
            ]),

            // Неотключаемые сообщения
            _buildSection('Специальные режимы', [
              _buildButton(
                'Неотключаемое сообщение',
                Colors.red.shade800,
                () => SnackBarManager.showError(
                  'Критическая ошибка системы',
                  subtitle: 'Требуется немедленное внимание',
                  // isDismissible: false, // Раскомментируйте для неотключаемого сообщения
                ),
              ),
              const SizedBox(height: 8),
              _buildButton(
                'Длительное уведомление',
                Colors.deepPurple,
                () => SnackBarManager.showInfo(
                  'Долгосрочная операция',
                  subtitle: 'Это уведомление будет показано 15 секунд',
                  duration: const Duration(seconds: 15),
                ),
              ),
            ]),

            // Массовые уведомления
            _buildSection('Тестирование очереди', [
              _buildButton(
                'Серия уведомлений',
                Colors.pink,
                () => _showNotificationSeries(),
              ),
              const SizedBox(height: 8),
              _buildButton('Очистить очередь', Colors.grey, () {
                SnackBarManager.clearQueue();
                SnackBarManager.showInfo('Очередь уведомлений очищена');
              }),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade100, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color.darken(0.3),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: color.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAnimatedProgress() {
    _progress = 0.0;
    _progressTimer?.cancel();

    SnackBarManager.showInfo(
      'Анимированная загрузка',
      subtitle: 'Прогресс будет обновляться в реальном времени',
      showProgress: true,
      progress: _progress,
    );

    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _progress += Random().nextDouble() * 5;
      if (_progress >= 100) {
        _progress = 100;
        timer.cancel();
        SnackBarManager.showSuccess('Загрузка завершена!');
      } else {
        SnackBarManager.showInfo(
          'Загрузка файла',
          subtitle: '${_progress.toInt()}% завершено',
          showProgress: true,
          progress: _progress,
        );
      }
    });
  }

  void _showNotificationSeries() {
    final messages = [
      ('Инициализация приложения', SnackBarType.info),
      ('Проверка обновлений', SnackBarType.info),
      ('Подключение к серверу', SnackBarType.warning),
      ('Загрузка пользовательских данных', SnackBarType.info),
      ('Приложение готово к работе', SnackBarType.success),
    ];

    for (int i = 0; i < messages.length; i++) {
      Timer(Duration(milliseconds: i * 800), () {
        final (message, type) = messages[i];
        switch (type) {
          case SnackBarType.info:
            SnackBarManager.showInfo(message);
            break;
          case SnackBarType.warning:
            SnackBarManager.showWarning(message);
            break;
          case SnackBarType.success:
            SnackBarManager.showSuccess(message);
            break;
          case SnackBarType.error:
            SnackBarManager.showError(message);
            break;
        }
      });
    }
  }
}

extension ColorExtension on Color {
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }
}
