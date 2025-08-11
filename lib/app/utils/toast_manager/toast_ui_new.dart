import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'toast_models.dart';
import 'toast_manager.dart';

/// Виджет для отображения toast уведомления
class ToastUI extends StatefulWidget {
  final ToastConfig config;

  const ToastUI({super.key, required this.config});

  @override
  State<ToastUI> createState() => _ToastUIState();
}

class _ToastUIState extends State<ToastUI> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _progressController;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  Timer? _dismissTimer;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
    _startProgressTimer();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _progressController = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );

    // Slide animation
    _slideAnimation =
        Tween<double>(
          begin: _getSlideBegin(widget.config.position),
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Opacity animation
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Scale animation for modern bounce effect
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  void _startProgressTimer() {
    _progressController.forward();

    _dismissTimer = Timer(widget.config.duration, () {
      if (mounted && !_isHovered) {
        _dismissToast();
      }
    });
  }

  void _pauseProgress() {
    if (_isHovered) return;

    _isHovered = true;
    _progressController.stop();
    _dismissTimer?.cancel();
  }

  void _resumeProgress() {
    if (!_isHovered) return;

    _isHovered = false;

    // Вычисляем оставшееся время
    final elapsed =
        _progressController.value * widget.config.duration.inMilliseconds;
    final remaining = widget.config.duration.inMilliseconds - elapsed;

    if (remaining > 0) {
      _progressController.duration = Duration(milliseconds: remaining.round());
      _progressController.forward();

      _dismissTimer = Timer(Duration(milliseconds: remaining.round()), () {
        if (mounted && !_isHovered) {
          _dismissToast();
        }
      });
    } else {
      _dismissToast();
    }
  }

  void _dismissToast() {
    if (mounted) {
      ToastManager.dismiss(widget.config.id);
    }
  }

  double _getSlideBegin(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
      case ToastPosition.topLeft:
      case ToastPosition.topRight:
        return -100;
      case ToastPosition.bottom:
      case ToastPosition.bottomLeft:
      case ToastPosition.bottomRight:
        return 100;
      case ToastPosition.left:
        return -100;
      case ToastPosition.right:
        return 100;
    }
  }

  void _startAnimation() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final toastColors = ToastColors.forType(widget.config.type, isDark);
    final icon = ToastIcons.getIcon(widget.config.type);

    return Positioned(
      top: _getTop(context),
      bottom: _getBottom(context),
      left: _getLeft(context),
      right: _getRight(context),
      child: MouseRegion(
        onEnter: (_) => _pauseProgress(),
        onExit: (_) => _resumeProgress(),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: _getTranslationOffset(),
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildToastContent(
                    toastColors,
                    Icon(icon, color: toastColors.accentColor, size: 24),
                    theme,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double? _getTop(BuildContext context) {
    final offset = ToastManager.instance.getToastOffset(
      widget.config.id,
      widget.config.position,
    );

    switch (widget.config.position) {
      case ToastPosition.top:
      case ToastPosition.topLeft:
      case ToastPosition.topRight:
        return 60.0 + offset;
      case ToastPosition.left:
      case ToastPosition.right:
        return MediaQuery.of(context).size.height / 2 - 40 + offset;
      default:
        return null;
    }
  }

  double? _getBottom(BuildContext context) {
    final offset = ToastManager.instance.getToastOffset(
      widget.config.id,
      widget.config.position,
    );

    switch (widget.config.position) {
      case ToastPosition.bottom:
      case ToastPosition.bottomLeft:
      case ToastPosition.bottomRight:
        return 60.0 - offset;
      default:
        return null;
    }
  }

  double? _getLeft(BuildContext context) {
    const margin = 16.0;

    switch (widget.config.position) {
      case ToastPosition.top:
      case ToastPosition.bottom:
      case ToastPosition.topLeft:
      case ToastPosition.bottomLeft:
      case ToastPosition.left:
        return margin;
      default:
        return null;
    }
  }

  double? _getRight(BuildContext context) {
    const margin = 16.0;

    switch (widget.config.position) {
      case ToastPosition.top:
      case ToastPosition.bottom:
      case ToastPosition.topRight:
      case ToastPosition.bottomRight:
      case ToastPosition.right:
        return margin;
      default:
        return null;
    }
  }

  Offset _getTranslationOffset() {
    final slideValue = _slideAnimation.value;

    switch (widget.config.position) {
      case ToastPosition.top:
      case ToastPosition.topLeft:
      case ToastPosition.topRight:
      case ToastPosition.bottom:
      case ToastPosition.bottomLeft:
      case ToastPosition.bottomRight:
        return Offset(0, slideValue);
      case ToastPosition.left:
        return Offset(slideValue, 0);
      case ToastPosition.right:
        return Offset(-slideValue, 0);
    }
  }

  Widget _buildToastContent(
    ToastColors colors,
    Widget iconWidget,
    ThemeData theme,
  ) {
    final isFullWidth = _isFullWidthPosition(widget.config.position);

    return Container(
      width: isFullWidth ? null : 320,
      constraints: BoxConstraints(
        maxWidth: isFullWidth ? double.infinity : 380,
        minHeight: 64,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient:
                  colors.gradient ??
                  LinearGradient(
                    colors: [colors.backgroundColor, colors.backgroundColor],
                  ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colors.shadowColor,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: colors.accentColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Главный контент тоста
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.config.onTap,
                    borderRadius: BorderRadius.circular(16),
                    splashColor: colors.accentColor.withOpacity(0.2),
                    highlightColor: colors.accentColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: isFullWidth
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        children: [
                          // Icon section
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.accentColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: iconWidget,
                          ),
                          const SizedBox(width: 12),

                          // Content section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.config.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colors.textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.config.subtitle != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.config.subtitle!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colors.textColor.withOpacity(0.9),
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Copy button (если включена)
                          if (widget.config.showCopyButton)
                            _buildCopyButton(colors),

                          // Action buttons
                          if (widget.config.actions.isNotEmpty)
                            ...widget.config.actions.map(
                              (action) =>
                                  _buildActionButton(action, colors, theme),
                            ),

                          // Close button (если включен)
                          if (widget.config.showCloseButton)
                            _buildCloseButton(colors),
                        ],
                      ),
                    ),
                  ),
                ),

                // Progress bar
                if (widget.config.showProgressBar) _buildProgressBar(colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isFullWidthPosition(ToastPosition position) {
    return position == ToastPosition.top || position == ToastPosition.bottom;
  }

  Widget _buildProgressBar(ToastColors colors) {
    return Container(
      height: 3,
      margin: const EdgeInsets.only(top: 2),
      child: AnimatedBuilder(
        animation: _progressController,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _progressController.value,
            backgroundColor: colors.textColor.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              _isHovered
                  ? colors.progressColor.withOpacity(0.5)
                  : colors.progressColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
    ToastAction action,
    ToastColors colors,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: TextButton(
        onPressed: action.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: action.color ?? colors.accentColor,
          backgroundColor: (action.color ?? colors.accentColor).withOpacity(
            0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(0, 32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (action.icon != null) ...[
              Icon(action.icon, size: 16),
              const SizedBox(width: 4),
            ],
            Text(
              action.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: action.color ?? colors.accentColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyButton(ToastColors colors) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: () => _copyToClipboard(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colors.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.copy_rounded, size: 18, color: colors.accentColor),
        ),
      ),
    );
  }

  void _copyToClipboard() {
    final textToCopy = widget.config.subtitle != null
        ? '${widget.config.title}\n${widget.config.subtitle}'
        : widget.config.title;

    Clipboard.setData(ClipboardData(text: textToCopy));

    // Показываем краткое уведомление о копировании
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Скопировано в буфер обмена'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildCloseButton(ToastColors colors) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: () => ToastManager.dismiss(widget.config.id),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colors.textColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 18,
            color: colors.textColor.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
