import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/logger/app_logger.dart';
import '../../app/utils/snack_bar_message.dart';
import '../../app/theme/theme_provider.dart';
import '../../app/routing/routes_path.dart';

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
  Future<void> nextStep([BuildContext? context]) async {
    if (!state.canGoNext) {
      logWarning('Cannot proceed to next step from ${state.currentStep}');
      SnackBarManager.showWarning('Пожалуйста, завершите текущий шаг');
      return;
    }

    if (state.isLastStep) {
      if (context != null) {
        await completeSetupAndNavigate(context);
      } else {
        await _completeSetup();
      }
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
  Future<void> _completeSetup() async {
    logInfo('Setup completed with theme: ${state.selectedTheme}');
    state = state.copyWith(isCompleted: true);
    // SnackBarManager.showSuccess('Настройка завершена!');

    // Здесь можно сохранить настройки или выполнить другие действия
    await _saveSettings();
  }

  /// Завершить настройку и перейти на домашний экран
  Future<void> completeSetupAndNavigate(BuildContext context) async {
    await _completeSetup();

    // Переходим на домашний экран
    logInfo('Navigating to home screen after setup completion');
    // ignore: use_build_context_synchronously
    context.go(AppRoutes.home);
  }

  /// Сохранить настройки
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Сохраняем, что настройка была завершена
      await prefs.setBool('is_setup_completed', true);
      await prefs.setBool('is_first_run', false);

      // Сохраняем выбранную тему
      final themeString = state.selectedTheme.toString().split('.').last;
      await prefs.setString('selected_theme', themeString);

      // Сохраняем дату завершения настройки
      await prefs.setString(
        'setup_completed_date',
        DateTime.now().toIso8601String(),
      );

      logDebug(
        'Settings saved: theme=${state.selectedTheme}, setup_completed=true',
      );
    } catch (e) {
      logError('Failed to save settings: $e');
      SnackBarManager.showError('Ошибка сохранения настроек');
    }
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

  /// Проверить, была ли настройка завершена ранее
  static Future<bool> isSetupCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_setup_completed') ?? false;
    } catch (e) {
      logError('Failed to check setup completion status: $e');
      return false;
    }
  }

  /// Получить дату завершения настройки
  static Future<DateTime?> getSetupCompletedDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateString = prefs.getString('setup_completed_date');
      return dateString != null ? DateTime.parse(dateString) : null;
    } catch (e) {
      logError('Failed to get setup completion date: $e');
      return null;
    }
  }
}

/// Провайдер для контроллера настройки
final setupControllerProvider =
    StateNotifierProvider<SetupController, SetupState>(
      (ref) => SetupController(ref),
    );

/// Провайдер для проверки статуса завершения настройки
final setupCompletionStatusProvider = FutureProvider<bool>((ref) async {
  return await SetupController.isSetupCompleted();
});
