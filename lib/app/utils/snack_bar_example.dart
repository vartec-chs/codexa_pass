import 'package:flutter/material.dart';
import 'snack_bar_message.dart';

/// Пример использования SnackBarManager
class SnackBarExamplePage extends StatelessWidget {
  const SnackBarExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnackBar Manager Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Простые сообщения
            const Text(
              'Простые сообщения:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                SnackBarManager.showInfo('Это информационное сообщение');
              },
              child: const Text('Показать Info'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                SnackBarManager.showWarning('Это предупреждение');
              },
              child: const Text('Показать Warning'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                SnackBarManager.showError('Это сообщение об ошибке');
              },
              child: const Text('Показать Error'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                SnackBarManager.showSuccess('Операция выполнена успешно');
              },
              child: const Text('Показать Success'),
            ),
            
            const SizedBox(height: 32),
            
            // Сообщения с действиями
            const Text(
              'Сообщения с действиями:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                SnackBarManager.showError(
                  'Ошибка подключения к серверу',
                  actionLabel: 'Повторить',
                  onAction: () {
                    SnackBarManager.showInfo('Повторная попытка подключения...');
                  },
                );
              },
              child: const Text('Error с действием'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                SnackBarManager.showWarning(
                  'Файл будет удален без возможности восстановления',
                  actionLabel: 'Отмена',
                  duration: const Duration(seconds: 8),
                  onAction: () {
                    SnackBarManager.showInfo('Операция отменена');
                  },
                );
              },
              child: const Text('Warning с действием'),
            ),
            
            const SizedBox(height: 32),
            
            // Тестирование очереди
            const Text(
              'Тестирование очереди:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Добавляем несколько сообщений в очередь
                SnackBarManager.showInfo('Первое сообщение');
                SnackBarManager.showWarning('Второе сообщение');
                SnackBarManager.showError('Третье сообщение');
                SnackBarManager.showSuccess('Четвертое сообщение');
              },
              child: const Text('Показать серию сообщений'),
            ),
            
            const SizedBox(height: 32),
            
            // Управление очередью
            const Text(
              'Управление очередью:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      SnackBarManager.clearQueue();
                      SnackBarManager.showInfo('Очередь очищена');
                    },
                    child: const Text('Очистить очередь'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      SnackBarManager.hideCurrent();
                    },
                    child: const Text('Скрыть текущий'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final queueLength = SnackBarManager.queueLength;
                SnackBarManager.showInfo('В очереди: $queueLength сообщений');
              },
              child: const Text('Проверить очередь'),
            ),
          ],
        ),
      ),
    );
  }
}
