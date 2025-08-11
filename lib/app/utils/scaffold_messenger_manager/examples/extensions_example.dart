import 'package:flutter/material.dart';
import '../index.dart';

class MessengerExtensionsExample extends StatelessWidget {
  const MessengerExtensionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extensions & Presets Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection('Context Extensions', [
              _buildButton(
                'Context Error',
                () => context.showError('Ошибка через контекст!'),
                Colors.red,
              ),
              _buildButton(
                'Context Warning',
                () => context.showWarning('Предупреждение через контекст'),
                Colors.orange,
              ),
              _buildButton(
                'Context Info',
                () => context.showInfo('Информация через контекст'),
                Colors.blue,
              ),
              _buildButton(
                'Context Success',
                () => context.showSuccess('Успех через контекст'),
                Colors.green,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection('Messenger Presets', [
              _buildButton(
                'Network Error',
                () => MessengerPresets.networkError(
                  message: 'Не удалось подключиться к серверу',
                  onRetry: () => context.showInfo('Повторная попытка...'),
                ),
                Colors.red,
              ),
              _buildButton(
                'Validation Error',
                () => MessengerPresets.validationError(
                  'Проверьте правильность введенных данных',
                ),
                Colors.orange,
              ),
              _buildButton(
                'Save Success',
                () => MessengerPresets.saveSuccess(),
                Colors.green,
              ),
              _buildButton(
                'Update Available',
                () => MessengerPresets.updateAvailable(
                  onUpdate: () =>
                      context.showSuccess('Начинается обновление...'),
                ),
                Colors.blue,
              ),
              _buildButton(
                'System Error',
                () => MessengerPresets.systemError(
                  message: 'Критическая ошибка системы',
                  errorCode: 'SYS_ERR_001',
                  onRestart: () => context.showInfo('Перезапуск системы...'),
                ),
                Colors.red.shade800,
              ),
              _buildButton(
                'Data Loss Warning',
                () => MessengerPresets.dataLossWarning(
                  onContinue: () => context.showInfo('Данные потеряны'),
                  onSave: () => context.showSuccess('Данные сохранены'),
                ),
                Colors.amber,
              ),
              _buildButton(
                'Offline Mode',
                () => MessengerPresets.offlineMode(),
                Colors.grey,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection('Custom Actions Demo', [
              _buildButton(
                'Custom Actions Banner',
                () => _showCustomActionsBanner(context),
                Colors.purple,
              ),
              _buildButton(
                'Complex Workflow',
                () => _showComplexWorkflow(context),
                Colors.indigo,
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

  void _showCustomActionsBanner(BuildContext context) {
    ScaffoldMessengerManager.instance.showBanner(
      BannerData(
        message: 'Демонстрация кастомных действий',
        type: BannerType.info,
        actions: [
          MessengerActions.retry(() {
            context.showInfo('Повторная попытка выполнена');
            ScaffoldMessengerManager.instance.hideCurrentBanner();
          }),
          MessengerActions.settings(() {
            context.showInfo('Открытие настроек...');
            ScaffoldMessengerManager.instance.hideCurrentBanner();
          }),
          MessengerActions.details(() {
            context.showInfo('Показ подробной информации');
            ScaffoldMessengerManager.instance.hideCurrentBanner();
          }),
          MessengerActions.closeBanner(),
        ],
      ),
    );
  }

  void _showComplexWorkflow(BuildContext context) {
    // Симуляция сложного рабочего процесса

    // 1. Показать информацию о начале процесса
    context.showInfo('Начинается обработка данных...');

    // 2. Через 2 секунды показать предупреждение
    Future.delayed(const Duration(seconds: 2), () {
      MessengerPresets.dataLossWarning(
        onContinue: () {
          // 3. Продолжить обработку
          context.showInfo('Продолжение обработки...');

          // 4. Через 3 секунды показать ошибку сети
          Future.delayed(const Duration(seconds: 3), () {
            MessengerPresets.networkError(
              message: 'Сбой соединения во время обработки',
              onRetry: () {
                // 5. При повторе показать успех
                context.showSuccess('Обработка завершена успешно!');
              },
            );
          });
        },
        onSave: () {
          // Альтернативный путь - сохранить и завершить
          MessengerPresets.saveSuccess(
            message: 'Промежуточные данные сохранены',
          );
        },
      );
    });
  }
}
