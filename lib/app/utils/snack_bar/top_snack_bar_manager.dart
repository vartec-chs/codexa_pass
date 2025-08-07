import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'top_snack_bar_config.dart';
import 'top_snack_bar_widget.dart';

/// Главный класс для управления Top Snack Bar
class TopSnackBarManager {
  static final TopSnackBarManager _instance = TopSnackBarManager._internal();
  factory TopSnackBarManager() => _instance;
  TopSnackBarManager._internal();

  static OverlayEntry? _currentEntry;
  static bool _isShowing = false;
  final Queue<TopSnackBarConfig> _messageQueue = Queue<TopSnackBarConfig>();
  Timer? _autoShowTimer;

  /// Показать Top Snack Bar с заданной конфигурацией
  static void show(BuildContext context, TopSnackBarConfig config) {
    // Если уже показывается сообщение
    if (_isShowing) {
      // Для ошибок прерываем текущее сообщение
      if (config.type == TopSnackBarType.error) {
        hide();
        _instance._showImmediately(context, config);
        return;
      }

      // Для остальных типов добавляем в очередь
      _instance._addToQueue(config, context);
      return;
    }

    _instance._showImmediately(context, config);
  }

  /// Немедленно показать сообщение
  void _showImmediately(BuildContext context, TopSnackBarConfig config) {
    _isShowing = true;
    _currentEntry = OverlayEntry(
      builder: (context) => TopSnackBarWidget(
        config: config,
        onDismiss: () {
          hide();
          config.onDismiss?.call();
          // Обработать очередь после закрытия
          _processQueue(context);
        },
      ),
    );

    Overlay.of(context).insert(_currentEntry!);

    // Автоматическое скрытие
    Future.delayed(config.duration, () {
      if (_isShowing) {
        hide();
        // Обработать очередь после автоматического закрытия
        _processQueue(context);
      }
    });
  }

  /// Добавить в очередь сообщений
  void _addToQueue(TopSnackBarConfig config, BuildContext context) {
    // Для ошибок добавляем в начало очереди
    if (config.type == TopSnackBarType.error) {
      _messageQueue.addFirst(config);
    } else {
      _messageQueue.add(config);
    }

    // Сортируем очередь по приоритету
    _sortQueueByPriority();
  }

  /// Сортировать очередь по приоритету типов сообщений
  void _sortQueueByPriority() {
    if (_messageQueue.length <= 1) return;

    final messages = _messageQueue.toList();
    _messageQueue.clear();

    // Сортируем по приоритету: error > warning > info > success
    messages.sort(
      (a, b) => TopSnackBarUtils.getTypePriority(
        a.type,
      ).compareTo(TopSnackBarUtils.getTypePriority(b.type)),
    );

    for (final message in messages) {
      _messageQueue.add(message);
    }
  }

  /// Обработать очередь сообщений
  void _processQueue(BuildContext context) {
    if (_isShowing || _messageQueue.isEmpty) return;

    // Небольшая задержка перед показом следующего сообщения
    Timer(const Duration(milliseconds: 300), () {
      if (_messageQueue.isNotEmpty && !_isShowing) {
        final nextConfig = _messageQueue.removeFirst();
        _showImmediately(context, nextConfig);
      }
    });
  }

  /// Скрыть текущий Top Snack Bar
  static void hide() {
    if (_isShowing && _currentEntry != null) {
      _currentEntry!.remove();
      _currentEntry = null;
      _isShowing = false;
    }
  }

  /// Скрыть текущий и показать следующий немедленно (для приоритетных сообщений)
  static void hideAndShowNext(BuildContext context) {
    hide();
    // Минимальная задержка для приоритетных сообщений
    Timer(const Duration(milliseconds: 50), () {
      _instance._processQueue(context);
    });
  }

  /// Очистить очередь сообщений
  static void clearQueue() {
    _instance._messageQueue.clear();
  }

  /// Получить количество сообщений в очереди
  static int get queueLength => _instance._messageQueue.length;

  /// Проверить, показывается ли сейчас Top Snack Bar
  static bool get isShowing => _isShowing;

  /// Запустить автоматический показ сообщений с интервалом
  static void startAutoShow(
    BuildContext context, {
    Duration interval = const Duration(seconds: 2),
  }) {
    _instance._autoShowTimer?.cancel();
    _instance._autoShowTimer = Timer.periodic(interval, (_) {
      _instance._processQueue(context);
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
    hide();
  }
}
