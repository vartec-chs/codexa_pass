import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../../app/logger/app_logger.dart';
import '../../app/utils/snack_bar_message.dart';
import '../../app/theme/theme_provider.dart';

/// Состояния экрана настройки
enum SetupStep {
  welcome,
  theme,
  // Здесь можно легко добавить новые шаги:
  // security,
  // language,
  // complete,
}

/// Состояние настройки приложения
class SetupState {
  final SetupStep currentStep;
  final ThemeMode selectedTheme;
  final bool isCompleted;
  final int totalSteps;

  const SetupState({
    this.currentStep = SetupStep.welcome,
    this.selectedTheme = ThemeMode.system,
    this.isCompleted = false,
    this.totalSteps = 2,
  });

  SetupState copyWith({
    SetupStep? currentStep,
    ThemeMode? selectedTheme,
    bool? isCompleted,
    int? totalSteps,
  }) {
    return SetupState(
      currentStep: currentStep ?? this.currentStep,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      isCompleted: isCompleted ?? this.isCompleted,
      totalSteps: totalSteps ?? this.totalSteps,
    );
  }

  /// Получить индекс текущего шага
  int get currentStepIndex {
    switch (currentStep) {
      case SetupStep.welcome:
        return 0;
      case SetupStep.theme:
        return 1;
    }
  }

  /// Проверить, можно ли перейти к следующему шагу
  bool get canGoNext {
    switch (currentStep) {
      case SetupStep.welcome:
        return true; // Всегда можно перейти с приветственного экрана
      case SetupStep.theme:
        return true; // Тема может быть выбрана по умолчанию
    }
  }

  /// Проверить, можно ли вернуться к предыдущему шагу
  bool get canGoBack => currentStepIndex > 0;

  /// Проверить, является ли текущий шаг последним
  bool get isLastStep => currentStepIndex >= totalSteps - 1;
}

/// Контроллер для управления процессом настройки
class SetupController extends StateNotifier<SetupState> {
  final Ref _ref;

  SetupController(this._ref) : super(const SetupState()) {
    logInfo('Setup controller initialized');
    _initializeWithCurrentTheme();
  }

  /// Инициализировать состояние с текущей темой приложения
  void _initializeWithCurrentTheme() {
    final currentTheme = _ref.read(themeProvider);
    state = state.copyWith(selectedTheme: currentTheme);
    logDebug('Setup initialized with current theme: $currentTheme');
  }

  /// Перейти к следующему шагу
  void nextStep() {
    if (!state.canGoNext) {
      logWarning('Cannot proceed to next step from ${state.currentStep}');
      SnackBarManager.showWarning('Пожалуйста, завершите текущий шаг');
      return;
    }

    if (state.isLastStep) {
      _completeSetup();
      return;
    }

    final nextStep = _getNextStep(state.currentStep);
    if (nextStep != null) {
      logDebug('Moving to next step: $nextStep');
      state = state.copyWith(currentStep: nextStep);
      // SnackBarManager.showInfo('Переход к следующему шагу');
    }
  }

  /// Вернуться к предыдущему шагу
  void previousStep() {
    if (!state.canGoBack) {
      logWarning('Cannot go back from first step');
      SnackBarManager.showWarning('Это первый шаг настройки');
      return;
    }

    final previousStep = _getPreviousStep(state.currentStep);
    if (previousStep != null) {
      logDebug('Moving to previous step: $previousStep');
      state = state.copyWith(currentStep: previousStep);
    }
  }

  /// Перейти к конкретному шагу
  void goToStep(SetupStep step) {
    logDebug('Jumping to step: $step');
    state = state.copyWith(currentStep: step);
  }

  /// Изменить выбранную тему и применить её к приложению
  Future<void> setTheme(ThemeMode theme) async {
    logDebug('Theme changed to: $theme');
    state = state.copyWith(selectedTheme: theme);

    // Применяем тему через провайдер
    final themeNotifier = _ref.read(themeProvider.notifier);
    switch (theme) {
      case ThemeMode.light:
        await themeNotifier.setLightTheme();
        break;
      case ThemeMode.dark:
        await themeNotifier.setDarkTheme();
        break;
      case ThemeMode.system:
        await themeNotifier.setSystemTheme();
        break;
    }

    // SnackBarManager.showSuccess('Тема применена: ${_getThemeName(theme)}');
  }

  /// Завершить настройку
  void _completeSetup() {
    logInfo('Setup completed with theme: ${state.selectedTheme}');
    state = state.copyWith(isCompleted: true);
    // SnackBarManager.showSuccess('Настройка завершена!');

    // Здесь можно сохранить настройки или выполнить другие действия
    _saveSettings();
  }

  /// Сохранить настройки (заглушка)
  void _saveSettings() {
    // TODO: Реализовать сохранение настроек
    logDebug('Saving settings: theme=${state.selectedTheme}');
  }

  /// Получить следующий шаг
  SetupStep? _getNextStep(SetupStep current) {
    switch (current) {
      case SetupStep.welcome:
        return SetupStep.theme;
      case SetupStep.theme:
        return null; // Последний шаг
    }
  }

  /// Получить предыдущий шаг
  SetupStep? _getPreviousStep(SetupStep current) {
    switch (current) {
      case SetupStep.welcome:
        return null; // Первый шаг
      case SetupStep.theme:
        return SetupStep.welcome;
    }
  }

  /// Сбросить состояние настройки
  void reset() {
    logInfo('Setup state reset');
    state = const SetupState();
  }
}

/// Провайдер для контроллера настройки
final setupControllerProvider =
    StateNotifierProvider<SetupController, SetupState>(
      (ref) => SetupController(ref),
    );
