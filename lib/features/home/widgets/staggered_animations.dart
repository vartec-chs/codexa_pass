import 'package:flutter/material.dart';
import '../../../app/utils/animation_utils.dart';

/// Виджет для создания каскадной анимации появления элементов
class StaggeredAnimationList extends StatefulWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration staggerDelay;
  final Axis direction;

  const StaggeredAnimationList({
    super.key,
    required this.children,
    this.delay = Duration.zero,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.direction = Axis.vertical,
  });

  @override
  State<StaggeredAnimationList> createState() => _StaggeredAnimationListState();
}

class _StaggeredAnimationListState extends State<StaggeredAnimationList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startStaggeredAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) =>
          AnimationController(duration: AnimationConstants.normal, vsync: this),
    );

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: AnimationConstants.easeOut),
      );
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: widget.direction == Axis.vertical
            ? const Offset(0, 0.3)
            : const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: AnimationConstants.easeOut),
      );
    }).toList();
  }

  void _startStaggeredAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(
        widget.delay +
            Duration(milliseconds: i * widget.staggerDelay.inMilliseconds),
        () {
          if (mounted) {
            _controllers[i].forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimations[index],
              child: SlideTransition(
                position: _slideAnimations[index],
                child: widget.children[index],
              ),
            );
          },
        );
      }),
    );
  }
}

/// Виджет для параллакс эффекта при прокрутке
class ParallaxWidget extends StatelessWidget {
  final Widget child;
  final double offset;
  final double intensity;

  const ParallaxWidget({
    super.key,
    required this.child,
    this.offset = 0.0,
    this.intensity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offset * intensity),
      child: child,
    );
  }
}

/// Виджет для создания пульсирующей анимации
class PulsingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulsingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  State<PulsingWidget> createState() => _PulsingWidgetState();
}

class _PulsingWidgetState extends State<PulsingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: widget.child);
      },
    );
  }
}
