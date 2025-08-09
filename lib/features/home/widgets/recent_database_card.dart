import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recent_databases_section.dart';
import '../../../app/utils/theme_utils.dart';
import '../../../app/utils/animation_utils.dart';
import '../../../app/utils/responsive_utils.dart';

class RecentDatabaseCard extends StatefulWidget {
  final RecentDatabase database;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const RecentDatabaseCard({
    super.key,
    required this.database,
    required this.onTap,
    required this.onRemove,
  });

  @override
  State<RecentDatabaseCard> createState() => _RecentDatabaseCardState();
}

class _RecentDatabaseCardState extends State<RecentDatabaseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AnimationConstants.fast,
      vsync: this,
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: AnimationConstants.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: AnimationConstants.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: Material(
              color: Colors.transparent,
              elevation: _elevationAnimation.value,
              borderRadius: BorderRadius.circular(16),
              shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
              child: AnimatedColorContainer(
                color: _isHovered
                    ? ThemeUtils.getSurfaceColor(context, elevation: 4)
                    : ThemeUtils.getSurfaceColor(context, elevation: 2),
                borderRadius: BorderRadius.circular(16),
                duration: AnimationConstants.fast,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.responsive(
                        context,
                        mobile: 16.0,
                        tablet: 20.0,
                        desktop: 24.0,
                      ),
                    ),
                    constraints: BoxConstraints(
                      minHeight: ResponsiveUtils.responsive(
                        context,
                        mobile: 80.0,
                        tablet: 90.0,
                        desktop: 100.0,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isHovered
                            ? theme.colorScheme.primary.withOpacity(0.3)
                            : ThemeUtils.getBorderColor(context),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Иконка папки
                        TweenAnimationBuilder<Color?>(
                          tween: ColorTween(
                            begin: theme.colorScheme.primaryContainer,
                            end: _isHovered
                                ? theme.colorScheme.primary.withOpacity(0.2)
                                : theme.colorScheme.primaryContainer,
                          ),
                          duration: AnimationConstants.fast,
                          builder: (context, color, child) {
                            return Container(
                              width: ResponsiveUtils.responsive(
                                context,
                                mobile: 48.0,
                                tablet: 52.0,
                                desktop: 56.0,
                              ),
                              height: ResponsiveUtils.responsive(
                                context,
                                mobile: 48.0,
                                tablet: 52.0,
                                desktop: 56.0,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    color!,
                                    theme.colorScheme.secondaryContainer,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _isHovered
                                    ? ThemeUtils.getAdaptiveShadow(
                                        context,
                                        elevation: 4,
                                      )
                                    : [],
                              ),
                              child: Icon(
                                Icons.folder,
                                color: theme.colorScheme.primary,
                                size: ResponsiveUtils.responsive(
                                  context,
                                  mobile: 24.0,
                                  tablet: 26.0,
                                  desktop: 28.0,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: ResponsiveUtils.responsive(
                            context,
                            mobile: 12.0,
                            tablet: 16.0,
                            desktop: 20.0,
                          ),
                        ),
                        // Информация о базе данных
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.database.name,
                                style: ThemeUtils.getLabelStyle(
                                  context,
                                  fontSize: ResponsiveUtils.adaptiveFontSize(
                                    context,
                                    16,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: ResponsiveUtils.responsive(
                                  context,
                                  mobile: 4.0,
                                  tablet: 6.0,
                                  desktop: 8.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.responsive(
                                    context,
                                    mobile: 6.0,
                                    tablet: 8.0,
                                    desktop: 10.0,
                                  ),
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer
                                      .withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${widget.database.entriesCount} записей',
                                  style: GoogleFonts.inter(
                                    fontSize: ResponsiveUtils.adaptiveFontSize(
                                      context,
                                      11,
                                    ),
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ResponsiveUtils.responsive(
                                  context,
                                  mobile: 4.0,
                                  tablet: 6.0,
                                  desktop: 8.0,
                                ),
                              ),
                              Text(
                                _formatLastOpened(widget.database.lastOpened),
                                style: ThemeUtils.getSubtitleStyle(
                                  context,
                                  fontSize: ResponsiveUtils.adaptiveFontSize(
                                    context,
                                    12,
                                  ),
                                  opacity: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveUtils.responsive(
                            context,
                            mobile: 8.0,
                            tablet: 12.0,
                            desktop: 16.0,
                          ),
                        ),
                        // Кнопки действий
                        if (isDesktop)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildActionButton(
                                context: context,
                                icon: Icons.launch_rounded,
                                onPressed: widget.onTap,
                                tooltip: 'Открыть',
                                isPrimary: true,
                              ),
                              const SizedBox(width: 8),
                              _buildActionButton(
                                context: context,
                                icon: Icons.close_rounded,
                                onPressed: widget.onRemove,
                                tooltip: 'Удалить из недавних',
                                isPrimary: false,
                              ),
                            ],
                          )
                        else
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildActionButton(
                                context: context,
                                icon: Icons.launch_rounded,
                                onPressed: widget.onTap,
                                tooltip: 'Открыть',
                                isPrimary: true,
                              ),
                              const SizedBox(height: 4),
                              _buildActionButton(
                                context: context,
                                icon: Icons.close_rounded,
                                onPressed: widget.onRemove,
                                tooltip: 'Удалить из недавних',
                                isPrimary: false,
                                size: 16,
                                buttonSize: 28,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required bool isPrimary,
    double? size,
    double? buttonSize,
  }) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: isPrimary ? 0.6 : 0.4,
        end: _isHovered ? (isPrimary ? 1.0 : 0.8) : (isPrimary ? 0.8 : 0.6),
      ),
      duration: AnimationConstants.fast,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              size:
                  size ??
                  ResponsiveUtils.responsive(
                    context,
                    mobile: 18.0,
                    tablet: 20.0,
                    desktop: 22.0,
                  ),
              color: isPrimary
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            tooltip: tooltip,
            style: IconButton.styleFrom(
              backgroundColor: isPrimary
                  ? theme.colorScheme.primaryContainer.withOpacity(
                      _isHovered ? 0.8 : 0.5,
                    )
                  : theme.colorScheme.surfaceContainerHighest.withOpacity(
                      _isHovered ? 0.8 : 0.4,
                    ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isPrimary ? 10 : 8),
              ),
              minimumSize: Size(
                buttonSize ??
                    ResponsiveUtils.responsive(
                      context,
                      mobile: 32.0,
                      tablet: 36.0,
                      desktop: 40.0,
                    ),
                buttonSize ??
                    ResponsiveUtils.responsive(
                      context,
                      mobile: 32.0,
                      tablet: 36.0,
                      desktop: 40.0,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatLastOpened(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Только что';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ч назад';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн назад';
    } else {
      return '${dateTime.day}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
    }
  }
}
