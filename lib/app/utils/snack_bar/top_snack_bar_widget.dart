import 'package:flutter/material.dart';
import 'top_snack_bar_config.dart';

/// Виджет Top Snack Bar
class TopSnackBarWidget extends StatefulWidget {
  final TopSnackBarConfig config;
  final VoidCallback onDismiss;

  const TopSnackBarWidget({
    Key? key,
    required this.config,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<TopSnackBarWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _iconController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconAnimation;

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
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(slideInCurve);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(fadeInCurve);

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(scaleInCurve);

    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(iconCurve);
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
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!mounted) return;

    await Future.wait([
      _slideController.reverse(),
      _fadeController.reverse(),
      _scaleController.reverse(),
    ]);

    if (mounted) {
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = TopSnackBarColors.forType(widget.config.type);
    final theme = TopSnackBarTheme.forType(widget.config.type);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: widget.config.margin,
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: widget.config.onTap,
                    onVerticalDragUpdate: widget.config.isDismissible
                        ? (details) {
                            // Свайп вверх для закрытия
                            if (details.delta.dy < -5) {
                              _dismiss();
                            }
                          }
                        : null,
                    child: Container(
                      padding: widget.config.padding,
                      decoration: BoxDecoration(
                        gradient: theme.gradient,
                        borderRadius: BorderRadius.circular(
                          widget.config.borderRadius,
                        ),
                        border: Border.all(
                          color: colors.borderColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: theme.shadows,
                      ),
                      child: Row(
                        children: [
                          // Анимированная иконка
                          _buildAnimatedIcon(colors),
                          const SizedBox(width: 12),

                          // Контент сообщения
                          Expanded(child: _buildMessageContent(colors)),

                          // Кнопка закрытия
                          if (widget.config.showCloseButton)
                            _buildAnimatedCloseButton(colors),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(TopSnackBarColors colors) {
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
            widget.config.customIcon != null
                ? (widget.config.customIcon as Icon).icon
                : TopSnackBarUtils.getIconForType(widget.config.type),
            color: colors.iconColor,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(TopSnackBarColors colors) {
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
              widget.config.message,
              style: TextStyle(
                color: colors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // Анимированный подзаголовок
        if (widget.config.subtitle != null) ...[
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
                widget.config.subtitle!,
                style: TextStyle(
                  color: colors.textColor.withOpacity(0.85),
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
      ],
    );
  }

  Widget _buildAnimatedCloseButton(TopSnackBarColors colors) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _iconAnimation,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _dismiss,
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
                  color: colors.iconColor.withOpacity(0.8),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
