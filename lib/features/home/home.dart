import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/action_buttons_section.dart';
import 'widgets/recent_databases_section.dart';
import 'widgets/animated_sliver_app_bar.dart';
import 'home_control.dart';
import '../../app/utils/animation_utils.dart';
import '../../app/utils/responsive_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _fadeController = AnimationController(
      duration: AnimationConstants.normal,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: AnimationConstants.easeOut,
    );

    // Запускаем анимацию появления
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  void _onScroll() {
    final newOffset = _scrollController.offset;
    if (newOffset != _scrollOffset) {
      // Используем addPostFrameCallback для избежания setState во время build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && newOffset != _scrollOffset) {
          setState(() {
            _scrollOffset = newOffset;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeActions = ref.watch(homeActionsProvider);
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final maxWidth = ResponsiveUtils.getMaxContentWidth(context);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Анимированная закрепленная шапка
                AnimatedSliverAppBar(
                  scrollController: _scrollController,
                  isDesktop: isDesktop,
                ),

                // Основной контент с анимациями и легким параллакс эффектом
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    left: ResponsiveUtils.adaptivePadding(context).left,
                    right: ResponsiveUtils.adaptivePadding(context).right,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        (_scrollOffset * 0.05).clamp(-20.0, 20.0),
                      ),
                      child: AnimatedAppearance(
                        delay: const Duration(milliseconds: 200),
                        child: ActionButtonsSection(homeActions: homeActions),
                      ),
                    ),
                  ),
                ),

                // Отступ после кнопок действий
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: ResponsiveUtils.responsive(
                      context,
                      mobile: 32.0,
                      tablet: 40.0,
                      desktop: 48.0,
                    ),
                  ),
                ),

                // Секция с недавними базами данных с анимацией и легким параллакс эффектом
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      (_scrollOffset * 0.02).clamp(-10.0, 10.0),
                    ),
                    child: AnimatedAppearance(
                      delay: const Duration(milliseconds: 400),
                      child: const SizedBox.shrink(),
                    ),
                  ),
                ),

                RecentDatabasesSection(homeActions: homeActions),

                // Адаптивный отступ внизу для комфортной прокрутки
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: ResponsiveUtils.responsive(
                      context,
                      mobile: 100.0,
                      tablet: 120.0,
                      desktop: 150.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
