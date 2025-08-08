import 'package:flutter/material.dart';

/// Константы для анимаций
class AnimationConstants {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration verySlow = Duration(milliseconds: 500);

  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;
}

/// Миксин для добавления анимаций к виджетам
mixin AnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: AnimationConstants.normal,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: AnimationConstants.normal,
      vsync: this,
    );

    _slideController = AnimationController(
      duration: AnimationConstants.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: AnimationConstants.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: AnimationConstants.easeOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: AnimationConstants.easeOut,
          ),
        );
  }

  void startAnimations() {
    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Animation<double> get fadeAnimation => _fadeAnimation;
  Animation<double> get scaleAnimation => _scaleAnimation;
  Animation<Offset> get slideAnimation => _slideAnimation;
}

/// Виджет для анимированного появления
class AnimatedAppearance extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final bool slideFromBottom;

  const AnimatedAppearance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AnimationConstants.normal,
    this.curve = AnimationConstants.easeOut,
    this.slideFromBottom = true,
  });

  @override
  State<AnimatedAppearance> createState() => _AnimatedAppearanceState();
}

class _AnimatedAppearanceState extends State<AnimatedAppearance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _slideAnimation = Tween<Offset>(
      begin: widget.slideFromBottom
          ? const Offset(0, 0.3)
          : const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// Виджет для плавного изменения высоты
class AnimatedHeightContainer extends StatelessWidget {
  final Widget child;
  final bool show;
  final Duration duration;
  final Curve curve;

  const AnimatedHeightContainer({
    super.key,
    required this.child,
    required this.show,
    this.duration = AnimationConstants.normal,
    this.curve = AnimationConstants.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: const SizedBox.shrink(),
      crossFadeState: show
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: duration,
      firstCurve: curve,
      secondCurve: curve,
      sizeCurve: curve,
    );
  }
}

/// Виджет для анимированного изменения цвета контейнера
class AnimatedColorContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final Duration duration;
  final Curve curve;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Border? border;

  const AnimatedColorContainer({
    super.key,
    required this.child,
    required this.color,
    this.duration = AnimationConstants.fast,
    this.curve = AnimationConstants.easeInOut,
    this.borderRadius,
    this.padding,
    this.margin,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: border,
      ),
      child: child,
    );
  }
}
