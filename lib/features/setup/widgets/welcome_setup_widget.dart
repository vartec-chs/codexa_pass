import 'package:flutter/material.dart';
import '../../../app/logger/app_logger.dart';

class WelcomeSetupWidget extends StatelessWidget {
  const WelcomeSetupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    logDebug('Building WelcomeSetupWidget');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Иконка приложения
        _buildAppIcon(),
        const SizedBox(height: 32),

        // Заголовок
        _buildTitle(theme),
        const SizedBox(height: 16),

        // Описание
        _buildDescription(theme),
        const SizedBox(height: 40),

        // Список возможностей
        _buildFeaturesList(theme),
        const SizedBox(height: 32),

        // Приветственное сообщение
        _buildWelcomeMessage(theme),
      ],
    );
  }

  Widget _buildAppIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade600,
            Colors.indigo.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(Icons.security_rounded, size: 64, color: Colors.white),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      'Добро пожаловать в\nCodeXA Pass',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: theme.brightness == Brightness.dark
            ? Colors.grey[300]
            : Colors.grey[800],
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      'Безопасный и удобный менеджер паролей для защиты ваших данных',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: theme.brightness == Brightness.dark
            ? Colors.grey[300]
            : Colors.grey[600],
        height: 1.4,
      ),
    );
  }

  Widget _buildFeaturesList(ThemeData theme) {
    final features = [
      {
        'icon': Icons.lock_outline,
        'title': 'Надёжное шифрование',
        'description': 'AES-256 шифрование для максимальной безопасности',
      },
      {
        'icon': Icons.sync,
        'title': 'Синхронизация',
        'description': 'Доступ к паролям на всех ваших устройствах',
      },
      // {
      //   'icon': Icons.fingerprint,
      //   'title': 'Биометрия',
      //   'description': 'Быстрый доступ по отпечатку пальца',
      // },
    ];

    return Column(
      children: features
          .map(
            (feature) => _buildFeatureItem(
              feature['icon'] as IconData,
              feature['title'] as String,
              feature['description'] as String,
              theme,
            ),
          )
          .toList(),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String description,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
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
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.brightness == Brightness.dark
                ? Colors.blue.shade900
                : Colors.blue.shade50,
            theme.brightness == Brightness.dark
                ? Colors.blue.shade800
                : Colors.indigo.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.blue.shade700
              : Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: theme.brightness == Brightness.dark
                ? Colors.blue.shade300
                : Colors.blue.shade600,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Начало работы',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.brightness == Brightness.dark
                        ? Colors.blue.shade100
                        : Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Настройте приложение всего за несколько простых шагов',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.brightness == Brightness.dark
                        ? Colors.blue.shade400
                        : Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
