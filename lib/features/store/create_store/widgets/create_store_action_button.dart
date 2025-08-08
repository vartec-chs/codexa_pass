import 'package:codexa_pass/app/utils/animation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/utils/theme_utils.dart';
import '../../../../app/utils/responsive_utils.dart';
import '../create_store_control.dart';

class CreateStoreActionButton extends ConsumerStatefulWidget {
  const CreateStoreActionButton({super.key});

  @override
  ConsumerState<CreateStoreActionButton> createState() =>
      _CreateStoreActionButtonState();
}

class _CreateStoreActionButtonState
    extends ConsumerState<CreateStoreActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startPulseAnimation() {
    _animationController.repeat(reverse: true);
  }

  void _stopPulseAnimation() {
    _animationController.stop();
    _animationController.animateTo(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(createStoreControllerProvider);
        final controller = ref.read(createStoreControllerProvider.notifier);

        // Управляем анимацией в зависимости от состояния формы
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.isFormValid && !state.isLoading) {
            _startPulseAnimation();
          } else {
            _stopPulseAnimation();
          }
        });

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                ThemeUtils.getSurfaceColor(context).withOpacity(0.1),
                ThemeUtils.getSurfaceColor(context),
              ],
            ),
            boxShadow: ThemeUtils.getAdaptiveShadow(context, elevation: 8),
          ),
          child: SafeArea(
            child: Padding(
              padding: ResponsiveUtils.adaptivePadding(context),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: state.isFormValid
                        ? _pulseAnimation.value
                        : _scaleAnimation.value,
                    child: AnimatedContainer(
                      duration: AnimationConstants.normal,
                      curve: AnimationConstants.easeInOut,
                      child: SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.responsive(
                          context,
                          mobile: 56,
                          tablet: 60,
                          desktop: 64,
                        ),
                        child: FilledButton(
                          onPressed: state.isFormValid && !state.isLoading
                              ? () => controller.createStore()
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: state.isFormValid
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.12),
                            foregroundColor: state.isFormValid
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.38),
                            disabledBackgroundColor: state.isFormValid
                                ? null
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.12),
                            disabledForegroundColor: state.isFormValid
                                ? null
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.38),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.responsive(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 20,
                                ),
                              ),
                            ),
                            elevation: state.isFormValid ? 4 : 0,
                            shadowColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                          ),
                          child: AnimatedSwitcher(
                            duration: AnimationConstants.normal,
                            switchInCurve: AnimationConstants.easeOut,
                            switchOutCurve: AnimationConstants.easeOut,
                            child: state.isLoading
                                ? SizedBox(
                                    key: const ValueKey('loading'),
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                : Row(
                                    key: ValueKey(
                                      'button-${state.isFormValid}',
                                    ),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedSwitcher(
                                        duration: AnimationConstants.fast,
                                        child: Icon(
                                          state.isFormValid
                                              ? Icons.rocket_launch_rounded
                                              : Icons.info_outline_rounded,
                                          key: ValueKey(state.isFormValid),
                                          size: ResponsiveUtils.responsive(
                                            context,
                                            mobile: 20,
                                            tablet: 22,
                                            desktop: 24,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        state.isFormValid
                                            ? 'Создать хранилище'
                                            : 'Заполните все поля',
                                        style: GoogleFonts.inter(
                                          fontSize:
                                              ResponsiveUtils.adaptiveFontSize(
                                                context,
                                                16,
                                              ),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
