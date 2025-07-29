import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'snack_bar_message.dart';
import 'snack_bar_extensions.dart';

/// Примеры использования SnackBarManagerExtensions
class SnackBarExtensionsExamplePage extends StatefulWidget {
  const SnackBarExtensionsExamplePage({super.key});

  @override
  State<SnackBarExtensionsExamplePage> createState() =>
      _SnackBarExtensionsExamplePageState();
}

class _SnackBarExtensionsExamplePageState
    extends State<SnackBarExtensionsExamplePage> {
  StreamController<String>? _progressController;
  bool _isDownloading = false;

  @override
  void dispose() {
    _progressController?.close();
    SnackBarManagerExtensions.disposeExtensions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBar Extensions Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Прогресс-сообщения
            _buildSection('Прогресс-сообщения', [
              ElevatedButton(
                onPressed: _showFileDownloadProgress,
                child: const Text('Симуляция загрузки файла'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _showDataProcessingProgress,
                child: const Text('Обработка данных'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  SnackBarManagerExtensions.stopProgress();
                  SnackBarManager.showInfo('Прогресс остановлен');
                },
                child: const Text('Остановить прогресс'),
              ),
            ]),

            // Сообщения с подтверждением
            _buildSection('Сообщения с подтверждением', [
              ElevatedButton(
                onPressed: () {
                  SnackBarManagerExtensions.showConfirmation(
                    'Удалить все данные?',
                    onConfirm: () {
                      SnackBarManager.showSuccess('Данные удалены');
                    },
                    onCancel: () {
                      SnackBarManager.showInfo('Операция отменена');
                    },
                  );
                },
                child: const Text('Подтверждение удаления'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  SnackBarManagerExtensions.showConfirmation(
                    'Выйти без сохранения изменений?',
                    confirmLabel: 'Выйти',
                    cancelLabel: 'Остаться',
                    onConfirm: () {
                      SnackBarManager.showWarning('Изменения не сохранены');
                    },
                  );
                },
                child: const Text('Подтверждение выхода'),
              ),
            ]),

            // Условные сообщения
            _buildSection('Условные сообщения', [
              ElevatedButton(
                onPressed: () {
                  SnackBarManagerExtensions.showConditional(
                    'Ожидание подключения к интернету...',
                    SnackBarType.warning,
                    hideCondition: () {
                      // Симуляция проверки подключения
                      return Random().nextBool();
                    },
                    checkInterval: const Duration(seconds: 2),
                  );
                },
                child: const Text('Проверка интернета'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  SnackBarManagerExtensions.showConditional(
                    'Ожидание ответа сервера...',
                    SnackBarType.info,
                    hideCondition: () => _isDownloading == false,
                    checkInterval: const Duration(milliseconds: 500),
                  );
                },
                child: const Text('Ожидание сервера'),
              ),
            ]),

            // Сообщения с счетчиком
            _buildSection('Сообщения с обратным отсчетом', [
              ElevatedButton(
                onPressed: () {
                  SnackBarManagerExtensions.showWithCountdown(
                    'Автосохранение через',
                    SnackBarType.info,
                    countdownDuration: const Duration(seconds: 5),
                    onTimeout: () {
                      SnackBarManager.showSuccess(
                        'Данные автоматически сохранены',
                      );
                    },
                  );
                },
                child: const Text('Автосохранение'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  SnackBarManagerExtensions.showWithCountdown(
                    'Сессия истекает через',
                    SnackBarType.warning,
                    countdownDuration: const Duration(seconds: 10),
                    onTimeout: () {
                      SnackBarManager.showError('Сессия истекла');
                    },
                  );
                },
                child: const Text('Истечение сессии'),
              ),
            ]),

            // Группа сообщений
            _buildSection('Группы сообщений', [
              ElevatedButton(
                onPressed: () {
                  SnackBarManagerExtensions.showGroup([
                    (
                      message: 'Инициализация...',
                      type: SnackBarType.info,
                      delay: null,
                    ),
                    (
                      message: 'Загрузка конфигурации...',
                      type: SnackBarType.info,
                      delay: null,
                    ),
                    (
                      message: 'Подключение к серверу...',
                      type: SnackBarType.warning,
                      delay: null,
                    ),
                    (
                      message: 'Готово к работе!',
                      type: SnackBarType.success,
                      delay: null,
                    ),
                  ]);
                },
                child: const Text('Процесс инициализации'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  SnackBarManagerExtensions.showGroup([
                    (
                      message: 'Создание резервной копии...',
                      type: SnackBarType.info,
                      delay: Duration(milliseconds: 500),
                    ),
                    (
                      message: 'Проверка целостности данных...',
                      type: SnackBarType.warning,
                      delay: Duration(seconds: 1),
                    ),
                    (
                      message: 'Резервная копия создана',
                      type: SnackBarType.success,
                      delay: Duration(milliseconds: 800),
                    ),
                  ]);
                },
                child: const Text('Создание бэкапа'),
              ),
            ]),

            // Шаблонные сообщения
            _buildSection('Предустановленные шаблоны', [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SnackBarTemplates.showNetworkError(
                          onRetry: () {
                            SnackBarTemplates.showNetworkSuccess();
                          },
                        );
                      },
                      child: const Text('Сетевая ошибка'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SnackBarTemplates.showLoginSuccess('Пользователь');
                      },
                      child: const Text('Успешный вход'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SnackBarTemplates.showFileSaved('document.pdf');
                      },
                      child: const Text('Файл сохранен'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SnackBarTemplates.showFileDeleted(
                          'old_file.txt',
                          onUndo: () {
                            SnackBarManager.showSuccess('Файл восстановлен');
                          },
                        );
                      },
                      child: const Text('Файл удален'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SnackBarTemplates.showCopiedToClipboard(
                          'Очень длинный текст который был скопирован в буфер обмена',
                        );
                      },
                      child: const Text('Скопировано'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SnackBarTemplates.showUpdateAvailable(
                          onUpdate: () {
                            SnackBarManager.showInfo('Обновление начато...');
                          },
                        );
                      },
                      child: const Text('Обновление'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SnackBarTemplates.showSyncInProgress();
                        Timer(const Duration(seconds: 3), () {
                          SnackBarTemplates.showSyncCompleted();
                        });
                      },
                      child: const Text('Синхронизация'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SnackBarTemplates.showValidationError('Email');
                      },
                      child: const Text('Ошибка валидации'),
                    ),
                  ),
                ],
              ),
            ]),
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
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  void _showFileDownloadProgress() {
    _progressController = StreamController<String>();

    SnackBarManagerExtensions.showProgress(
      _progressController!.stream,
      initialMessage: 'Начинается загрузка файла...',
    );

    // Симуляция загрузки файла
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final progress = timer.tick * 10;
      if (progress <= 100) {
        _progressController!.add('Загрузка файла: $progress%');
      } else {
        _progressController!.add('Загрузка завершена!');
        timer.cancel();
        _progressController!.close();

        Timer(const Duration(seconds: 1), () {
          SnackBarManagerExtensions.stopProgress();
          SnackBarManager.showSuccess('Файл успешно загружен');
        });
      }
    });
  }

  void _showDataProcessingProgress() {
    _progressController = StreamController<String>();

    SnackBarManagerExtensions.showProgress(
      _progressController!.stream,
      initialMessage: 'Подготовка к обработке данных...',
    );

    final steps = [
      'Чтение исходных данных...',
      'Валидация структуры...',
      'Применение фильтров...',
      'Группировка записей...',
      'Вычисление агрегатов...',
      'Сохранение результатов...',
      'Обработка завершена!',
    ];

    for (int i = 0; i < steps.length; i++) {
      Timer(Duration(milliseconds: 800 * i), () {
        _progressController!.add(steps[i]);

        if (i == steps.length - 1) {
          Timer(const Duration(seconds: 1), () {
            SnackBarManagerExtensions.stopProgress();
            SnackBarManager.showSuccess('Данные успешно обработаны');
            _progressController!.close();
          });
        }
      });
    }
  }
}
