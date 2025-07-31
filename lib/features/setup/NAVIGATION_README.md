# Setup Screen Navigation

## Функциональность

Экран настройки теперь поддерживает автоматический переход на домашний экран после завершения настройки.

## Основные изменения

### SetupController

1. **Новые методы**:
   - `completeSetupAndNavigate(BuildContext context)` - завершает настройку и переходит на домашний экран
   - `isSetupCompleted()` - статический метод для проверки завершения настройки
   - `getSetupCompletedDate()` - получает дату завершения настройки

2. **Обновленные методы**:
   - `nextStep([BuildContext? context])` - теперь принимает контекст для навигации
   - `_completeSetup()` - стал асинхронным и сохраняет настройки
   - `_saveSettings()` - реализовано сохранение в SharedPreferences

### Сохраняемые настройки

В SharedPreferences сохраняются:
- `is_setup_completed: bool` - флаг завершения настройки
- `is_first_run: bool` - флаг первого запуска (устанавливается в false)
- `selected_theme: String` - выбранная тема
- `setup_completed_date: String` - дата завершения настройки

### Навигация

После завершения настройки происходит автоматический переход на маршрут `AppRoutes.home` ("/").

## Использование

```dart
// В UI виджете
final controller = ref.read(setupControllerProvider.notifier);

// Завершить настройку и перейти на домашний экран
await controller.nextStep(context);

// Или явно
await controller.completeSetupAndNavigate(context);

// Проверить статус завершения настройки
final isCompleted = await SetupController.isSetupCompleted();
```

## Провайдеры

- `setupControllerProvider` - основной контроллер настройки
- `setupCompletionStatusProvider` - FutureProvider для проверки статуса завершения

## Интеграция с роутером

Провайдер `setupCompletionStatusProvider` можно использовать в роутере для условной навигации:

```dart
redirect: (context, state) async {
  final ref = ProviderScope.containerOf(context);
  final isSetupCompleted = await ref.read(setupCompletionStatusProvider.future);
  
  if (!isSetupCompleted && state.fullPath != '/setup') {
    return '/setup';
  }
  
  if (isSetupCompleted && state.fullPath == '/setup') {
    return '/';
  }
  
  return null;
}
```
