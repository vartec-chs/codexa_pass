import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Переиспользуемый компонент для подтверждения действий свайпом
///
/// Пример использования:
/// ```dart
/// SwipeButton(
///   onSwipeComplete: () => print('Действие подтверждено!'),
///   text: 'Свайпните для подтверждения',
///   icon: Icons.check,
/// )
/// ```
class SwipeButton extends StatefulWidget {
  /// Коллбек, который вызывается при успешном завершении свайпа
  final VoidCallback onSwipeComplete;

  /// Текст на кнопке
  final String text;

  /// Иконка на кнопке
  final IconData icon;

  /// Ширина кнопки
  final double? width;

  /// Высота кнопки
  final double height;

  /// Цвет фона кнопки
  final Color? backgroundColor;

  /// Цвет слайдера
  final Color? sliderColor;

  /// Цвет текста
  final Color? textColor;

  /// Цвет иконки
  final Color? iconColor;

  /// Радиус скругления
  final double borderRadius;

  /// Радиус скругления слайдера (если null, используется borderRadius - borderWidth)
  final double? sliderBorderRadius;

  /// Толщина границы
  final double borderWidth;

  /// Цвет границы
  final Color? borderColor;

  /// Включена ли кнопка
  final bool enabled;

  /// Показывать ли анимацию успеха
  final bool showSuccessAnimation;

  /// Длительность анимации
  final Duration animationDuration;

  /// Тип анимации
  final SwipeButtonAnimationType animationType;

  /// Минимальный процент свайпа для активации (0.0 - 1.0)
  final double threshold;

  /// Показывать ли стрелки-подсказки
  final bool showArrows;

  /// Размер иконки
  final double iconSize;

  /// Размер текста
  final double fontSize;

  const SwipeButton({
    super.key,
    required this.onSwipeComplete,
    this.text = 'Свайпните для подтверждения',
    this.icon = Icons.arrow_forward,
    this.width,
    this.height = 60.0,
    this.backgroundColor,
    this.sliderColor,
    this.textColor,
    this.iconColor,
    this.borderRadius = 30.0,
    this.sliderBorderRadius,
    this.borderWidth = 2.0,
    this.borderColor,
    this.enabled = true,
    this.showSuccessAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationType = SwipeButtonAnimationType.slide,
    this.threshold = 0.85,
    this.showArrows = true,
    this.iconSize = 24.0,
    this.fontSize = 16.0,
  });

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _successController;
  late AnimationController _arrowController;
  late Animation<double> _slideAnimation;
  late Animation<double> _successAnimation;
  late Animation<double> _arrowAnimation;

  double _dragPosition = 0.0;
  bool _isDragging = false;
  bool _isCompleted = false;
  late double _maxSlide;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _successController = AnimationController(
      duration: Duration(
        milliseconds: widget.animationDuration.inMilliseconds * 2,
      ),
      vsync: this,
    );

    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _successAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    _arrowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    // Запускаем анимацию стрелок
    if (widget.showArrows && widget.enabled) {
      _arrowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _successController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.enabled || _isCompleted) return;

    setState(() {
      _isDragging = true;
    });

    _arrowController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.enabled || _isCompleted) return;

    setState(() {
      _dragPosition += details.delta.dx;
      _dragPosition = _dragPosition.clamp(0.0, _maxSlide);
    });

    // Обновляем анимацию слайда
    _slideController.value = _dragPosition / _maxSlide;
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.enabled || _isCompleted) return;

    final progress = _dragPosition / _maxSlide;

    if (progress >= widget.threshold) {
      _completeSwipe();
    } else {
      _resetSwipe();
    }
  }

  void _completeSwipe() async {
    setState(() {
      _isCompleted = true;
      _isDragging = false;
    });

    // Анимируем до конца
    await _slideController.animateTo(1.0);

    if (widget.showSuccessAnimation) {
      await _successController.forward();

      // Добавляем тактильную обратную связь
      HapticFeedback.heavyImpact();
    }

    // Вызываем коллбек
    widget.onSwipeComplete();
  }

  void _resetSwipe() async {
    setState(() {
      _isDragging = false;
    });

    // Анимируем возврат в исходное положение
    await _slideController.animateTo(0.0);

    setState(() {
      _dragPosition = 0.0;
    });

    // Возобновляем анимацию стрелок
    if (widget.showArrows && widget.enabled) {
      _arrowController.repeat(reverse: true);
    }
  }

  /// Сбрасывает состояние кнопки
  void reset() {
    setState(() {
      _isCompleted = false;
      _isDragging = false;
      _dragPosition = 0.0;
    });

    _slideController.reset();
    _successController.reset();

    if (widget.showArrows && widget.enabled) {
      _arrowController.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Определяем цвета
    final backgroundColor =
        widget.backgroundColor ?? colorScheme.surface.withOpacity(0.1);
    final sliderColor = widget.sliderColor ?? colorScheme.primary;
    final textColor = widget.textColor ?? colorScheme.onSurface;
    final iconColor = widget.iconColor ?? colorScheme.onPrimary;
    final borderColor =
        widget.borderColor ?? colorScheme.outline.withOpacity(0.3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.width ?? constraints.maxWidth;
        _maxSlide = width - widget.height - (widget.borderWidth * 2);

        return AnimatedBuilder(
          animation: Listenable.merge([
            _slideAnimation,
            _successAnimation,
            _arrowAnimation,
          ]),
          builder: (context, child) {
            return Container(
              width: width,
              height: widget.height,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: borderColor,
                  width: widget.borderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Stack(
                  children: [
                    // Заполнение заднего фона при свайпе
                    _buildProgressFill(sliderColor),

                    // Фоновый текст и стрелки
                    _buildBackground(textColor),

                    // Слайдер
                    _buildSlider(sliderColor, iconColor),

                    // Анимация успеха
                    if (_isCompleted && widget.showSuccessAnimation)
                      _buildSuccessOverlay(colorScheme),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProgressFill(Color sliderColor) {
    final progress = _isDragging
        ? _dragPosition / _maxSlide
        : _slideAnimation.value;

    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: _isDragging ? Duration.zero : widget.animationDuration,
        curve: Curves.easeOut,
        width: (widget.height + (_maxSlide * progress)).clamp(
          0.0,
          double.infinity,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              sliderColor.withOpacity(0.1),
              sliderColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }

  Widget _buildBackground(Color textColor) {
    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Левые стрелки
          if (widget.showArrows && !_isCompleted)
            Opacity(
              opacity: 0.6 + (_arrowAnimation.value * 0.4),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: textColor.withOpacity(0.5),
                size: widget.iconSize,
              ),
            ),

          if (widget.showArrows && !_isCompleted) const SizedBox(width: 4),

          // Текст
          Flexible(
            child: Text(
              _isCompleted ? 'Подтверждено!' : widget.text,
              style: TextStyle(
                color: textColor.withOpacity(_isCompleted ? 0.8 : 0.6),
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (widget.showArrows && !_isCompleted) const SizedBox(width: 4),

          // Правые стрелки
          if (widget.showArrows && !_isCompleted)
            Opacity(
              opacity: 0.6 + (_arrowAnimation.value * 0.4),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: textColor.withOpacity(0.5),
                size: widget.iconSize,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlider(Color sliderColor, Color iconColor) {
    final slidePosition = _isDragging
        ? _dragPosition
        : _slideAnimation.value * _maxSlide;

    final sliderRadius =
        widget.sliderBorderRadius ??
        (widget.borderRadius - widget.borderWidth).clamp(0.0, double.infinity);

    return Positioned(
      left: slidePosition,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Container(
            width: widget.height - (widget.borderWidth * 2),
            height: widget.height - (widget.borderWidth * 2),
            decoration: BoxDecoration(
              color: sliderColor,
              borderRadius: BorderRadius.circular(sliderRadius),
              boxShadow: [
                BoxShadow(
                  color: sliderColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _isCompleted ? Icons.check : widget.icon,
                color: iconColor,
                size: widget.iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessOverlay(ColorScheme colorScheme) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.primary.withOpacity(0.2),
            ],
          ),
        ),
        child: Center(
          child: Transform.scale(
            scale: _successAnimation.value,
            child: Icon(
              Icons.check_circle,
              color: colorScheme.primary,
              size: widget.iconSize * 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Типы анимации для SwipeButton
enum SwipeButtonAnimationType {
  /// Простое скольжение
  slide,

  /// Скольжение с пульсацией
  pulse,

  /// Скольжение с волновым эффектом
  wave,
}

/// Стили для различных случаев использования
class SwipeButtonStyles {
  static SwipeButton danger({required VoidCallback onSwipeComplete}) =>
      SwipeButton(
        onSwipeComplete: onSwipeComplete,
        backgroundColor: const Color(0xFFFFEBEE),
        sliderColor: const Color(0xFFD32F2F),
        textColor: const Color(0xFFD32F2F),
        borderColor: const Color(0xFFD32F2F),
        icon: Icons.delete,
        text: 'Свайпните для удаления',
        borderRadius: 30.0,
        sliderBorderRadius: 25.0,
      );

  static SwipeButton success({required VoidCallback onSwipeComplete}) =>
      SwipeButton(
        onSwipeComplete: onSwipeComplete,
        backgroundColor: const Color(0xFFE8F5E8),
        sliderColor: const Color(0xFF4CAF50),
        textColor: const Color(0xFF2E7D32),
        borderColor: const Color(0xFF4CAF50),
        icon: Icons.check,
        text: 'Свайпните для подтверждения',
        borderRadius: 30.0,
        sliderBorderRadius: 25.0,
      );

  static SwipeButton warning({required VoidCallback onSwipeComplete}) =>
      SwipeButton(
        onSwipeComplete: onSwipeComplete,
        backgroundColor: const Color(0xFFFFF8E1),
        sliderColor: const Color(0xFFFF9800),
        textColor: const Color(0xFFE65100),
        borderColor: const Color(0xFFFF9800),
        icon: Icons.warning,
        text: 'Свайпните для продолжения',
        borderRadius: 30.0,
        sliderBorderRadius: 25.0,
      );

  static SwipeButton info({required VoidCallback onSwipeComplete}) =>
      SwipeButton(
        onSwipeComplete: onSwipeComplete,
        backgroundColor: const Color(0xFFE3F2FD),
        sliderColor: const Color(0xFF2196F3),
        textColor: const Color(0xFF1565C0),
        borderColor: const Color(0xFF2196F3),
        icon: Icons.info,
        text: 'Свайпните для информации',
        borderRadius: 30.0,
        sliderBorderRadius: 25.0,
      );
}

/// Расширенный SwipeButton с дополнительными функциями
class AdvancedSwipeButton extends StatefulWidget {
  final VoidCallback onSwipeComplete;
  final String text;
  final IconData icon;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? sliderColor;
  final Color? textColor;
  final Color? iconColor;
  final double borderRadius;
  final double threshold;
  final bool enabled;
  final bool requiresDoubleConfirmation;
  final Duration timeoutDuration;
  final VoidCallback? onTimeout;

  const AdvancedSwipeButton({
    super.key,
    required this.onSwipeComplete,
    this.text = 'Свайпните для подтверждения',
    this.icon = Icons.arrow_forward,
    this.width,
    this.height = 60.0,
    this.backgroundColor,
    this.sliderColor,
    this.textColor,
    this.iconColor,
    this.borderRadius = 30.0,
    this.threshold = 0.85,
    this.enabled = true,
    this.requiresDoubleConfirmation = false,
    this.timeoutDuration = const Duration(seconds: 30),
    this.onTimeout,
  });

  @override
  State<AdvancedSwipeButton> createState() => _AdvancedSwipeButtonState();
}

class _AdvancedSwipeButtonState extends State<AdvancedSwipeButton>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  bool _firstSwipeCompleted = false;
  bool _isTimedOut = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: widget.timeoutDuration,
      vsync: this,
    );

    if (widget.enabled) {
      _startTimeout();
    }
  }

  void _startTimeout() {
    _progressController.forward().then((_) {
      if (mounted && !_isTimedOut) {
        setState(() {
          _isTimedOut = true;
        });
        widget.onTimeout?.call();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _handleSwipeComplete() {
    if (widget.requiresDoubleConfirmation && !_firstSwipeCompleted) {
      setState(() {
        _firstSwipeCompleted = true;
      });

      // Перезапускаем таймер для второго подтверждения
      _progressController.reset();
      _startTimeout();
    } else {
      widget.onSwipeComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isTimedOut) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: const Center(
          child: Text(
            'Время истекло',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Stack(
      children: [
        SwipeButton(
          onSwipeComplete: _handleSwipeComplete,
          text: _firstSwipeCompleted ? 'Подтвердите еще раз' : widget.text,
          icon: widget.icon,
          width: widget.width,
          height: widget.height,
          backgroundColor: widget.backgroundColor,
          sliderColor: widget.sliderColor,
          textColor: widget.textColor,
          iconColor: widget.iconColor,
          borderRadius: widget.borderRadius,
          threshold: widget.threshold,
          enabled: widget.enabled && !_isTimedOut,
        ),

        // Индикатор прогресса таймера
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressController.value,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.red.withOpacity(0.3),
                ),
                minHeight: 2,
              );
            },
          ),
        ),
      ],
    );
  }
}
