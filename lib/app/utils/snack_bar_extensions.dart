import 'dart:async';
import 'package:flutter/material.dart';
import 'snack_bar_message.dart';

/// Расширения для SnackBarManager с дополнительными возможностями
extension SnackBarManagerExtensions on SnackBarManager {
  /// Показать прогресс-сообщение с автообновлением
  static StreamSubscription<String>? _progressSubscription;

  static void showProgress(
    Stream<String> progressStream, {
    String? initialMessage,
    Duration updateInterval = const Duration(milliseconds: 500),
  }) {
    _progressSubscription?.cancel();

    if (initialMessage != null) {
      SnackBarManager.showInfo(initialMessage);
    }

    _progressSubscription = progressStream.distinct().listen((message) {
      SnackBarManager.hideCurrent();
      SnackBarManager.showInfo(message, duration: const Duration(seconds: 1));
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
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmLabel = 'Да',
    String cancelLabel = 'Отмена',
    Duration duration = const Duration(seconds: 10),
  }) {
    SnackBarManager.showWarning(
      message,
      duration: duration,
      actionLabel: confirmLabel,
      onAction: () {
        onConfirm();
        if (onCancel != null) {
          SnackBarManager.showInfo(
            'Отменить?',
            actionLabel: cancelLabel,
            onAction: onCancel,
            duration: const Duration(seconds: 3),
          );
        }
      },
    );
  }

  /// Показать сообщение с автоскрытием при условии
  static Timer? _conditionalTimer;

  static void showConditional(
    String message,
    SnackBarType type, {
    required bool Function() hideCondition,
    Duration checkInterval = const Duration(milliseconds: 500),
    Duration maxDuration = const Duration(seconds: 30),
  }) {
    switch (type) {
      case SnackBarType.info:
        SnackBarManager.showInfo(message, duration: maxDuration);
        break;
      case SnackBarType.warning:
        SnackBarManager.showWarning(message, duration: maxDuration);
        break;
      case SnackBarType.error:
        SnackBarManager.showError(message, duration: maxDuration);
        break;
      case SnackBarType.success:
        SnackBarManager.showSuccess(message, duration: maxDuration);
        break;
    }

    _conditionalTimer?.cancel();
    _conditionalTimer = Timer.periodic(checkInterval, (timer) {
      if (hideCondition()) {
        SnackBarManager.hideCurrent();
        timer.cancel();
      }
    });
  }

  /// Показать сообщение с счетчиком времени
  static void showWithCountdown(
    String baseMessage,
    SnackBarType type, {
    Duration countdownDuration = const Duration(seconds: 10),
    VoidCallback? onTimeout,
  }) {
    int remainingSeconds = countdownDuration.inSeconds;

    void updateMessage() {
      final message = '$baseMessage ($remainingSeconds сек.)';
      SnackBarManager.hideCurrent();

      switch (type) {
        case SnackBarType.info:
          SnackBarManager.showInfo(
            message,
            duration: const Duration(seconds: 1),
          );
          break;
        case SnackBarType.warning:
          SnackBarManager.showWarning(
            message,
            duration: const Duration(seconds: 1),
          );
          break;
        case SnackBarType.error:
          SnackBarManager.showError(
            message,
            duration: const Duration(seconds: 1),
          );
          break;
        case SnackBarType.success:
          SnackBarManager.showSuccess(
            message,
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
        SnackBarManager.hideCurrent();
        onTimeout?.call();
      } else {
        updateMessage();
      }
    });
  }

  /// Показать группу связанных сообщений
  static void showGroup(
    List<({String message, SnackBarType type, Duration? delay})> messages, {
    Duration defaultDelay = const Duration(milliseconds: 800),
  }) {
    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      Timer((msg.delay ?? defaultDelay) * i, () {
        switch (msg.type) {
          case SnackBarType.info:
            SnackBarManager.showInfo(msg.message);
            break;
          case SnackBarType.warning:
            SnackBarManager.showWarning(msg.message);
            break;
          case SnackBarType.error:
            SnackBarManager.showError(msg.message);
            break;
          case SnackBarType.success:
            SnackBarManager.showSuccess(msg.message);
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

/// Предустановленные шаблоны сообщений
class SnackBarTemplates {
  // Сетевые операции
  static void showNetworkError({VoidCallback? onRetry}) {
    SnackBarManager.showError(
      'Ошибка подключения к сети',
      actionLabel: onRetry != null ? 'Повторить' : null,
      onAction: onRetry,
    );
  }

  static void showNetworkSuccess() {
    SnackBarManager.showSuccess('Подключение восстановлено');
  }

  // Операции с файлами
  static void showFileError(String fileName) {
    SnackBarManager.showError('Ошибка при работе с файлом: $fileName');
  }

  static void showFileSaved(String fileName) {
    SnackBarManager.showSuccess('Файл сохранен: $fileName');
  }

  static void showFileDeleted(String fileName, {VoidCallback? onUndo}) {
    SnackBarManager.showWarning(
      'Файл удален: $fileName',
      actionLabel: onUndo != null ? 'Отменить' : null,
      onAction: onUndo,
    );
  }

  // Аутентификация
  static void showLoginSuccess(String username) {
    SnackBarManager.showSuccess('Добро пожаловать, $username!');
  }

  static void showLoginError() {
    SnackBarManager.showError('Неверные учетные данные');
  }

  static void showSessionExpired() {
    SnackBarManager.showWarning('Сессия истекла. Войдите в систему заново');
  }

  // Операции с данными
  static void showDataSaved() {
    SnackBarManager.showSuccess('Данные сохранены');
  }

  static void showDataError() {
    SnackBarManager.showError('Ошибка при сохранении данных');
  }

  static void showDataLoading() {
    SnackBarManager.showInfo('Загрузка данных...');
  }

  // Валидация
  static void showValidationError(String field) {
    SnackBarManager.showWarning('Проверьте правильность заполнения: $field');
  }

  static void showValidationSuccess() {
    SnackBarManager.showSuccess('Все поля заполнены корректно');
  }

  // Операции копирования/вставки
  static void showCopiedToClipboard(String content) {
    SnackBarManager.showInfo(
      'Скопировано: ${content.length > 20 ? '${content.substring(0, 20)}...' : content}',
    );
  }

  static void showPastedFromClipboard() {
    SnackBarManager.showInfo('Данные вставлены из буфера обмена');
  }

  // Обновления и синхронизация
  static void showUpdateAvailable({VoidCallback? onUpdate}) {
    SnackBarManager.showInfo(
      'Доступно обновление',
      actionLabel: onUpdate != null ? 'Обновить' : null,
      onAction: onUpdate,
      duration: const Duration(seconds: 8),
    );
  }

  static void showSyncInProgress() {
    SnackBarManager.showInfo('Синхронизация...');
  }

  static void showSyncCompleted() {
    SnackBarManager.showSuccess('Синхронизация завершена');
  }

  static void showSyncError({VoidCallback? onRetry}) {
    SnackBarManager.showError(
      'Ошибка синхронизации',
      actionLabel: onRetry != null ? 'Повторить' : null,
      onAction: onRetry,
    );
  }
}
