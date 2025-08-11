import 'package:flutter/material.dart';
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/index.dart';

/// Виджет для демонстрации возможностей ScaffoldMessengerManager
/// Показывает все типы уведомлений и их настройки
class MessengerDemoWidget extends StatefulWidget {
  const MessengerDemoWidget({super.key});

  @override
  State<MessengerDemoWidget> createState() => _MessengerDemoWidgetState();
}

class _MessengerDemoWidgetState extends State<MessengerDemoWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _showAdvanced = false;
  int _queueCounter = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, colorScheme),
            const SizedBox(height: 20),
            _buildBasicSection(),
            const SizedBox(height: 16),
            _buildBannerSection(),
            const SizedBox(height: 16),
            _buildAdvancedToggle(),
            if (_showAdvanced) ...[
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildAdvancedSection(),
              ),
            ],
            const SizedBox(height: 16),
            _buildControlSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.message,
            color: colorScheme.onPrimaryContainer,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messenger Demo',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                'Демонстрация ScaffoldMessengerManager',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _buildQueueCounter(),
      ],
    );
  }

  Widget _buildQueueCounter() {
    return StreamBuilder<int>(
      stream: Stream.periodic(
        const Duration(milliseconds: 500),
        (_) => ScaffoldMessengerManager.instance.queueLength,
      ),
      builder: (context, snapshot) {
        final queueLength = snapshot.data ?? 0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: queueLength > 0
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Очередь: $queueLength',
            style: TextStyle(
              color: queueLength > 0
                  ? Theme.of(context).colorScheme.onError
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBasicSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('SnackBar уведомления'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip(
              'Error',
              Icons.error_outline,
              Colors.red,
              () => context.showError(
                'Произошла критическая ошибка! Код: 500',
                showCopyButton: true,
                actionLabel: 'Повторить',
                onActionPressed: () => context.showInfo('Повторная попытка...'),
              ),
            ),
            _buildChip(
              'Warning',
              Icons.warning_amber_outlined,
              Colors.orange,
              () => context.showWarning(
                'Внимание! Проверьте введенные данные',
                actionLabel: 'Проверить',
                onActionPressed: () => context.showInfo('Проверка выполнена'),
              ),
            ),
            _buildChip(
              'Info',
              Icons.info_outline,
              Colors.blue,
              () => context.showInfo(
                'Обновление доступно в магазине приложений',
                actionLabel: 'Обновить',
                onActionPressed: () =>
                    context.showSuccess('Обновление начато...'),
              ),
            ),
            _buildChip(
              'Success',
              Icons.check_circle_outline,
              Colors.green,
              () => context.showSuccess('Операция выполнена успешно!'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBannerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('MaterialBanner уведомления'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip(
              'Error Banner',
              Icons.error_outline,
              Colors.red.shade700,
              () => ScaffoldMessengerManager.instance.showErrorBanner(
                'Критическая ошибка системы! Требуется немедленное внимание.',
              ),
            ),
            _buildChip(
              'Warning Banner',
              Icons.warning_amber_outlined,
              Colors.orange.shade700,
              () => ScaffoldMessengerManager.instance.showWarningBanner(
                'Предупреждение: обнаружена подозрительная активность',
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessengerManager.instance.hideCurrentBanner();
                      context.showInfo('Проверка безопасности...');
                    },
                    child: const Text('Проверить'),
                  ),
                  MessengerActions.closeBanner(),
                ],
              ),
            ),
            _buildChip(
              'Update Banner',
              Icons.system_update,
              Colors.blue.shade700,
              () => MessengerPresets.updateAvailable(
                onUpdate: () => context.showSuccess('Начинается обновление...'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedToggle() {
    return InkWell(
      onTap: () {
        setState(() {
          _showAdvanced = !_showAdvanced;
        });
        if (_showAdvanced) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(
              _showAdvanced ? Icons.expand_less : Icons.expand_more,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Расширенные возможности',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Готовые пресеты'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip(
              'Network Error',
              Icons.wifi_off,
              Colors.red.shade600,
              () => MessengerPresets.networkError(
                message: 'Не удалось подключиться к серверу',
                onRetry: () => context.showInfo('Повторная попытка...'),
              ),
            ),
            _buildChip(
              'Data Loss Warning',
              Icons.warning,
              Colors.amber.shade700,
              () => MessengerPresets.dataLossWarning(
                onContinue: () => context.showInfo('Данные потеряны'),
                onSave: () => context.showSuccess('Данные сохранены'),
              ),
            ),
            _buildChip(
              'System Error',
              Icons.bug_report,
              Colors.red.shade800,
              () => MessengerPresets.systemError(
                message: 'Критическая ошибка системы',
                errorCode: 'SYS_ERR_001',
                onRestart: () => context.showInfo('Перезапуск системы...'),
              ),
            ),
            _buildChip(
              'Offline Mode',
              Icons.cloud_off,
              Colors.grey.shade600,
              () => MessengerPresets.offlineMode(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Тестирование очереди'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _showQueueTest,
                icon: const Icon(Icons.queue),
                label: const Text('Тест очереди (5 сообщений)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Управление'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessengerManager.instance.hideCurrentSnackBar();
                  ScaffoldMessengerManager.instance.hideCurrentBanner();
                },
                icon: const Icon(Icons.close),
                label: const Text('Скрыть текущие'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessengerManager.instance.clearSnackBarQueue();
                  context.showInfo('Очередь очищена');
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('Очистить очередь'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildChip(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ActionChip(
      onPressed: onPressed,
      avatar: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  void _showQueueTest() {
    _queueCounter++;
    final messenger = ScaffoldMessengerManager.instance;

    // Добавляем 5 разных сообщений в очередь
    messenger.showError('Ошибка #$_queueCounter-1');
    messenger.showWarning('Предупреждение #$_queueCounter-2');
    messenger.showInfo('Информация #$_queueCounter-3');
    messenger.showSuccess('Успех #$_queueCounter-4');
    messenger.showError('Ошибка #$_queueCounter-5');

    // Показываем информацию о количестве в очереди
    Future.delayed(const Duration(milliseconds: 100), () {
      messenger.showInfo('В очереди: ${messenger.queueLength} сообщений');
    });
  }
}

/// Упрощенная версия виджета для быстрого добавления в любой экран
class QuickMessengerDemo extends StatelessWidget {
  const QuickMessengerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quick Messenger Test',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => context.showError('Тест ошибки'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Error'),
              ),
              ElevatedButton(
                onPressed: () => context.showWarning('Тест предупреждения'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Warning'),
              ),
              ElevatedButton(
                onPressed: () => context.showInfo('Тест информации'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Info'),
              ),
              ElevatedButton(
                onPressed: () => context.showSuccess('Тест успеха'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Success'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
