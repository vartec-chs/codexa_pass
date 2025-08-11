import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/snack_bar_animation_config.dart';

/// Анимированный контейнер для SnackBar
class AnimatedSnackBarContainer extends StatefulWidget {
  final Widget child;
  final SnackBarAnimationConfig animationConfig;
  final VoidCallback? onAnimationCompleted;

  const AnimatedSnackBarContainer({
    super.key,
    required this.child,
    required this.animationConfig,
    this.onAnimationCompleted,
  });

  @override
  State<AnimatedSnackBarContainer> createState() =>
      _AnimatedSnackBarContainerState();
}

class _AnimatedSnackBarContainerState extends State<AnimatedSnackBarContainer>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _exitController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    // Контроллеры анимации
    _entryController = AnimationController(
      duration: widget.animationConfig.entryDuration,
      vsync: this,
    );

    _exitController = AnimationController(
      duration: widget.animationConfig.exitDuration,
      vsync: this,
    );

    // Анимация масштабирования
    _scaleAnimation =
        Tween<double>(
          begin: widget.animationConfig.initialScale,
          end: widget.animationConfig.finalScale,
        ).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: widget.animationConfig.entryCurve,
          ),
        );

    // Анимация прозрачности
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeIn));

    // Анимация скольжения
    _slideAnimation = _createSlideAnimation();

    // Слушатель завершения анимации
    _entryController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationCompleted?.call();
      }
    });
  }

  Animation<Offset> _createSlideAnimation() {
    Offset beginOffset;

    switch (widget.animationConfig.slideDirection) {
      case SlideDirection.top:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case SlideDirection.bottom:
        beginOffset = const Offset(0.0, 1.0);
        break;
      case SlideDirection.left:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.right:
        beginOffset = const Offset(1.0, 0.0);
        break;
    }

    return Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: widget.animationConfig.entryCurve,
      ),
    );
  }

  void _startEntryAnimation() {
    if (widget.animationConfig.enabled) {
      _entryController.forward();
    } else {
      _entryController.value = 1.0;
      widget.onAnimationCompleted?.call();
    }
  }

  void startExitAnimation() {
    if (widget.animationConfig.enabled) {
      _exitController.forward();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animationConfig.enabled) {
      return widget.child;
    }

    Widget animatedChild = widget.child;

    // Применяем анимации в зависимости от настроек
    if (widget.animationConfig.scaleAnimation) {
      animatedChild = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: animatedChild,
      );
    }

    if (widget.animationConfig.slideAnimation) {
      animatedChild = AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return SlideTransition(position: _slideAnimation, child: child);
        },
        child: animatedChild,
      );
    }

    if (widget.animationConfig.fadeAnimation) {
      animatedChild = AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(opacity: _fadeAnimation, child: child);
        },
        child: animatedChild,
      );
    }

    if (widget.animationConfig.bounceAnimation) {
      animatedChild = AnimatedBuilder(
        animation: _entryController,
        builder: (context, child) {
          final bounceValue = Curves.elasticOut.transform(
            _entryController.value,
          );
          return Transform.scale(scale: bounceValue, child: child);
        },
        child: animatedChild,
      );
    }

    return animatedChild;
  }
}

/// Анимированный кастомный SnackBar
class AnimatedCustomSnackBar extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final SnackBarAnimationConfig animationConfig;
  final bool enableBlur;
  final double blurRadius;
  final Color? shadowColor;
  final LinearGradient? gradient;
  final Color? borderColor;

  const AnimatedCustomSnackBar({
    super.key,
    required this.content,
    required this.backgroundColor,
    this.elevation = 8.0,
    this.margin = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.animationConfig = const SnackBarAnimationConfig(),
    this.enableBlur = false,
    this.blurRadius = 10.0,
    this.shadowColor,
    this.gradient,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget snackBarContent = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.black.withOpacity(0.15),
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: enableBlur
          ? ClipRRect(
              borderRadius: borderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurRadius,
                  sigmaY: blurRadius,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.8),
                    borderRadius: borderRadius,
                  ),
                  child: content,
                ),
              ),
            )
          : content,
    );

    return AnimatedSnackBarContainer(
      animationConfig: animationConfig,
      child: snackBarContent,
    );
  }
}
