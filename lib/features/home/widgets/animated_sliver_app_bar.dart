import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/utils/theme_utils.dart';
import '../../../app/utils/animation_utils.dart';

class AnimatedSliverAppBar extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDesktop;

  const AnimatedSliverAppBar({
    super.key,
    required this.scrollController,
    this.isDesktop = false,
  });

  @override
  State<AnimatedSliverAppBar> createState() => _AnimatedSliverAppBarState();
}

class _AnimatedSliverAppBarState extends State<AnimatedSliverAppBar>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late Animation<double> _headerOpacityAnimation;
  late Animation<double> _headerScaleAnimation;

  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();

    _headerAnimationController = AnimationController(
      duration: AnimationConstants.fast,
      vsync: this,
    );

    _headerOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: AnimationConstants.easeInOut,
      ),
    );

    _headerScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: AnimationConstants.easeOut,
      ),
    );

    widget.scrollController.addListener(_onScroll);

    // Запускаем анимацию появления
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerAnimationController.forward();
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = widget.scrollController.offset;
    final shouldCollapse = offset > 100;

    if (shouldCollapse != _isCollapsed) {
      // Используем addPostFrameCallback для избежания setState во время build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && shouldCollapse != _isCollapsed) {
          setState(() {
            _isCollapsed = shouldCollapse;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;
          final isCollapsed = top <= kToolbarHeight + 50;

          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            background: AnimatedBuilder(
              animation: _headerAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _headerOpacityAnimation,
                  child: ScaleTransition(
                    scale: _headerScaleAnimation,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                      child: _buildExpandedHeader(context),
                    ),
                  ),
                );
              },
            ),
            title: AnimatedOpacity(
              opacity: isCollapsed ? 1.0 : 0.0,
              duration: AnimationConstants.fast,
              child: _buildCollapsedHeader(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpandedHeader(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final isSmallHeight = availableHeight < 120;

        return Container(
          height: availableHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Row(
                  children: [
                    AnimatedAppearance(
                      delay: const Duration(milliseconds: 100),
                      child: Container(
                        padding: EdgeInsets.all(isSmallHeight ? 8 : 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            isSmallHeight ? 12 : 16,
                          ),
                          boxShadow: ThemeUtils.getAdaptiveShadow(
                            context,
                            elevation: 4,
                          ),
                        ),
                        child: Icon(
                          Icons.security,
                          color: theme.colorScheme.onPrimary,
                          size: isSmallHeight ? 20 : 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AnimatedAppearance(
                        delay: const Duration(milliseconds: 200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'CodeXa Pass',
                              style: GoogleFonts.inter(
                                fontSize: isSmallHeight ? 20 : 28,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (!isSmallHeight) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Менеджер паролей',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    AnimatedAppearance(
                      delay: const Duration(milliseconds: 300),
                      child: IconButton(
                        onPressed: () {
                          // TODO: Открыть настройки
                        },
                        icon: Icon(
                          Icons.settings_outlined,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: theme
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSmallHeight) ...[
                const SizedBox(height: 16),
                AnimatedAppearance(
                  delay: const Duration(milliseconds: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Добро пожаловать!',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Выберите действие или откройте недавнее хранилище',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCollapsedHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.security,
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'CodeXa Pass',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // TODO: Открыть настройки
            },
            icon: Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(36, 36),
              maximumSize: const Size(36, 36),
            ),
          ),
        ],
      ),
    );
  }
}
