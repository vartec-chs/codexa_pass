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
    // Если это ошибка и есть отображаемое сообщение - скрываем его и показываем ошибку
    if (message.type == SnackBarType.error && _isShowing) {
      logDebug('Priority error message: interrupting current snackbar');
      // Добавляем ошибку в начало очереди для приоритетного показа
      _messageQueue.addFirst(message);
      // Принудительно скрываем текущее сообщение
      _hideCurrentAndShowNext();
      return;
    }

    // Для ошибок добавляем в начало очереди, для остальных - в конец
    if (message.type == SnackBarType.error) {
      logDebug('Adding priority error message to front of queue');
      _messageQueue.addFirst(message);
    } else {
      _messageQueue.add(message);
    }

    _processQueue();
  }

  /// Обработать очередь сообщений
  void _processQueue() {
    if (_isShowing || _messageQueue.isEmpty) return;

    // Сортируем очередь по приоритету (ошибки первыми)
    _sortQueueByPriority();
    _showNextMessage();
  }

  /// Сортировать очередь по приоритету типов сообщений
  void _sortQueueByPriority() {
    if (_messageQueue.length <= 1) return;

    final messages = _messageQueue.toList();
    _messageQueue.clear();

    // Сортируем по приоритету: error > warning > info > success
    messages.sort(
      (a, b) => _getTypePriority(a.type).compareTo(_getTypePriority(b.type)),
    );

    for (final message in messages) {
      _messageQueue.add(message);
    }
  }

  /// Получить приоритет типа сообщения (меньше = выше приоритет)
  int _getTypePriority(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return 0; // Наивысший приоритет
      case SnackBarType.warning:
        return 1;
      case SnackBarType.info:
        return 2;
      case SnackBarType.success:
        return 3; // Наименьший приоритет
    }
  }

  /// Показать следующее сообщение из очереди
  void _showNextMessage() {
    if (_messageQueue.isEmpty) return;

    final message = _messageQueue.removeFirst();
    _isShowing = true;

    final snackBar = _buildSnackBar(message);

    scaffoldMessengerKey.currentState?.showSnackBar(snackBar).closed.then((_) {
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      duration: message.duration,
      // Убираем встроенное действие, так как используем кастомное
      action: null,
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
    return _AnimatedSnackBarContent(
      message: message,
      colors: colors,
      theme: theme,
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

  /// Освободить ресурсы
  static void dispose() {
    _instance._autoShowTimer?.cancel();
    _instance._messageQueue.clear();
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
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _isShowing = false;
    // Небольшая задержка перед показом следующего сообщения
    Timer(const Duration(milliseconds: 200), () {
      _processQueue();
    });
  }

  /// Скрыть текущий snackbar и немедленно показать следующий (для приоритетных сообщений)
  void _hideCurrentAndShowNext() {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _isShowing = false;
    // Минимальная задержка для приоритетных сообщений (ошибок)
    Timer(const Duration(milliseconds: 50), () {
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

/// Анимированный контент для SnackBar
class _AnimatedSnackBarContent extends StatefulWidget {
  final SnackBarMessage message;
  final _SnackBarColors colors;
  final _SnackBarTheme theme;

  const _AnimatedSnackBarContent({
    required this.message,
    required this.colors,
    required this.theme,
  });

  @override
  State<_AnimatedSnackBarContent> createState() =>
      _AnimatedSnackBarContentState();
}

class _AnimatedSnackBarContentState extends State<_AnimatedSnackBarContent>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _iconController;
  late AnimationController _progressController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimations();
  }

  void _initializeAnimations() {
    // Основные анимации
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Кривые анимации
    final slideInCurve = CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    );
    final fadeInCurve = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    final scaleInCurve = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    final iconCurve = CurvedAnimation(
      parent: _iconController,
      curve: Curves.bounceOut,
    );

    // Анимации
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(slideInCurve);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(fadeInCurve);

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(scaleInCurve);

    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(iconCurve);

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  void _startEntryAnimations() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _slideController.forward();
        _fadeController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _scaleController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _iconController.forward();
      }
    });

    if (widget.message.showProgress) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          _progressController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _iconController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: widget.theme.gradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.colors.borderColor.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.theme.shadowColor,
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
                // Анимированная иконка
                _buildAnimatedIcon(),
                const SizedBox(width: 16),

                // Контент сообщения - занимает всё доступное пространство
                Expanded(child: _buildMessageContent()),

                // Кнопки справа - фиксированная ширина
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Кнопка действия (если есть)
                    if (widget.message.onAction != null &&
                        widget.message.actionLabel != null) ...[
                      const SizedBox(width: 12),
                      _buildAnimatedActionButton(),
                    ],

                    // Кнопка закрытия (если dismissible)
                    if (widget.message.isDismissible) ...[
                      const SizedBox(width: 8),
                      _buildAnimatedCloseButton(),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return ScaleTransition(
      scale: _iconAnimation,
      child: RotationTransition(
        turns: Tween<double>(begin: 0, end: 0.1).animate(_iconAnimation),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            widget.message.customIcon != null
                ? (widget.message.customIcon as Icon).icon
                : _getIconForType(widget.message.type),
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Основное сообщение с анимацией
        FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.2, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _fadeController,
                    curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                  ),
                ),
            child: Text(
              widget.message.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // Анимированный подзаголовок
        if (widget.message.subtitle != null) ...[
          const SizedBox(height: 4),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _fadeController,
                      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                    ),
                  ),
              child: Text(
                widget.message.subtitle!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],

        // Анимированный прогресс-бар
        if (widget.message.showProgress) ...[
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _progressAnimation,
            child: ScaleTransition(
              scale: _progressAnimation,
              alignment: Alignment.centerLeft,
              child: _buildProgressIndicator(
                widget.message.progress,
                widget.colors,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAnimatedActionButton() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 60,
              maxWidth: 120, // Ограничиваем максимальную ширину
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.message.onAction,
                borderRadius: BorderRadius.circular(12),
                hoverColor: Colors.white.withOpacity(0.1),
                splashColor: Colors.white.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Text(
                    widget.message.actionLabel!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCloseButton() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _iconAnimation,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () =>
                  SnackBarManager._instance._hideCurrentAndProcessQueue(),
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
      ),
    );
  }

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
          : _buildAnimatedProgressBar(),
    );
  }

  Widget _buildAnimatedProgressBar() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.3),
              ],
              stops: [
                (0.0 + _progressAnimation.value * 0.3) % 1.0,
                (0.5 + _progressAnimation.value * 0.3) % 1.0,
                (1.0 + _progressAnimation.value * 0.3) % 1.0,
              ],
            ),
          ),
        );
      },
    );
  }

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
}
