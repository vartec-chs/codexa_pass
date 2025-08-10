import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../app/logger/app_logger.dart';
import 'setup_control.dart';
import 'widgets/welcome_setup_widget.dart';
import 'widgets/theme_setup_widget.dart';
import 'widgets/setup_navigation_widget.dart';

class SetupScreen extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const SetupScreen({super.key, this.onComplete});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _lastSyncedStep = 0;

  @override
  void initState() {
    super.initState();
    logInfo('Setup screen initialized');

    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(setupControllerProvider);

    // Синхронизируем PageController только если изменился шаг
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncPageController(setupState);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Заголовок с прогрессом - фиксированный
              _buildHeader(setupState),
        
              // Основной контент с прокруткой
              Expanded(
                child: Column(
                  children: [
                    // Индикатор страниц - фиксированный
                    _buildPageIndicator(setupState),
        
                    // Контент страниц с прокруткой
                    Expanded(child: _buildScrollablePageView(setupState)),
                  ],
                ),
              ),
        
              // Навигационные кнопки - фиксированные
              _buildNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  /// Синхронизация PageController с состоянием (вызывается в PostFrameCallback)
  void _syncPageController(SetupState setupState) {
    if (_pageController.hasClients &&
        _lastSyncedStep != setupState.currentStepIndex) {
      final targetPage = setupState.currentStepIndex;
      final currentPage = _pageController.page?.round() ?? 0;

      if (currentPage != targetPage) {
        _pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _lastSyncedStep = targetPage;
      }
    }
  }

  Widget _buildHeader(SetupState setupState) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const SetupHeaderWidget(),
    );
  }

  Widget _buildPageIndicator(SetupState setupState) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SmoothPageIndicator(
        controller: _pageController,
        count: setupState.totalSteps,
        effect: ExpandingDotsEffect(
          dotHeight: 12,
          dotWidth: 12,
          expansionFactor: 3,
          spacing: 8,
          activeDotColor: theme.primaryColor,
          dotColor: theme.dividerColor,
        ),
        onDotClicked: (index) {
          logDebug('Page indicator dot clicked: $index');
          final controller = ref.read(setupControllerProvider.notifier);

          // Определяем целевой шаг по индексу
          SetupStep? targetStep;
          switch (index) {
            case 0:
              targetStep = SetupStep.welcome;
              break;
            case 1:
              targetStep = SetupStep.theme;
              break;
          }

          if (targetStep != null) {
            controller.goToStep(targetStep);
          }
        },
      ),
    );
  }

  /// Построить прокручиваемый PageView с контентом
  Widget _buildScrollablePageView(SetupState setupState) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        logDebug('Page changed to index: $index');
        _lastSyncedStep = index;

        final controller = ref.read(setupControllerProvider.notifier);

        // Синхронизируем индекс страницы с состоянием
        SetupStep? targetStep;
        switch (index) {
          case 0:
            targetStep = SetupStep.welcome;
            break;
          case 1:
            targetStep = SetupStep.theme;
            break;
        }

        if (targetStep != null && targetStep != setupState.currentStep) {
          controller.goToStep(targetStep);
        }
      },
      children: [
        // Страница приветствия с прокруткой
        _buildScrollablePage(const WelcomeSetupWidget()),

        // Страница выбора темы с прокруткой
        _buildScrollablePage(const ThemeSetupWidget()),

        // Здесь можно легко добавить новые страницы:
        // _buildScrollablePage(const SecuritySetupWidget()),
        // _buildScrollablePage(const LanguageSetupWidget()),
        // _buildScrollablePage(const CompleteSetupWidget()),
      ],
    );
  }

  /// Обернуть страницу в прокручиваемый контейнер
  Widget _buildScrollablePage(Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: IntrinsicHeight(child: child),
      ),
    );
  }

  Widget _buildNavigation() {
    return SetupNavigationWidget(
      onComplete: () {
        logInfo('Setup completed, calling onComplete callback');
        widget.onComplete?.call();
      },
    );
  }
}
