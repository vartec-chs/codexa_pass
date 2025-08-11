import 'package:flutter/material.dart';
import '../scaffold_messenger_manager.dart';

class SnackBarFixTest extends StatelessWidget {
  const SnackBarFixTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тест исправлений SnackBar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Проверка исправлений:\n'
                  '✅ Кнопки не "уезжают"\n'
                  '✅ Текст виден на красном фоне\n'
                  '✅ Правильное расположение элементов\n'
                  '✅ Поддержка всех типов кнопок',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildTestButton(
              'Ошибка с кнопками',
              'Тест видимости текста на красном фоне',
              () => ScaffoldMessengerManager.instance.showError(
                'Критическая ошибка! Этот текст должен быть хорошо виден на красном фоне.',
                showCopyButton: true,
                actionLabel: 'Исправить',
                onActionPressed: () {
                  ScaffoldMessengerManager.instance.showSuccess('Исправлено!');
                },
              ),
              Colors.red,
              Icons.error_outline_rounded,
            ),

            const SizedBox(height: 12),

            _buildTestButton(
              'Предупреждение с действием',
              'Тест кнопки действия',
              () => ScaffoldMessengerManager.instance.showWarning(
                'Важное предупреждение с возможностью действия.',
                actionLabel: 'Понятно',
                onActionPressed: () {
                  ScaffoldMessengerManager.instance.showInfo(
                    'Принято к сведению',
                  );
                },
              ),
              Colors.orange,
              Icons.warning_amber_outlined,
            ),

            const SizedBox(height: 12),

            _buildTestButton(
              'Информация с копированием',
              'Тест кнопки копирования',
              () => ScaffoldMessengerManager.instance.showInfo(
                'Важная информация для копирования: token_12345_abcdef',
              ),
              Colors.blue,
              Icons.info_outline_rounded,
            ),

            const SizedBox(height: 12),

            _buildTestButton(
              'Успех без кнопок',
              'Тест без дополнительных кнопок',
              () => ScaffoldMessengerManager.instance.showSuccess(
                'Операция выполнена успешно! Простое сообщение без кнопок.',
              ),
              Colors.green,
              Icons.check_circle_outline_rounded,
            ),

            const Spacer(),

            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.tips_and_updates_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Совет: Проверьте как выглядят SnackBar в светлой и тёмной темах',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _testSequence(),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Тест последовательности'),
      ),
    );
  }

  Widget _buildTestButton(
    String title,
    String subtitle,
    VoidCallback onPressed,
    Color color,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.touch_app_outlined),
        onTap: onPressed,
      ),
    );
  }

  void _testSequence() {
    ScaffoldMessengerManager.instance.showInfo(
      'Начинаем тест последовательности...',
    );

    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessengerManager.instance.showWarning(
        'Внимание! Сейчас будет ошибка.',
        actionLabel: 'Готов',
        onActionPressed: () {
          Future.delayed(const Duration(milliseconds: 500), () {
            ScaffoldMessengerManager.instance.showError(
              'Это тестовая ошибка для проверки видимости текста.',
              showCopyButton: true,
            );
          });
        },
      );
    });
  }
}
