import 'package:flutter/material.dart';
import '../index.dart';

class ScaffoldMessengerExample extends StatelessWidget {
  const ScaffoldMessengerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ScaffoldMessenger Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection('SnackBar Examples', [
              _buildButton(
                'Error SnackBar',
                () => _showErrorSnackBar(),
                Colors.red,
              ),
              _buildButton(
                'Warning SnackBar',
                () => _showWarningSnackBar(),
                Colors.orange,
              ),
              _buildButton(
                'Info SnackBar',
                () => _showInfoSnackBar(),
                Colors.blue,
              ),
              _buildButton(
                'Success SnackBar',
                () => _showSuccessSnackBar(),
                Colors.green,
              ),
              _buildButton(
                'Custom SnackBar',
                () => _showCustomSnackBar(),
                Colors.purple,
              ),
              _buildButton(
                'Queue Test (5 messages)',
                () => _showQueueTest(),
                Colors.indigo,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection('MaterialBanner Examples', [
              _buildButton(
                'Error Banner',
                () => _showErrorBanner(),
                Colors.red,
              ),
              _buildButton(
                'Warning Banner',
                () => _showWarningBanner(),
                Colors.orange,
              ),
              _buildButton('Info Banner', () => _showInfoBanner(), Colors.blue),
              _buildButton(
                'Success Banner',
                () => _showSuccessBanner(),
                Colors.green,
              ),
              _buildButton(
                'Custom Banner',
                () => _showCustomBanner(),
                Colors.purple,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection('Control Actions', [
              _buildButton(
                'Hide Current SnackBar',
                () => ScaffoldMessengerManager.instance.hideCurrentSnackBar(),
                Colors.grey,
              ),
              _buildButton(
                'Hide Current Banner',
                () => ScaffoldMessengerManager.instance.hideCurrentBanner(),
                Colors.grey,
              ),
              _buildButton(
                'Clear Queue',
                () => ScaffoldMessengerManager.instance.clearSnackBarQueue(),
                Colors.red,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children.map(
          (child) =>
              Padding(padding: const EdgeInsets.only(bottom: 8), child: child),
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(text),
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessengerManager.instance.showError(
      'Произошла критическая ошибка! Код: 500',
      showCopyButton: true,
      actionLabel: 'Повторить',
      onActionPressed: () {
        ScaffoldMessengerManager.instance.showInfo('Повторная попытка...');
      },
    );
  }

  void _showWarningSnackBar() {
    ScaffoldMessengerManager.instance.showWarning(
      'Внимание! Проверьте введенные данные',
      actionLabel: 'Проверить',
      onActionPressed: () {
        ScaffoldMessengerManager.instance.showInfo('Проверка выполнена');
      },
    );
  }

  void _showInfoSnackBar() {
    ScaffoldMessengerManager.instance.showInfo(
      'Обновление доступно в магазине приложений',
      actionLabel: 'Обновить',
      onActionPressed: () {
        ScaffoldMessengerManager.instance.showSuccess(
          'Перенаправление в магазин...',
        );
      },
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessengerManager.instance.showSuccess('Данные успешно сохранены!');
  }

  void _showCustomSnackBar() {
    ScaffoldMessengerManager.instance.showSnackBar(
      SnackBarData(
        message: 'Кастомное сообщение с длительностью 10 секунд',
        type: SnackBarType.info,
        duration: const Duration(seconds: 10),
        showCopyButton: true,
        showCloseButton: true,
        actionLabel: 'Настройки',
        onActionPressed: () {
          ScaffoldMessengerManager.instance.showInfo('Открытие настроек...');
        },
        onCopyPressed: () {
          ScaffoldMessengerManager.instance.showSuccess(
            'Скопировано в буфер обмена',
          );
        },
      ),
    );
  }

  void _showQueueTest() {
    final messenger = ScaffoldMessengerManager.instance;

    messenger.showError('Ошибка 1');
    messenger.showWarning('Предупреждение 2');
    messenger.showInfo('Информация 3');
    messenger.showSuccess('Успех 4');
    messenger.showError('Ошибка 5');

    // Показать количество в очереди
    Future.delayed(const Duration(milliseconds: 100), () {
      messenger.showInfo('В очереди: ${messenger.queueLength} сообщений');
    });
  }

  void _showErrorBanner() {
    ScaffoldMessengerManager.instance.showErrorBanner(
      'Критическая ошибка системы! Требуется немедленное внимание.',
    );
  }

  void _showWarningBanner() {
    ScaffoldMessengerManager.instance.showWarningBanner(
      'Предупреждение: обнаружена подозрительная активность',
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentBanner();
            ScaffoldMessengerManager.instance.showInfo(
              'Проверка безопасности...',
            );
          },
          child: const Text('Проверить'),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentBanner();
          },
          child: const Text('Закрыть'),
        ),
      ],
    );
  }

  void _showInfoBanner() {
    ScaffoldMessengerManager.instance.showInfoBanner(
      'Новая версия приложения доступна для загрузки',
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentBanner();
            ScaffoldMessengerManager.instance.showSuccess(
              'Начинается обновление...',
            );
          },
          child: const Text('Обновить'),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentBanner();
          },
          child: const Text('Позже'),
        ),
      ],
    );
  }

  void _showSuccessBanner() {
    ScaffoldMessengerManager.instance.showSuccessBanner(
      'Все системы работают нормально. Последняя проверка: сейчас',
    );
  }

  void _showCustomBanner() {
    ScaffoldMessengerManager.instance.showBanner(
      BannerData(
        message: 'Кастомный баннер с расширенными настройками',
        type: BannerType.warning,
        forceActionsBelow: true,
        backgroundColor: Colors.deepPurple.shade100,
        elevation: 8,
        leading: const Icon(Icons.star, color: Colors.deepPurple),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
              ScaffoldMessengerManager.instance.showSuccess(
                'Действие выполнено!',
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Принять'),
          ),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
            },
            icon: const Icon(Icons.close),
            label: const Text('Отклонить'),
          ),
        ],
      ),
    );
  }
}
