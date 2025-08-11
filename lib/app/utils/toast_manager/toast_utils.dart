import 'package:flutter/material.dart';
import 'toast_manager.dart';
import 'toast_models.dart';

/// Утилиты для упрощенного использования Toast Manager
class ToastUtils {
  /// Быстрое отображение тоста успеха
  static void success(String message, {String? subtitle}) {
    ToastManager.showSuccess(message, subtitle: subtitle);
  }

  /// Быстрое отображение тоста ошибки
  static void error(String message, {String? subtitle}) {
    ToastManager.showError(message, subtitle: subtitle);
  }

  /// Быстрое отображение предупреждения
  static void warning(String message, {String? subtitle}) {
    ToastManager.showWarning(message, subtitle: subtitle);
  }

  /// Быстрое отображение информации
  static void info(String message, {String? subtitle}) {
    ToastManager.showInfo(message, subtitle: subtitle);
  }

  /// Тост с подтверждением действия
  static void confirmAction({
    required String title,
    required String confirmLabel,
    required VoidCallback onConfirm,
    String? subtitle,
    String cancelLabel = 'Отмена',
    VoidCallback? onCancel,
    ToastType type = ToastType.warning,
  }) {
    ToastManager.show(
      ToastConfig(
        id: ToastManager.generateId(),
        title: title,
        subtitle: subtitle,
        type: type,
        duration: const Duration(seconds: 10), // Дольше для принятия решения
        actions: [
          ToastAction(
            label: cancelLabel,
            onPressed: onCancel ?? () {},
            color: Colors.grey,
            icon: Icons.close,
          ),
          ToastAction(
            label: confirmLabel,
            onPressed: onConfirm,
            color: type == ToastType.error ? Colors.red : Colors.green,
            icon: Icons.check,
          ),
        ],
        showCloseButton: false,
      ),
    );
  }

  /// Тост с прогрессом операции
  static void progress({
    required String title,
    String? subtitle,
    Duration duration = const Duration(seconds: 8),
  }) {
    ToastManager.show(
      ToastConfig(
        id: ToastManager.generateId(),
        title: title,
        subtitle: subtitle,
        type: ToastType.info,
        duration: duration,
        showProgressBar: true,
        dismissible: false,
        showCloseButton: false,
      ),
    );
  }

  /// Тост с пользовательскими действиями
  static void withActions({
    required String title,
    String? subtitle,
    required List<ToastAction> actions,
    ToastType type = ToastType.info,
    Duration? duration,
  }) {
    ToastManager.show(
      ToastConfig(
        id: ToastManager.generateId(),
        title: title,
        subtitle: subtitle,
        type: type,
        duration: duration ?? const Duration(seconds: 6),
        actions: actions,
      ),
    );
  }

  /// Тост сохранения/копирования
  static void saveAction({
    required String title,
    required VoidCallback onSave,
    String? subtitle,
    String saveLabel = 'Сохранить',
  }) {
    ToastManager.show(
      ToastConfig(
        id: ToastManager.generateId(),
        title: title,
        subtitle: subtitle,
        type: ToastType.info,
        duration: const Duration(seconds: 5),
        actions: [
          ToastAction(
            label: saveLabel,
            onPressed: onSave,
            color: Colors.blue,
            icon: Icons.save,
          ),
        ],
      ),
    );
  }

  /// Тост с отменой действия
  static void undoAction({
    required String title,
    required VoidCallback onUndo,
    String? subtitle,
    String undoLabel = 'Отменить',
    Duration duration = const Duration(seconds: 5),
  }) {
    ToastManager.show(
      ToastConfig(
        id: ToastManager.generateId(),
        title: title,
        subtitle: subtitle,
        type: ToastType.info,
        duration: duration,
        actions: [
          ToastAction(
            label: undoLabel,
            onPressed: onUndo,
            color: Colors.orange,
            icon: Icons.undo,
          ),
        ],
      ),
    );
  }

  /// Очистить все тосты
  static void clear() {
    ToastManager.dismissAll();
    ToastManager.clearQueue();
  }

  /// Получить статистику
  static String getStats() {
    return 'Активных: ${ToastManager.activeCount}, В очереди: ${ToastManager.queueLength}';
  }
}

/// Расширения для контекста
extension ToastContextExtension on BuildContext {
  /// Быстрый доступ к тостам через контекст
  void showToastSuccess(String message, {String? subtitle}) {
    ToastUtils.success(message, subtitle: subtitle);
  }

  void showToastError(String message, {String? subtitle}) {
    ToastUtils.error(message, subtitle: subtitle);
  }

  void showToastWarning(String message, {String? subtitle}) {
    ToastUtils.warning(message, subtitle: subtitle);
  }

  void showToastInfo(String message, {String? subtitle}) {
    ToastUtils.info(message, subtitle: subtitle);
  }
}
