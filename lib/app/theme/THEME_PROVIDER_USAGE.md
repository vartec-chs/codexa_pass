# Инструкция по использованию Theme Provider

## Обзор
`theme_provider.dart` - это провайдер на основе Riverpod для управления темами в Flutter приложении. Он обеспечивает автоматическое сохранение настроек темы и поддерживает три режима: светлая, темная и системная тема.

## Установка и настройка

### 1. Подключение ProviderScope
Оберните ваше приложение в `ProviderScope`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme/theme_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 2. Настройка MaterialApp
Используйте провайдеры тем в `MaterialApp`:

```dart
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
		
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);

    return MaterialApp(
      title: 'Codexa Pass',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const HomePage(),
    );
  }
}
```

## Использование в виджетах

### 1. Отслеживание состояния темы

```dart
class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = ref.watch(isDarkThemeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки темы'),
      ),
      body: Column(
        children: [
          Text('Текущая тема: ${themeMode.name}'),
          Text('Темная тема: ${isDark ? 'Да' : 'Нет'}'),
          // ... остальной контент
        ],
      ),
    );
  }
}
```

### 2. Переключение темы

```dart
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkThemeProvider);

    return IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () {
        ref.themeNotifier.toggleTheme();
      },
    );
  }
}
```

### 3. Выбор конкретной темы

```dart
class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('Светлая тема'),
          value: ThemeMode.light,
          groupValue: currentTheme,
          onChanged: (value) {
            ref.themeNotifier.setLightTheme();
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Темная тема'),
          value: ThemeMode.dark,
          groupValue: currentTheme,
          onChanged: (value) {
            ref.themeNotifier.setDarkTheme();
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Системная тема'),
          value: ThemeMode.system,
          groupValue: currentTheme,
          onChanged: (value) {
            ref.themeNotifier.setSystemTheme();
          },
        ),
      ],
    );
  }
}
```

## Доступные методы

### Методы управления темой:
- `setLightTheme()` - установить светлую тему
- `setDarkTheme()` - установить темную тему
- `setSystemTheme()` - установить системную тему
- `toggleTheme()` - переключить между темами

### Свойства для проверки состояния:
- `currentTheme` - получить текущий режим темы
- `isDarkMode` - проверить, активна ли темная тема
- `isLightMode` - проверить, активна ли светлая тема
- `isSystemMode` - проверить, используется ли системная тема

## Примеры использования

### Простое переключение темы в AppBar:
```dart
AppBar(
  title: const Text('Мое приложение'),
  actions: [
    Consumer(
      builder: (context, ref, child) {
        return IconButton(
          icon: const Icon(Icons.brightness_6),
          onPressed: () => ref.themeNotifier.toggleTheme(),
        );
      },
    ),
  ],
)
```

### Настройки темы с сохранением состояния:
```dart
class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Темная тема'),
            value: ref.watch(isDarkThemeProvider),
            onChanged: (value) {
              if (value) {
                ref.themeNotifier.setDarkTheme();
              } else {
                ref.themeNotifier.setLightTheme();
              }
            },
          ),
        ],
      ),
    );
  }
}
```

## Автоматическое сохранение
Провайдер автоматически:
- Сохраняет выбранную тему в `SharedPreferences`
- Загружает сохраненную тему при запуске приложения
- Обрабатывает ошибки при работе с локальным хранилищем

## Зависимости
Убедитесь, что в `pubspec.yaml` добавлены следующие зависимости:
```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  shared_preferences: ^2.3.2
```

## Примечания
- Системная тема автоматически адаптируется к настройкам устройства
- При переключении с помощью `toggleTheme()` из системной темы происходит переход на противоположную от текущей системной
- Все изменения темы сохраняются автоматически и восстанавливаются при перезапуске приложения
