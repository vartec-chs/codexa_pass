import 'package:codexa_pass/app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/logger/app_logger.dart';
import '../setup_control.dart';

class ThemeSetupWidget extends ConsumerWidget {
  const ThemeSetupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logDebug('Building ThemeSetupWidget');
    final setupState = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Заголовок
        _buildTitle(theme),
        const SizedBox(height: 16),

        // Описание
        _buildDescription(theme),
        const SizedBox(height: 40),

        // Варианты тем
        _buildThemeOptions(
          context,
          setupState.selectedTheme,
          controller,
          theme,
        ),
        const SizedBox(height: 32),

        // Превью темы
        _buildThemePreview(setupState.selectedTheme, theme),
        const SizedBox(height: 24),

        // Дополнительная информация
        _buildAdditionalInfo(theme),
      ],
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      'Выбор темы оформления',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26,
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
      'Выберите тему, которая вам больше нравится.\nВы сможете изменить её позже в настройках.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: theme.brightness == Brightness.dark
            ? Colors.grey[400]
            : Colors.grey[600],
        height: 1.4,
      ),
    );
  }

  Widget _buildThemeOptions(
    BuildContext context,
    ThemeMode selectedTheme,
    SetupController controller,
    ThemeData theme,
  ) {
    final themes = [
      {
        'mode': ThemeMode.light,
        'name': 'Светлая тема',
        'description': 'Классический светлый интерфейс',
        'icon': Icons.light_mode,
        'colors': [Colors.white, Colors.grey[100]!],
        'textColor': Colors.black87,
      },
      {
        'mode': ThemeMode.dark,
        'name': 'Тёмная тема',
        'description': 'Современный тёмный интерфейс',
        'icon': Icons.dark_mode,
        'colors': [Colors.grey[900]!, Colors.grey[800]!],
        'textColor': Colors.white,
      },
      {
        'mode': ThemeMode.system,
        'name': 'Системная тема',
        'description': 'Следует настройкам устройства',
        'icon': Icons.brightness_auto,
        'colors': [Colors.blue[100]!, Colors.blue[50]!],
        'textColor': Colors.blue[800]!,
      },
    ];

    return Column(
      children: themes
          .map(
            (themeOption) => _buildThemeOption(
              context,
              themeOption['mode'] as ThemeMode,
              themeOption['name'] as String,
              themeOption['description'] as String,
              themeOption['icon'] as IconData,
              themeOption['colors'] as List<Color>,
              themeOption['textColor'] as Color,
              selectedTheme,
              controller,
              theme,
            ),
          )
          .toList(),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeMode mode,
    String name,
    String description,
    IconData icon,
    List<Color> colors,
    Color textColor,
    ThemeMode selectedTheme,
    SetupController controller,
    ThemeData currentTheme,
  ) {
    final isSelected = selectedTheme == mode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: isSelected ? 8 : 2,
        borderRadius: BorderRadius.circular(16),
        color: currentTheme.cardColor,
        child: InkWell(
          onTap: () async {
            logDebug('Theme option selected: $mode');
            await controller.setTheme(mode);
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? currentTheme.primaryColor
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: currentTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Иконка
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? currentTheme.primaryColor.withOpacity(0.1)
                        : currentTheme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? currentTheme.primaryColor
                        : textColor.withOpacity(0.7),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Текст
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Индикатор выбора
                AnimatedScale(
                  scale: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemePreview(ThemeMode selectedTheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.grey[600]!
              : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.preview,
                color: theme.brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Выбранная тема: ${_getThemeName(selectedTheme)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getThemeDescription(selectedTheme),
            style: TextStyle(
              fontSize: 14,
              color: theme.brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.blue.shade900.withOpacity(0.3)
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.blue.shade700
              : Colors.blue.shade100,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: theme.brightness == Brightness.dark
                ? Colors.blue.shade300
                : Colors.blue.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Совет',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.brightness == Brightness.dark
                        ? Colors.blue.shade100
                        : Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Системная тема автоматически переключается между светлой и тёмной в зависимости от настроек вашего устройства.',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.brightness == Brightness.dark
                        ? Colors.blue.shade400
                        : Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeName(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return 'Светлая';
      case ThemeMode.dark:
        return 'Тёмная';
      case ThemeMode.system:
        return 'Системная';
    }
  }

  String _getThemeDescription(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return 'Интерфейс с светлым фоном и тёмным текстом. Идеально для работы в светлых помещениях.';
      case ThemeMode.dark:
        return 'Интерфейс с тёмным фоном и светлым текстом. Удобно для работы в тёмное время суток.';
      case ThemeMode.system:
        return 'Тема автоматически меняется в зависимости от настроек устройства.';
    }
  }
}
