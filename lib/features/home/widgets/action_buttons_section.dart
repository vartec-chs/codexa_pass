import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_control.dart';
import '../../../app/utils/animation_utils.dart';
import '../../../app/utils/theme_utils.dart';
import '../../../app/utils/responsive_utils.dart';

class ActionButtonsSection extends StatelessWidget {
  final HomeActions homeActions;

  const ActionButtonsSection({super.key, required this.homeActions});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedAppearance(
          delay: const Duration(milliseconds: 100),
          child: Text(
            'Действия',
            style: ThemeUtils.getHeadingStyle(
              context,
              fontSize: ResponsiveUtils.adaptiveFontSize(context, 20),
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.responsive(
            context,
            mobile: 16.0,
            tablet: 20.0,
            desktop: 24.0,
          ),
        ),
        // Адаптивная сетка для кнопок
        isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Builder(
      builder: (context) => Row(
        children: [
          Expanded(
            child: AnimatedAppearance(
              delay: const Duration(milliseconds: 200),
              child: _ActionButton(
                icon: Icons.add_circle_outline,
                title: 'Создать хранилище',
                subtitle: 'Новая база данных',
                color: Theme.of(context).colorScheme.primary,
                onTap: () => homeActions.createNewDatabase(context),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedAppearance(
              delay: const Duration(milliseconds: 300),
              child: _ActionButton(
                icon: Icons.folder_open_outlined,
                title: 'Открыть',
                subtitle: 'Существующая база',
                color: Theme.of(context).colorScheme.secondary,
                onTap: () => homeActions.openExistingDatabase(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Builder(
      builder: (context) => Row(
        children: [
          Expanded(
            flex: 2,
            child: AnimatedAppearance(
              delay: const Duration(milliseconds: 200),
              child: _ActionButton(
                icon: Icons.add_circle_outline,
                title: 'Создать хранилище',
                subtitle: 'Новая база данных',
                color: Theme.of(context).colorScheme.primary,
                onTap: () => homeActions.createNewDatabase(context),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: AnimatedAppearance(
              delay: const Duration(milliseconds: 300),
              child: _ActionButton(
                icon: Icons.folder_open_outlined,
                title: 'Открыть',
                subtitle: 'Существующая база',
                color: Theme.of(context).colorScheme.secondary,
                onTap: () => homeActions.openExistingDatabase(context),
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ), // Пустое пространство для баланса
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: AnimationConstants.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: AnimationConstants.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _resetAnimation();
  }

  void _onTapCancel() {
    _resetAnimation();
  }

  void _resetAnimation() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final buttonPadding = ResponsiveUtils.responsive(
      context,
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedColorContainer(
              color: _isPressed
                  ? widget.color.withOpacity(0.05)
                  : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
              duration: AnimationConstants.fast,
              child: Container(
                padding: EdgeInsets.all(buttonPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
                  border: Border.all(
                    color: widget.color.withOpacity(_isPressed ? 0.3 : 0.2),
                    width: 1,
                  ),
                  boxShadow: _isPressed
                      ? ThemeUtils.getAdaptiveShadow(context, elevation: 8)
                      : ThemeUtils.getAdaptiveShadow(context, elevation: 4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Исправляет переполнение
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.1, end: _isPressed ? 0.2 : 0.1),
                      duration: AnimationConstants.fast,
                      builder: (context, value, child) {
                        return Container(
                          padding: EdgeInsets.all(isDesktop ? 16 : 12),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(value),
                            borderRadius: BorderRadius.circular(
                              isDesktop ? 16 : 12,
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: isDesktop ? 28 : 24,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: isDesktop ? 20 : 16),
                    Flexible(
                      // Исправляет переполнение текста
                      child: Text(
                        widget.title,
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveUtils.adaptiveFontSize(
                            context,
                            16,
                          ),
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 6 : 4),
                    Flexible(
                      // Исправляет переполнение подзаголовка
                      child: Text(
                        widget.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveUtils.adaptiveFontSize(
                            context,
                            12,
                          ),
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
