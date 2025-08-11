import 'package:flutter/material.dart';
import 'toast_models.dart';
import 'toast_manager.dart';

/// Основной виджет тоста с анимациями
class ToastWidget extends StatefulWidget {
  final ToastConfig config;
  final VoidCallback onDismiss;

  const ToastWidget({super.key, required this.config, required this.onDismiss});

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _progressController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimations();
    _startProgressAnimation();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _progressController = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );

    // Настраиваем анимации в зависимости от позиции
    final slideOffset = widget.config.position == ToastPosition.top
        ? const Offset(0, -1)
        : const Offset(0, 1);

    _slideAnimation = Tween<Offset>(begin: slideOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutQuart),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _progressAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );
  }

  void _startEntryAnimations() {
    _slideController.forward();
    _fadeController.forward();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _scaleController.forward();
      }
    });
  }

  void _startProgressAnimation() {
    if (widget.config.showProgressBar) {
      _progressController.forward();
    }
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
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = ToastColors.forType(widget.config.type, isDark);

    final offset = ToastManager.instance.getToastOffset(
      widget.config.id,
      widget.config.position,
    );

    return Positioned(
      top: widget.config.position == ToastPosition.top
          ? MediaQuery.of(context).padding.top +
                widget.config.margin.top +
                offset
          : null,
      bottom: widget.config.position == ToastPosition.bottom
          ? MediaQuery.of(context).padding.bottom +
                widget.config.margin.bottom +
                offset.abs()
          : null,
      left: widget.config.margin.left,
      right: widget.config.margin.right,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              color: Colors.transparent,
              child: _buildToastContent(context, colors),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToastContent(BuildContext context, ToastColors colors) {
    return Container(
      width: widget.config.width,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Основной контент
          _buildMainContent(colors),

          // Прогресс-бар
          if (widget.config.showProgressBar) _buildProgressBar(colors),
        ],
      ),
    );
  }

  Widget _buildMainContent(ToastColors colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: Row(
        children: [
          // Иконка
          _buildIcon(colors),

          const SizedBox(width: 12),

          // Текстовый контент
          Expanded(child: _buildTextContent(colors)),

          // Кнопки действий
          if (widget.config.actions.isNotEmpty || widget.config.showCloseButton)
            _buildActions(colors),
        ],
      ),
    );
  }

  Widget _buildIcon(ToastColors colors) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colors.iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        ToastIcons.getIcon(widget.config.type),
        color: colors.iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildTextContent(ToastColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Заголовок
        Text(
          widget.config.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colors.textColor,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Подзаголовок
        if (widget.config.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.config.subtitle!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: colors.textColor.withOpacity(0.8),
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildActions(ToastColors colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Кастомные действия
        ...widget.config.actions.map(
          (action) => _buildActionButton(action, colors),
        ),

        // Кнопка закрытия
        if (widget.config.showCloseButton) _buildCloseButton(colors),
      ],
    );
  }

  Widget _buildActionButton(ToastAction action, ToastColors colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            action.onPressed();
            if (widget.config.dismissible) {
              _dismiss();
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (action.color ?? colors.iconColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: action.color ?? colors.iconColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (action.icon != null) ...[
                  Icon(
                    action.icon,
                    size: 16,
                    color: action.color ?? colors.iconColor,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  action.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: action.color ?? colors.iconColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(ToastColors colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.config.dismissible ? _dismiss : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colors.textColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close,
              size: 18,
              color: colors.textColor.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(ToastColors colors) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          height: 3,
          decoration: BoxDecoration(
            color: colors.progressColor.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progressAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: colors.progressColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
