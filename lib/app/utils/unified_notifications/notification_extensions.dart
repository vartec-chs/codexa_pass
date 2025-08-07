import 'dart:async';
import 'package:flutter/material.dart';
import 'notification_config.dart';
import 'notification_manager.dart';

/// Расширения для UnifiedNotificationManager с дополнительными возможностями
extension UnifiedNotificationManagerExtensions on UnifiedNotificationManager {
  /// Показать прогресс-сообщение с автообновлением
  static StreamSubscription<String>? _progressSubscription;

  static void showProgress(
    Stream<String> progressStream, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    String? initialMessage,
    Duration updateInterval = const Duration(milliseconds: 500),
  }) {
    _progressSubscription?.cancel();

    if (initialMessage != null) {
      UnifiedNotificationManager.showInfo(
        initialMessage,
        context: context,
        position: position,
      );
    }

    _progressSubscription = progressStream.distinct().listen((message) {
      if (position == NotificationPosition.top) {
        UnifiedNotificationManager.hideOverlay();
      } else {
        UnifiedNotificationManager.hideSnackBar();
      }

      UnifiedNotificationManager.showInfo(
        message,
        context: context,
        position: position,
        duration: const Duration(seconds: 1),
      );
    });
  }

  /// Остановить показ прогресса
  static void stopProgress() {
    _progressSubscription?.cancel();
    _progressSubscription = null;
  }

  /// Показать сообщение с подтверждением
  static void showConfirmation(
    String message, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmLabel = 'Да',
    String cancelLabel = 'Отмена',
    Duration duration = const Duration(seconds: 10),
  }) {
    UnifiedNotificationManager.showWarning(
      message,
      context: context,
      position: position,
      duration: duration,
      actionLabel: confirmLabel,
      onAction: () {
        onConfirm();
        if (onCancel != null) {
          Timer(const Duration(seconds: 1), () {
            UnifiedNotificationManager.showInfo(
              'Отменить?',
              context: context,
              position: position,
              duration: const Duration(seconds: 3),
            );
          });
        }
      },
    );
  }

  /// Показать сообщение с автоскрытием при условии
  static Timer? _conditionalTimer;

  static void showConditional(
    String message,
    NotificationType type, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    required bool Function() hideCondition,
    Duration checkInterval = const Duration(milliseconds: 500),
    Duration maxDuration = const Duration(seconds: 30),
  }) {
    switch (type) {
      case NotificationType.info:
        UnifiedNotificationManager.showInfo(
          message,
          context: context,
          position: position,
          duration: maxDuration,
        );
        break;
      case NotificationType.warning:
        UnifiedNotificationManager.showWarning(
          message,
          context: context,
          position: position,
          duration: maxDuration,
        );
        break;
      case NotificationType.error:
        UnifiedNotificationManager.showError(
          message,
          context: context,
          position: position,
          duration: maxDuration,
        );
        break;
      case NotificationType.success:
        UnifiedNotificationManager.showSuccess(
          message,
          context: context,
          position: position,
          duration: maxDuration,
        );
        break;
    }

    _conditionalTimer?.cancel();
    _conditionalTimer = Timer.periodic(checkInterval, (timer) {
      if (hideCondition()) {
        if (position == NotificationPosition.top) {
          UnifiedNotificationManager.hideOverlay();
        } else {
          UnifiedNotificationManager.hideSnackBar();
        }
        timer.cancel();
      }
    });
  }

  /// Показать сообщение с счетчиком времени
  static void showWithCountdown(
    String baseMessage,
    NotificationType type, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration countdownDuration = const Duration(seconds: 10),
    VoidCallback? onTimeout,
  }) {
    int remainingSeconds = countdownDuration.inSeconds;

    void updateMessage() {
      final message = '$baseMessage ($remainingSeconds сек.)';

      if (position == NotificationPosition.top) {
        UnifiedNotificationManager.hideOverlay();
      } else {
        UnifiedNotificationManager.hideSnackBar();
      }

      switch (type) {
        case NotificationType.info:
          UnifiedNotificationManager.showInfo(
            message,
            context: context,
            position: position,
            duration: const Duration(seconds: 1),
          );
          break;
        case NotificationType.warning:
          UnifiedNotificationManager.showWarning(
            message,
            context: context,
            position: position,
            duration: const Duration(seconds: 1),
          );
          break;
        case NotificationType.error:
          UnifiedNotificationManager.showError(
            message,
            context: context,
            position: position,
            duration: const Duration(seconds: 1),
          );
          break;
        case NotificationType.success:
          UnifiedNotificationManager.showSuccess(
            message,
            context: context,
            position: position,
            duration: const Duration(seconds: 1),
          );
          break;
      }
    }

    updateMessage();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds--;
      if (remainingSeconds <= 0) {
        timer.cancel();
        if (position == NotificationPosition.top) {
          UnifiedNotificationManager.hideOverlay();
        } else {
          UnifiedNotificationManager.hideSnackBar();
        }
        onTimeout?.call();
      } else {
        updateMessage();
      }
    });
  }

  /// Показать группу связанных сообщений
  static void showGroup(
    List<({String message, NotificationType type, Duration? delay})> messages, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    Duration defaultDelay = const Duration(milliseconds: 800),
  }) {
    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      Timer((msg.delay ?? defaultDelay) * i, () {
        switch (msg.type) {
          case NotificationType.info:
            UnifiedNotificationManager.showInfo(
              msg.message,
              context: context,
              position: position,
            );
            break;
          case NotificationType.warning:
            UnifiedNotificationManager.showWarning(
              msg.message,
              context: context,
              position: position,
            );
            break;
          case NotificationType.error:
            UnifiedNotificationManager.showError(
              msg.message,
              context: context,
              position: position,
            );
            break;
          case NotificationType.success:
            UnifiedNotificationManager.showSuccess(
              msg.message,
              context: context,
              position: position,
            );
            break;
        }
      });
    }
  }

  /// Освободить все ресурсы расширений
  static void disposeExtensions() {
    _progressSubscription?.cancel();
    _conditionalTimer?.cancel();
  }
}

/// Предустановленные шаблоны уведомлений
class UnifiedNotificationTemplates {
  // Сетевые операции
  static void showNetworkError({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    VoidCallback? onRetry,
  }) {
    UnifiedNotificationManager.showError(
      'Ошибка подключения к сети',
      context: context,
      position: position,
      actionLabel: onRetry != null ? 'Повторить' : null,
      onAction: onRetry,
    );
  }

  static void showNetworkSuccess({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showSuccess(
      'Подключение восстановлено',
      context: context,
      position: position,
    );
  }

  // Операции с файлами
  static void showFileError(
    String fileName, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showError(
      'Ошибка при работе с файлом',
      context: context,
      position: position,
      subtitle: fileName,
    );
  }

  static void showFileSaved(
    String fileName, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showSuccess(
      'Файл сохранен',
      context: context,
      position: position,
      subtitle: fileName,
    );
  }

  static void showFileDeleted(
    String fileName, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    VoidCallback? onUndo,
  }) {
    UnifiedNotificationManager.showWarning(
      'Файл удален',
      context: context,
      position: position,
      subtitle: fileName,
      actionLabel: onUndo != null ? 'Отменить' : null,
      onAction: onUndo,
    );
  }

  // Аутентификация
  static void showLoginSuccess(
    String username, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showSuccess(
      'Добро пожаловать, $username!',
      context: context,
      position: position,
    );
  }

  static void showLoginError({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showError(
      'Неверные учетные данные',
      context: context,
      position: position,
    );
  }

  static void showSessionExpired({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showWarning(
      'Сессия истекла',
      context: context,
      position: position,
      subtitle: 'Войдите в систему заново',
    );
  }

  // Операции с данными
  static void showDataSaved({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showSuccess(
      'Данные сохранены',
      context: context,
      position: position,
    );
  }

  static void showDataError({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showError(
      'Ошибка при сохранении данных',
      context: context,
      position: position,
    );
  }

  static void showDataLoading({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showInfo(
      'Загрузка данных...',
      context: context,
      position: position,
    );
  }

  // Валидация
  static void showValidationError(
    String field, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showWarning(
      'Проверьте правильность заполнения',
      context: context,
      position: position,
      subtitle: field,
    );
  }

  static void showValidationSuccess({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showSuccess(
      'Все поля заполнены корректно',
      context: context,
      position: position,
    );
  }

  // Операции копирования/вставки
  static void showCopiedToClipboard(
    String content, {
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    final displayContent = content.length > 20
        ? '${content.substring(0, 20)}...'
        : content;

    UnifiedNotificationManager.showInfo(
      'Скопировано в буфер обмена',
      context: context,
      position: position,
      subtitle: displayContent,
    );
  }

  static void showPastedFromClipboard({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showInfo(
      'Данные вставлены из буфера обмена',
      context: context,
      position: position,
    );
  }

  // Обновления и синхронизация
  static void showUpdateAvailable({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    VoidCallback? onUpdate,
  }) {
    UnifiedNotificationManager.showInfo(
      'Доступно обновление',
      context: context,
      position: position,
      duration: const Duration(seconds: 8),
    );
  }

  static void showSyncInProgress({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showProgress(
      'Синхронизация...',
      context: context,
      position: position,
    );
  }

  static void showSyncCompleted({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
  }) {
    UnifiedNotificationManager.showSuccess(
      'Синхронизация завершена',
      context: context,
      position: position,
    );
  }

  static void showSyncError({
    BuildContext? context,
    NotificationPosition position = NotificationPosition.bottom,
    VoidCallback? onRetry,
  }) {
    UnifiedNotificationManager.showError(
      'Ошибка синхронизации',
      context: context,
      position: position,
      actionLabel: onRetry != null ? 'Повторить' : null,
      onAction: onRetry,
    );
  }
}
