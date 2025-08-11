import 'package:flutter/material.dart';
import '../scaffold_messenger_manager.dart';
import '../models/banner_data.dart';

class ModernBannerDemo extends StatefulWidget {
  const ModernBannerDemo({super.key});

  @override
  State<ModernBannerDemo> createState() => _ModernBannerDemoState();
}

class _ModernBannerDemoState extends State<ModernBannerDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Современные MaterialBanner'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_fullscreen),
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
            },
            tooltip: 'Скрыть текущий баннер',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildBannerTypeButtons(),
            const SizedBox(height: 24),
            _buildAdvancedExamples(),
            const SizedBox(height: 24),
            _buildCustomActionsExamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'MaterialBanner Demo',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'MaterialBanner используется для важных уведомлений, '
              'которые требуют внимания пользователя. Они отображаются '
              'в верхней части экрана и остаются видимыми до тех пор, '
              'пока пользователь не выполнит действие.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerTypeButtons() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Типы MaterialBanner',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBannerButton(
              'Ошибка',
              'Критическая ошибка требует немедленного внимания',
              () => ScaffoldMessengerManager.instance.showErrorBanner(
                'Критическая ошибка: Не удалось подключиться к серверу. '
                'Проверьте подключение к интернету и попробуйте снова.',
              ),
              Colors.red,
              Icons.error_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildBannerButton(
              'Предупреждение',
              'Важная информация о состоянии системы',
              () => ScaffoldMessengerManager.instance.showWarningBanner(
                'Внимание: Ваша подписка истекает через 3 дня. '
                'Продлите подписку, чтобы продолжить пользоваться всеми функциями.',
              ),
              Colors.orange,
              Icons.warning_amber_outlined,
            ),
            const SizedBox(height: 12),
            _buildBannerButton(
              'Информация',
              'Полезная информация для пользователя',
              () => ScaffoldMessengerManager.instance.showInfoBanner(
                'Доступна новая версия приложения с улучшениями производительности '
                'и новыми функциями. Рекомендуем обновиться.',
              ),
              Colors.blue,
              Icons.info_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildBannerButton(
              'Успех',
              'Подтверждение успешного выполнения операции',
              () => ScaffoldMessengerManager.instance.showSuccessBanner(
                'Успех: Данные успешно синхронизированы с облаком. '
                'Все изменения сохранены и доступны на всех устройствах.',
              ),
              Colors.green,
              Icons.check_circle_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerButton(
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
        gradient: LinearGradient(
          colors: [color.withOpacity(0.05), color.withOpacity(0.02)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: Icon(Icons.touch_app_outlined, color: color),
        onTap: onPressed,
      ),
    );
  }

  Widget _buildAdvancedExamples() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Продвинутые примеры',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAdvancedButton(
              'Баннер с принудительными действиями снизу',
              'Действия размещаются под текстом',
              () => ScaffoldMessengerManager.instance.showWarningBanner(
                'Это длинное сообщение с принудительным размещением действий снизу. '
                'Это полезно когда текст длинный и действия не помещаются справа.',
                forceActionsBelow: true,
              ),
              Icons.vertical_align_bottom_rounded,
              Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildAdvancedButton(
              'Баннер без иконки',
              'Чистый дизайн без leading иконки',
              () => ScaffoldMessengerManager.instance.showBanner(
                BannerData(
                  message:
                      'Это баннер без иконки для минималистичного дизайна.',
                  type: BannerType.info,
                  leading: null, // Убираем иконку
                ),
              ),
              Icons.crop_free_rounded,
              Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedButton(
    String title,
    String subtitle,
    VoidCallback onPressed,
    IconData icon,
    Color color,
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
        trailing: const Icon(Icons.play_arrow_rounded),
        onTap: onPressed,
      ),
    );
  }

  Widget _buildCustomActionsExamples() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Кастомные действия',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCustomActionButton(
              'Баннер с кастомными действиями',
              'Несколько действий для взаимодействия',
              () => _showCustomActionBanner(),
              Icons.touch_app_rounded,
              Colors.teal,
            ),
            const SizedBox(height: 12),
            _buildCustomActionButton(
              'Баннер обновления',
              'Практический пример с обновлением',
              () => _showUpdateBanner(),
              Icons.update_rounded,
              Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomActionButton(
    String title,
    String subtitle,
    VoidCallback onPressed,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: color),
        onTap: onPressed,
      ),
    );
  }

  void _showCustomActionBanner() {
    ScaffoldMessengerManager.instance.showBanner(
      BannerData(
        message:
            'Найдены важные обновления безопасности. Рекомендуем установить их сейчас.',
        type: BannerType.warning,
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
              ScaffoldMessengerManager.instance.showSuccess(
                'Обновления запланированы!',
              );
            },
            icon: const Icon(Icons.schedule_rounded),
            label: const Text('Позже'),
          ),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
              ScaffoldMessengerManager.instance.showInfo(
                'Начинается установка обновлений...',
              );
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Обновить'),
          ),
        ],
      ),
    );
  }

  void _showUpdateBanner() {
    ScaffoldMessengerManager.instance.showBanner(
      BannerData(
        message:
            'Доступна новая версия 2.1.0 с улучшениями производительности.',
        type: BannerType.info,
        forceActionsBelow: true,
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
            },
            icon: const Icon(Icons.close_rounded),
            label: const Text('Пропустить'),
          ),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
              ScaffoldMessengerManager.instance.showInfo(
                'Открываем список изменений...',
              );
            },
            icon: const Icon(Icons.list_rounded),
            label: const Text('Что нового?'),
          ),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
              ScaffoldMessengerManager.instance.showSuccess(
                'Обновление начато!',
              );
            },
            icon: const Icon(Icons.update_rounded),
            label: const Text('Обновить сейчас'),
          ),
        ],
      ),
    );
  }
}
