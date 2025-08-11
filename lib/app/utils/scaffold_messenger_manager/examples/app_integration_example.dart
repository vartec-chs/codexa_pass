import 'package:flutter/material.dart';
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/index.dart';

/// Пример интеграции ScaffoldMessengerManager в приложение
/// Теперь это обычный экран, а не отдельное приложение
class AppExample extends StatefulWidget {
  const AppExample({super.key});

  @override
  State<AppExample> createState() => _AppExampleState();
}

class _AppExampleState extends State<AppExample> {
  @override
  void initState() {
    super.initState();

    // Пример показа приветственного сообщения
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.showSuccess('Добро пожаловать в примеры интеграции!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Примеры интеграции'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotificationExample(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Заголовок
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.integration_instructions,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Примеры интеграции',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Реальные сценарии использования ScaffoldMessengerManager',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Примеры использования в реальных сценариях
            Expanded(
              child: ListView(
                children: [
                  _buildExampleCard(
                    'Аутентификация',
                    'Примеры для экранов входа/регистрации',
                    () => _showAuthExamples(context),
                    Icons.login,
                  ),
                  const SizedBox(height: 12),
                  _buildExampleCard(
                    'Работа с данными',
                    'Примеры для операций с данными',
                    () => _showDataExamples(context),
                    Icons.data_usage,
                  ),
                  const SizedBox(height: 12),
                  _buildExampleCard(
                    'Сетевые операции',
                    'Примеры для API запросов',
                    () => _showNetworkExamples(context),
                    Icons.cloud,
                  ),
                  const SizedBox(height: 12),
                  _buildExampleCard(
                    'Системные уведомления',
                    'Примеры системных сообщений',
                    () => _showSystemExamples(context),
                    Icons.system_update,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQueueDemo(context),
        icon: const Icon(Icons.queue),
        label: Text(
          'Очередь (${ScaffoldMessengerManager.instance.queueLength})',
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    String title,
    String subtitle,
    VoidCallback onTap,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  // ==================== ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ ====================

  void _showNotificationExample(BuildContext context) {
    // Пример уведомления о новых сообщениях
    ScaffoldMessengerManager.instance.showInfoBanner(
      'У вас 3 новых уведомления',
      actions: [
        TextButton.icon(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentBanner();
            context.showInfo('Переход к уведомлениям...');
          },
          icon: const Icon(Icons.open_in_new),
          label: const Text('Открыть'),
        ),
        MessengerActions.closeBanner(),
      ],
    );
  }

  void _showAuthExamples(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _AuthExamples(),
    );
  }

  void _showDataExamples(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _DataExamples(),
    );
  }

  void _showNetworkExamples(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _NetworkExamples(),
    );
  }

  void _showSystemExamples(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SystemExamples(),
    );
  }

  void _showQueueDemo(BuildContext context) {
    // Демонстрация работы очереди
    for (int i = 1; i <= 5; i++) {
      switch (i % 4) {
        case 1:
          context.showError('Ошибка $i');
          break;
        case 2:
          context.showWarning('Предупреждение $i');
          break;
        case 3:
          context.showInfo('Информация $i');
          break;
        case 0:
          context.showSuccess('Успех $i');
          break;
      }
    }
  }
}

// ==================== ПРИМЕРЫ ДЛЯ РАЗНЫХ СЦЕНАРИЕВ ====================

class _AuthExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Примеры аутентификации',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildExampleButton(
            'Ошибка входа',
            () => MessengerPresets.validationError('Неверный логин или пароль'),
          ),
          _buildExampleButton(
            'Успешный вход',
            () => context.showSuccess('Добро пожаловать!'),
          ),
          _buildExampleButton(
            'Истечение сессии',
            () => ScaffoldMessengerManager.instance.showWarningBanner(
              'Ваша сессия истекла. Необходимо войти заново',
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessengerManager.instance.hideCurrentBanner();
                    context.showInfo('Переход к экрану входа...');
                  },
                  child: const Text('Войти'),
                ),
                MessengerActions.closeBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed, child: Text(text)),
      ),
    );
  }
}

class _DataExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Примеры работы с данными',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildExampleButton(
            'Сохранение данных',
            () => MessengerPresets.saveSuccess(
              message: 'Пароль успешно сохранен',
            ),
          ),
          _buildExampleButton(
            'Предупреждение о потере данных',
            () => MessengerPresets.dataLossWarning(
              onContinue: () => context.showInfo('Изменения отменены'),
              onSave: () => context.showSuccess('Изменения сохранены'),
            ),
          ),
          _buildExampleButton(
            'Ошибка валидации',
            () => context.showWarning(
              'Пароль должен содержать минимум 8 символов',
              actionLabel: 'Исправить',
              onActionPressed: () => context.showInfo('Фокус на поле пароля'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed, child: Text(text)),
      ),
    );
  }
}

class _NetworkExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Примеры сетевых операций',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildExampleButton(
            'Ошибка сети',
            () => MessengerPresets.networkError(
              message: 'Не удалось синхронизировать данные',
              onRetry: () => context.showInfo('Повторная синхронизация...'),
            ),
          ),
          _buildExampleButton(
            'Автономный режим',
            () => MessengerPresets.offlineMode(),
          ),
          _buildExampleButton(
            'Таймаут запроса',
            () => context.showError(
              'Превышено время ожидания ответа сервера',
              showCopyButton: true,
              actionLabel: 'Повторить',
              onActionPressed: () => context.showInfo('Повторная попытка...'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed, child: Text(text)),
      ),
    );
  }
}

class _SystemExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Системные уведомления',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildExampleButton(
            'Обновление приложения',
            () => MessengerPresets.updateAvailable(
              onUpdate: () => context.showInfo('Начинается обновление...'),
            ),
          ),
          _buildExampleButton(
            'Системная ошибка',
            () => MessengerPresets.systemError(
              message: 'Ошибка шифрования данных',
              errorCode: 'CRYPT_ERR_001',
              onRestart: () =>
                  context.showInfo('Перезапуск модуля шифрования...'),
            ),
          ),
          _buildExampleButton(
            'Резервное копирование',
            () => ScaffoldMessengerManager.instance.showSuccessBanner(
              'Резервное копирование завершено успешно',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed, child: Text(text)),
      ),
    );
  }
}
