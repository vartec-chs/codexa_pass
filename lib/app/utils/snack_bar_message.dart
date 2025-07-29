import 'dart:async';
import 'dart:collection';
import 'package:codexa_pass/app/logger/app_logger.dart';
import 'package:flutter/material.dart';
import '../global.dart';

enum SnackBarType { info, warning, error, success }

class SnackBarMessage {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final VoidCallback? onAction;
  final String? actionLabel;
  final DateTime timestamp;
  final bool showProgress;
  final double? progress;
  final String? subtitle;
  final bool isDismissible;
  final Widget? customIcon;

  SnackBarMessage({
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 4),
    this.onAction,
    this.actionLabel,
    this.showProgress = false,
    this.progress,
    this.subtitle,
    this.isDismissible = true,
    this.customIcon,
  }) : timestamp = DateTime.now();
}

class SnackBarManager {
  static final SnackBarManager _instance = SnackBarManager._internal();
  factory SnackBarManager() => _instance;
  SnackBarManager._internal();

  final Queue<SnackBarMessage> _messageQueue = Queue<SnackBarMessage>();
  bool _isShowing = false;
  Timer? _autoShowTimer;

  /// Показать информационное сообщение
  static void showInfo(
    String message, {
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
    bool showProgress = false,
    double? progress,
    String? subtitle,
    Widget? customIcon,
  }) {
    logDebug('Showing info SnackBar: $message');
    _instance._addMessage(
      SnackBarMessage(
        message: message,
        type: SnackBarType.info,
        duration: duration ?? const Duration(seconds: 4),
        onAction: onAction,
        actionLabel: actionLabel,
        showProgress: showProgress,
        progress: progress,
        subtitle: subtitle,
        customIcon: customIcon,
      ),
    );
  }

  /// Показать предупреждение
  static void showWarning(
    String message, {
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
    bool showProgress = false,
    double? progress,
    String? subtitle,
    Widget? customIcon,
  }) {
    _instance._addMessage(
      SnackBarMessage(
        message: message,
        type: SnackBarType.warning,
        duration: duration ?? const Duration(seconds: 5),
        onAction: onAction,
        actionLabel: actionLabel,
        showProgress: showProgress,
        progress: progress,
        subtitle: subtitle,
        customIcon: customIcon,
      ),
    );
  }

  /// Показать ошибку
  static void showError(
    String message, {
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
    bool showProgress = false,
    double? progress,
    String? subtitle,
    Widget? customIcon,
  }) {
    _instance._addMessage(
      SnackBarMessage(
        message: message,
        type: SnackBarType.error,
        duration: duration ?? const Duration(seconds: 6),
        onAction: onAction,
        actionLabel: actionLabel,
        showProgress: showProgress,
        progress: progress,
        subtitle: subtitle,
        customIcon: customIcon,
      ),
    );
  }

  /// Показать успешное сообщение
  static void showSuccess(
    String message, {
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
    bool showProgress = false,
    double? progress,
    String? subtitle,
    Widget? customIcon,
  }) {
    _instance._addMessage(
      SnackBarMessage(
        message: message,
        type: SnackBarType.success,
        duration: duration ?? const Duration(seconds: 3),
        onAction: onAction,
        actionLabel: actionLabel,
        showProgress: showProgress,
        progress: progress,
        subtitle: subtitle,
        customIcon: customIcon,
      ),
    );
  }

  /// Добавить сообщение в очередь
  void _addMessage(SnackBarMessage message) {
    _messageQueue.add(message);
    _processQueue();
  }

  /// Обработать очередь сообщений
  void _processQueue() {
    if (_isShowing || _messageQueue.isEmpty) return;

    _showNextMessage();
  }

  /// Показать следующее сообщение из очереди
  void _showNextMessage() {
    if (_messageQueue.isEmpty) return;

    final message = _messageQueue.removeFirst();
    _isShowing = true;

    final snackBar = _buildSnackBar(message);

    snackbarKey.currentState?.showSnackBar(snackBar).closed.then((_) {
      _isShowing = false;
      // Небольшая задержка перед показом следующего сообщения
      Timer(const Duration(milliseconds: 300), () {
        _processQueue();
      });
    });
  }

  /// Построить SnackBar для сообщения
  SnackBar _buildSnackBar(SnackBarMessage message) {
    final colors = _getColorsForType(message.type);
    final theme = _getThemeForType(message.type);

    return SnackBar(
      content: _buildSnackBarContent(message, colors, theme),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      duration: message.duration,
      action: message.onAction != null && message.actionLabel != null
          ? SnackBarAction(
              label: message.actionLabel!,
              textColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              onPressed: message.onAction!,
            )
          : null,
      dismissDirection: message.isDismissible
          ? DismissDirection.horizontal
          : DismissDirection.none,
    );
  }

  /// Построить содержимое SnackBar
  Widget _buildSnackBarContent(
    SnackBarMessage message,
    _SnackBarColors colors,
    _SnackBarTheme theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: theme.gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.borderColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Иконка с анимацией
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              message.customIcon != null
                  ? (message.customIcon as Icon).icon
                  : _getIconForType(message.type),
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),

          // Контент сообщения
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Основное сообщение
                Text(
                  message.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Подзаголовок (если есть)
                if (message.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    message.subtitle!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Индикатор прогресса (если включен)
                if (message.showProgress) ...[
                  const SizedBox(height: 12),
                  _buildProgressIndicator(message.progress, colors),
                ],
              ],
            ),
          ),

          // Кнопка действия (если есть)
          if (message.onAction != null && message.actionLabel != null) ...[
            const SizedBox(width: 12),
            _buildActionButton(message, colors),
          ],

          // Кнопка закрытия (если dismissible)
          if (message.isDismissible) ...[
            const SizedBox(width: 8),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _instance._hideCurrentAndProcessQueue(),
                  borderRadius: BorderRadius.circular(8),
                  hoverColor: Colors.white.withOpacity(0.1),
                  splashColor: Colors.white.withOpacity(0.2),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.8),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Построить индикатор прогресса
  Widget _buildProgressIndicator(double? progress, _SnackBarColors colors) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: progress != null
          ? FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (progress / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.3),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
    );
  }

  /// Построить кнопку действия
  Widget _buildActionButton(SnackBarMessage message, _SnackBarColors colors) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: message.onAction,
            borderRadius: BorderRadius.circular(12),
            hoverColor: Colors.white.withOpacity(0.1),
            splashColor: Colors.white.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                message.actionLabel!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Получить цвета для типа сообщения
  _SnackBarColors _getColorsForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return _SnackBarColors(
          backgroundColor: const Color(0xFF2196F3),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: const Color(0xFF1976D2),
          actionColor: Colors.white,
        );
      case SnackBarType.warning:
        return _SnackBarColors(
          backgroundColor: const Color(0xFFFF9800),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: const Color(0xFFF57C00),
          actionColor: Colors.white,
        );
      case SnackBarType.error:
        return _SnackBarColors(
          backgroundColor: const Color(0xFFF44336),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: const Color(0xFFD32F2F),
          actionColor: Colors.white,
        );
      case SnackBarType.success:
        return _SnackBarColors(
          backgroundColor: const Color(0xFF4CAF50),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: const Color(0xFF388E3C),
          actionColor: Colors.white,
        );
    }
  }

  /// Получить тему для типа сообщения
  _SnackBarTheme _getThemeForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return _SnackBarTheme(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF42A5F5),
              const Color(0xFF1E88E5),
              const Color(0xFF1565C0),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
          shadowColor: const Color(0xFF1976D2).withOpacity(0.3),
        );
      case SnackBarType.warning:
        return _SnackBarTheme(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFB74D),
              const Color(0xFFFF9800),
              const Color(0xFFF57C00),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
          shadowColor: const Color(0xFFFF9800).withOpacity(0.3),
        );
      case SnackBarType.error:
        return _SnackBarTheme(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFEF5350),
              const Color(0xFFF44336),
              const Color(0xFFD32F2F),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
          shadowColor: const Color(0xFFF44336).withOpacity(0.3),
        );
      case SnackBarType.success:
        return _SnackBarTheme(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF66BB6A),
              const Color(0xFF4CAF50),
              const Color(0xFF388E3C),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
          shadowColor: const Color(0xFF4CAF50).withOpacity(0.3),
        );
    }
  }

  /// Получить иконку для типа сообщения
  IconData _getIconForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return Icons.info_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.success:
        return Icons.check_circle_outline;
    }
  }

  /// Очистить очередь сообщений
  static void clearQueue() {
    _instance._messageQueue.clear();
  }

  /// Получить количество сообщений в очереди
  static int get queueLength => _instance._messageQueue.length;

  /// Скрыть текущий snackbar
  static void hideCurrent() {
    _instance._hideCurrentAndProcessQueue();
  }

  /// Скрыть текущий snackbar и обработать очередь
  void _hideCurrentAndProcessQueue() {
    snackbarKey.currentState?.hideCurrentSnackBar();
    _isShowing = false;
    // Небольшая задержка перед показом следующего сообщения
    Timer(const Duration(milliseconds: 200), () {
      _processQueue();
    });
  }

  /// Запустить автоматический показ сообщений с интервалом
  static void startAutoShow({Duration interval = const Duration(seconds: 2)}) {
    _instance._autoShowTimer?.cancel();
    _instance._autoShowTimer = Timer.periodic(interval, (_) {
      _instance._processQueue();
    });
  }

  /// Остановить автоматический показ сообщений
  static void stopAutoShow() {
    _instance._autoShowTimer?.cancel();
    _instance._autoShowTimer = null;
  }

  /// Освободить ресурсы
  static void dispose() {
    _instance._autoShowTimer?.cancel();
    _instance._messageQueue.clear();
  }
}

class _SnackBarColors {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color borderColor;
  final Color actionColor;

  _SnackBarColors({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.borderColor,
    required this.actionColor,
  });
}

class _SnackBarTheme {
  final LinearGradient gradient;
  final Color shadowColor;

  _SnackBarTheme({required this.gradient, required this.shadowColor});
}
