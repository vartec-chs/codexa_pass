import 'package:flutter/material.dart';
import '../index.dart';

/// Расширения для удобного использования ScaffoldMessengerManager
extension ScaffoldMessengerExtensions on BuildContext {
  /// Быстрый доступ к менеджеру
  ScaffoldMessengerManager get messenger => ScaffoldMessengerManager.instance;

  /// Показать ошибку
  void showError(
    String message, {
    bool showCopyButton = true,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    messenger.showError(
      message,
      showCopyButton: showCopyButton,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Показать предупреждение
  void showWarning(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    messenger.showWarning(
      message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Показать информацию
  void showInfo(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    messenger.showInfo(
      message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Показать успех
  void showSuccess(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    messenger.showSuccess(
      message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}

/// Утилиты для создания стандартных действий
class MessengerActions {
  /// Создать кнопку "Повторить"
  static Widget retry(VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      label: const Text('Повторить'),
    );
  }

  /// Создать кнопку "Отменить"
  static Widget cancel(VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.cancel),
      label: const Text('Отменить'),
    );
  }

  /// Создать кнопку "Настройки"
  static Widget settings(VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.settings),
      label: const Text('Настройки'),
    );
  }

  /// Создать кнопку "Подробнее"
  static Widget details(VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.info_outline),
      label: const Text('Подробнее'),
    );
  }

  /// Создать кнопку "Закрыть" для баннера
  static Widget closeBanner() {
    return TextButton.icon(
      onPressed: () {
        ScaffoldMessengerManager.instance.hideCurrentBanner();
      },
      icon: const Icon(Icons.close),
      label: const Text('Закрыть'),
    );
  }
}

/// Предустановленные конфигурации для типичных сценариев
class MessengerPresets {
  /// Ошибка сети с возможностью повторить
  static void networkError({required String message, VoidCallback? onRetry}) {
    ScaffoldMessengerManager.instance.showError(
      message,
      showCopyButton: true,
      actionLabel: onRetry != null ? 'Повторить' : null,
      onActionPressed: onRetry,
    );
  }

  /// Валидационная ошибка
  static void validationError(String message) {
    ScaffoldMessengerManager.instance.showWarning(
      message,
      actionLabel: 'Исправить',
      onActionPressed: () {
        // Можно добавить логику для фокуса на поле с ошибкой
      },
    );
  }

  /// Успешное сохранение
  static void saveSuccess({String message = 'Данные успешно сохранены'}) {
    ScaffoldMessengerManager.instance.showSuccess(message);
  }

  /// Информация об обновлении
  static void updateAvailable({required VoidCallback onUpdate}) {
    ScaffoldMessengerManager.instance.showInfoBanner(
      'Доступна новая версия приложения',
      actions: [
        TextButton.icon(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentBanner();
            onUpdate();
          },
          icon: const Icon(Icons.download),
          label: const Text('Обновить'),
        ),
        MessengerActions.closeBanner(),
      ],
    );
  }

  /// Критическая ошибка системы
  static void systemError({
    required String message,
    String? errorCode,
    VoidCallback? onRestart,
  }) {
    final fullMessage = errorCode != null
        ? '$message\nКод ошибки: $errorCode'
        : message;

    ScaffoldMessengerManager.instance.showErrorBanner(
      fullMessage,
      actions: [
        if (onRestart != null)
          TextButton.icon(
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
              onRestart();
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('Перезапустить'),
          ),
        TextButton.icon(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentBanner();
            // Можно добавить логику отправки отчета об ошибке
          },
          icon: const Icon(Icons.bug_report),
          label: const Text('Сообщить'),
        ),
        MessengerActions.closeBanner(),
      ],
    );
  }

  /// Предупреждение о потере данных
  static void dataLossWarning({
    required VoidCallback onContinue,
    VoidCallback? onSave,
  }) {
    ScaffoldMessengerManager.instance.showWarningBanner(
      'Внимание! Несохраненные данные будут потеряны',
      actions: [
        if (onSave != null)
          TextButton.icon(
            onPressed: () {
              ScaffoldMessengerManager.instance.hideCurrentBanner();
              onSave();
            },
            icon: const Icon(Icons.save),
            label: const Text('Сохранить'),
          ),
        TextButton.icon(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentBanner();
            onContinue();
          },
          icon: const Icon(Icons.warning),
          label: const Text('Продолжить'),
        ),
        MessengerActions.closeBanner(),
      ],
    );
  }

  /// Offline режим
  static void offlineMode() {
    ScaffoldMessengerManager.instance.showWarningBanner(
      'Работа в автономном режиме. Некоторые функции недоступны',
      actions: [
        TextButton.icon(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentBanner();
            // Можно добавить логику проверки соединения
          },
          icon: const Icon(Icons.wifi),
          label: const Text('Проверить'),
        ),
        MessengerActions.closeBanner(),
      ],
    );
  }
}
