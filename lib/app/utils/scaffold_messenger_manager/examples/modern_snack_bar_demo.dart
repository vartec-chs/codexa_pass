import 'package:flutter/material.dart';
import '../scaffold_messenger_manager.dart';
import '../models/snack_bar_animation_config.dart';

class ModernSnackBarDemo extends StatefulWidget {
  const ModernSnackBarDemo({super.key});

  @override
  State<ModernSnackBarDemo> createState() => _ModernSnackBarDemoState();
}

class _ModernSnackBarDemoState extends State<ModernSnackBarDemo> {
  bool _animationsEnabled = true;
  SnackBarAnimationConfig _currentAnimationConfig =
      const SnackBarAnimationConfig();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Современные SnackBar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAnimationControls(),
            const SizedBox(height: 24),
            _buildSnackBarButtons(),
            const SizedBox(height: 24),
            _buildPresetButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationControls() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Настройки анимаций',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Включить анимации'),
              subtitle: const Text('Глобальное включение/отключение анимаций'),
              value: _animationsEnabled,
              onChanged: (value) {
                setState(() {
                  _animationsEnabled = value;
                  if (value) {
                    ScaffoldMessengerManager.instance.enableAnimations();
                  } else {
                    ScaffoldMessengerManager.instance.disableAnimations();
                  }
                });
              },
            ),
            if (_animationsEnabled) ...[
              const Divider(),
              Text(
                'Предустановки анимаций',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildAnimationPresetChip(
                    'По умолчанию',
                    const SnackBarAnimationConfig(),
                  ),
                  _buildAnimationPresetChip(
                    'Быстрые',
                    SnackBarAnimationConfig.fast,
                  ),
                  _buildAnimationPresetChip(
                    'Медленные',
                    SnackBarAnimationConfig.slow,
                  ),
                  _buildAnimationPresetChip(
                    'Bounce',
                    SnackBarAnimationConfig.bouncy,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationPresetChip(
    String label,
    SnackBarAnimationConfig config,
  ) {
    final isSelected = _currentAnimationConfig == config;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentAnimationConfig = config;
            ScaffoldMessengerManager.instance.setDefaultAnimationConfig(config);
          });
        }
      },
    );
  }

  Widget _buildSnackBarButtons() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Типы SnackBar',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSnackBarButton(
              'Ошибка',
              'Произошла критическая ошибка при выполнении операции!',
              () => ScaffoldMessengerManager.instance.showError(
                'Произошла критическая ошибка при выполнении операции! Пожалуйста, проверьте подключение к сети и попробуйте снова.',
                showCopyButton: true,
              ),
              Colors.red,
              Icons.error_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildSnackBarButton(
              'Предупреждение',
              'Внимание! Требуется ваше действие',
              () => ScaffoldMessengerManager.instance.showWarning(
                'Внимание! Некоторые функции могут быть недоступны в автономном режиме.',
                actionLabel: 'Подключиться',
                onActionPressed: () {},
              ),
              Colors.orange,
              Icons.warning_amber_outlined,
            ),
            const SizedBox(height: 12),
            _buildSnackBarButton(
              'Информация',
              'Полезная информация для пользователя',
              () => ScaffoldMessengerManager.instance.showInfo(
                'Новая версия приложения доступна для скачивания.',
                actionLabel: 'Обновить',
                onActionPressed: () {},
              ),
              Colors.blue,
              Icons.info_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildSnackBarButton(
              'Успех',
              'Операция выполнена успешно!',
              () => ScaffoldMessengerManager.instance.showSuccess(
                'Данные успешно сохранены!',
              ),
              Colors.green,
              Icons.check_circle_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnackBarButton(
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
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: const Icon(Icons.touch_app_outlined),
        onTap: onPressed,
      ),
    );
  }

  Widget _buildPresetButtons() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Специальные эффекты',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildEffectButton(
              'Blur эффект',
              'SnackBar с размытием фона',
              () => ScaffoldMessengerManager.instance.showInfo(
                'Этот SnackBar использует blur эффект для создания современного вида!',
                enableBlur: true,
              ),
              Icons.blur_on_rounded,
              Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildEffectButton(
              'Кастомная анимация',
              'SnackBar с уникальной анимацией',
              () => ScaffoldMessengerManager.instance.showSuccess(
                'Кастомная анимация с bounce эффектом!',
                animationConfig: const SnackBarAnimationConfig(
                  entryDuration: Duration(milliseconds: 800),
                  entryCurve: Curves.elasticOut,
                  bounceAnimation: true,
                  slideDirection: SlideDirection.top,
                ),
              ),
              Icons.animation_rounded,
              Colors.indigo,
            ),
            const SizedBox(height: 12),
            _buildEffectButton(
              'Отключить анимации',
              'SnackBar без анимации',
              () => ScaffoldMessengerManager.instance.showWarning(
                'Этот SnackBar появляется мгновенно без анимаций!',
                animationConfig: SnackBarAnimationConfig.disabled,
              ),
              Icons.flash_off_rounded,
              Colors.brown,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEffectButton(
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
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: Icon(Icons.play_arrow_rounded, color: color),
        onTap: onPressed,
      ),
    );
  }
}
