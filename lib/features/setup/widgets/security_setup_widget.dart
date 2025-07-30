import 'package:flutter/material.dart';
import '../../../app/logger/app_logger.dart';

/// Пример дополнительного виджета настройки (закомментирован для будущего использования)
///
/// Чтобы добавить этот экран:
/// 1. Добавьте новый шаг в enum SetupStep в setup_control.dart
/// 2. Обновите totalSteps в SetupState
/// 3. Добавьте обработку нового шага в методы контроллера
/// 4. Добавьте новый виджет в PageView в setup.dart
/// 5. Обновите индикатор прогресса
class SecuritySetupWidget extends StatefulWidget {
  const SecuritySetupWidget({super.key});

  @override
  State<SecuritySetupWidget> createState() => _SecuritySetupWidgetState();
}

class _SecuritySetupWidgetState extends State<SecuritySetupWidget> {
  bool _enableBiometric = true;
  bool _enableAutoLock = true;
  int _autoLockMinutes = 5;

  @override
  Widget build(BuildContext context) {
    logDebug('Building SecuritySetupWidget');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Заголовок
          _buildTitle(),
          const SizedBox(height: 16),

          // Описание
          _buildDescription(),
          const SizedBox(height: 40),

          // Настройки безопасности
          _buildSecurityOptions(),
          const SizedBox(height: 32),

          // Информация о безопасности
          _buildSecurityInfo(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Настройки безопасности',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Настройте параметры безопасности для защиты ваших данных',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
    );
  }

  Widget _buildSecurityOptions() {
    return Column(
      children: [
        // Биометрическая аутентификация
        _buildSecurityOption(
          icon: Icons.fingerprint,
          title: 'Биометрическая разблокировка',
          description: 'Использовать отпечаток пальца или Face ID',
          value: _enableBiometric,
          onChanged: (value) {
            setState(() {
              _enableBiometric = value;
            });
          },
        ),

        const SizedBox(height: 20),

        // Автоблокировка
        _buildSecurityOption(
          icon: Icons.lock_clock,
          title: 'Автоматическая блокировка',
          description: 'Блокировать приложение при неактивности',
          value: _enableAutoLock,
          onChanged: (value) {
            setState(() {
              _enableAutoLock = value;
            });
          },
        ),

        // Время автоблокировки
        if (_enableAutoLock) ...[
          const SizedBox(height: 16),
          _buildAutoLockTime(),
        ],
      ],
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue.shade600, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildAutoLockTime() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Время до автоблокировки: $_autoLockMinutes мин',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Slider(
            value: _autoLockMinutes.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                _autoLockMinutes = value.round();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.security, color: Colors.amber.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Безопасность',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Эти настройки можно изменить позже в разделе безопасности приложения.',
                  style: TextStyle(fontSize: 13, color: Colors.amber.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
