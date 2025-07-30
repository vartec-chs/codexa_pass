import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/logger/app_logger.dart';
import '../setup_control.dart';

class SetupNavigationWidget extends ConsumerWidget {
  final VoidCallback? onComplete;

  const SetupNavigationWidget({super.key, this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Кнопка "Назад"
            _buildBackButton(context, setupState, controller, theme),

            const SizedBox(width: 16),

            // Пространство между кнопками
            const Expanded(child: SizedBox()),

            // Кнопка "Далее" / "Завершить"
            _buildNextButton(context, setupState, controller, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(
    BuildContext context,
    SetupState state,
    SetupController controller,
    ThemeData theme,
  ) {
    final canGoBack = state.canGoBack;

    return AnimatedOpacity(
      opacity: canGoBack ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: 120,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: canGoBack
              ? () {
                  logDebug('Back button pressed');
                  controller.previousStep();
                }
              : null,
          icon: const Icon(Icons.chevron_left, size: 20),
          label: const Text('Назад'),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.textTheme.bodyMedium?.color?.withOpacity(
              0.7,
            ),
            side: BorderSide(
              color: canGoBack ? theme.dividerColor : theme.disabledColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    SetupState state,
    SetupController controller,
    ThemeData theme,
  ) {
    final isLastStep = state.isLastStep;
    final canProceed = state.canGoNext;

    return SizedBox(
      width: 140,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: canProceed
            ? () {
                if (isLastStep) {
                  logInfo('Setup completion initiated');
                  controller.nextStep();
                  // Задержка для анимации завершения
                  Future.delayed(const Duration(milliseconds: 500), () {
                    onComplete?.call();
                  });
                } else {
                  logDebug('Next button pressed');
                  controller.nextStep();
                }
              }
            : null,
        icon: Icon(isLastStep ? Icons.check : Icons.chevron_right, size: 20),
        label: Text(isLastStep ? 'Завершить' : 'Далее'),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: canProceed ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: theme.disabledColor,
          disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(
            0.38,
          ),
        ),
      ),
    );
  }
}

/// Виджет для отображения прогресса настройки
class SetupProgressWidget extends ConsumerWidget {
  const SetupProgressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(setupControllerProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          // Текстовый индикатор прогресса
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Шаг ${setupState.currentStepIndex + 1} из ${setupState.totalSteps}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              Text(
                '${((setupState.currentStepIndex + 1) / setupState.totalSteps * 100).round()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Прогресс-бар
          _buildProgressBar(setupState),
        ],
      ),
    );
  }

  Widget _buildProgressBar(SetupState state) {
    final progress = (state.currentStepIndex + 1) / state.totalSteps;

    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Container(
          height: 6,
          decoration: BoxDecoration(
            color: theme.dividerColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Виджет заголовка setup с иконкой закрытия
class SetupHeaderWidget extends StatelessWidget {
  final VoidCallback? onClose;

  const SetupHeaderWidget({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Заголовок
            Expanded(
              child: Text(
                'Настройка приложения',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.headlineSmall?.color,
                ),
              ),
            ),

            // Кнопка закрытия (опционально)
            if (onClose != null)
              IconButton(
                onPressed: () {
                  logDebug('Setup close button pressed');
                  onClose!();
                },
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  foregroundColor: theme.textTheme.bodyMedium?.color
                      ?.withOpacity(0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
