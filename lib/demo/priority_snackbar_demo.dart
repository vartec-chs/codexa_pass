import 'dart:async';
import 'package:flutter/material.dart';
import '../app/utils/snack_bar_message.dart';

class PrioritySnackBarDemo extends StatelessWidget {
  const PrioritySnackBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Демо приоритетных SnackBar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Демонстрация приоритетной системы уведомлений',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Ошибки имеют наивысший приоритет и прерывают текущие сообщения.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Тест последовательности сообщений
            ElevatedButton(
              onPressed: _testMessageSequence,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Тест последовательности\n(Info → Warning → Success)',
              ),
            ),
            const SizedBox(height: 16),

            // Тест прерывания ошибкой
            ElevatedButton(
              onPressed: _testErrorInterruption,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Тест прерывания ошибкой\n(Info → ERROR прерывает)',
              ),
            ),
            const SizedBox(height: 16),

            // Тест множественных ошибок
            ElevatedButton(
              onPressed: _testMultipleErrors,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Тест множественных ошибок\n(Несколько ошибок подряд)',
              ),
            ),
            const SizedBox(height: 16),

            // Тест смешанной очереди
            ElevatedButton(
              onPressed: _testMixedQueue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Тест смешанной очереди\n(Все типы + приоритизация)',
              ),
            ),
            const SizedBox(height: 40),

            // Кнопки управления
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: SnackBarManager.hideCurrent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Скрыть текущее'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: SnackBarManager.clearQueue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Очистить очередь'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Индикатор очереди
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                'Сообщений в очереди: ${SnackBarManager.queueLength}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Тест обычной последовательности сообщений
  void _testMessageSequence() {
    SnackBarManager.showInfo(
      'Информационное сообщение',
      duration: const Duration(seconds: 3),
    );

    Timer(const Duration(milliseconds: 500), () {
      SnackBarManager.showWarning(
        'Предупреждение',
        duration: const Duration(seconds: 3),
      );
    });

    Timer(const Duration(milliseconds: 1000), () {
      SnackBarManager.showSuccess(
        'Успешное выполнение',
        duration: const Duration(seconds: 3),
      );
    });
  }

  /// Тест прерывания ошибкой
  void _testErrorInterruption() {
    // Показываем длинное информационное сообщение
    SnackBarManager.showInfo(
      'Длинное информационное сообщение, которое должно быть прервано ошибкой...',
      duration: const Duration(seconds: 8),
    );

    // Через 2 секунды показываем ошибку - она должна прервать info
    Timer(const Duration(seconds: 2), () {
      SnackBarManager.showError(
        'КРИТИЧЕСКАЯ ОШИБКА! Прерываем текущее сообщение',
        duration: const Duration(seconds: 4),
      );
    });
  }

  /// Тест множественных ошибок
  void _testMultipleErrors() {
    // Показываем предупреждение
    SnackBarManager.showWarning(
      'Предупреждение в фоне',
      duration: const Duration(seconds: 5),
    );

    // Добавляем несколько ошибок с интервалом
    Timer(const Duration(milliseconds: 500), () {
      SnackBarManager.showError('Первая ошибка');
    });

    Timer(const Duration(milliseconds: 800), () {
      SnackBarManager.showError('Вторая ошибка');
    });

    Timer(const Duration(milliseconds: 1100), () {
      SnackBarManager.showError('Третья ошибка');
    });
  }

  /// Тест смешанной очереди с приоритизацией
  void _testMixedQueue() {
    // Добавляем сообщения разных типов быстро подряд
    SnackBarManager.showSuccess('Успех 1');
    SnackBarManager.showInfo('Информация 1');
    SnackBarManager.showWarning('Предупреждение 1');
    SnackBarManager.showError('Ошибка 1'); // Должна показаться первой
    SnackBarManager.showInfo('Информация 2');
    SnackBarManager.showError('Ошибка 2'); // Должна показаться второй
    SnackBarManager.showSuccess('Успех 2');
    SnackBarManager.showWarning('Предупреждение 2');

    // Добавляем ещё одну критическую ошибку через секунду
    Timer(const Duration(seconds: 1), () {
      SnackBarManager.showError('КРИТИЧЕСКАЯ ОШИБКА - прерывает очередь!');
    });
  }
}
