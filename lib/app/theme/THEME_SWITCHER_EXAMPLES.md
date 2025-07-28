# Примеры использования ThemeSwitcher

## Основные варианты использования

### 1. В AppBar (рекомендуемый для панели приложения)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme/widgets.dart';

class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Мое приложение'),
      actions: [
        // Компактный переключатель для AppBar
        const AppBarThemeSwitcher(),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
```

### 2. Разные стили переключателей

```dart
// Простой переключатель (по умолчанию)
ThemeSwitcher(
  size: 40,
  style: ThemeSwitcherStyle.toggle,
)

// Выпадающий список
ThemeSwitcher(
  size: 40,
  style: ThemeSwitcherStyle.dropdown,
)

// Сегментированный контрол
ThemeSwitcher(
  size: 40,
  style: ThemeSwitcherStyle.segmented,
)

// Анимированный переключатель с эффектами
ThemeSwitcher(
  size: 50,
  style: ThemeSwitcherStyle.animated,
)
```

### 3. В настройках приложения

```dart
class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          // Виджет для настроек с описанием
          const SettingsThemeSwitcher(),
          
          const Divider(),
          
          // Или кастомная ListTile
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Тема приложения'),
            trailing: ThemeSwitcher(
              size: 35,
              style: ThemeSwitcherStyle.dropdown,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 4. В боковом меню (Drawer)

```dart
Drawer(
  child: ListView(
    children: [
      const DrawerHeader(
        child: Text('Меню'),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Главная'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: const Icon(Icons.brightness_6),
        title: const Text('Тема'),
        trailing: ThemeSwitcher(
          size: 32,
          style: ThemeSwitcherStyle.toggle,
        ),
      ),
    ],
  ),
)
```

### 5. Плавающая кнопка

```dart
FloatingActionButton(
  onPressed: null, // Отключаем стандартное нажатие
  child: ThemeSwitcher(
    size: 24,
    style: ThemeSwitcherStyle.animated,
  ),
)
```

## Особенности виджета

### Автоматическая анимация
- Плавные переходы между состояниями (300-400мс)
- Анимация цветов, позиций и размеров
- Эффекты тени и градиентов

### Адаптивность
- Автоматическое определение системной темы
- Поддержка изменения размера через параметр `size`
- Соответствие Material Design принципам

### Стили
1. **Toggle** - классический переключатель как в iOS
2. **Dropdown** - выпадающий список с тремя опциями
3. **Segmented** - сегментированный контрол для всех режимов
4. **Animated** - креативный переключатель с эффектами звезд и градиентов

### Интеграция с Riverpod
- Автоматическое обновление при изменении темы
- Сохранение выбора в SharedPreferences
- Реактивность на системные изменения

## Настройка

Убедитесь, что у вас подключен провайдер темы в main.dart:

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      themeMode: themeMode,
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      home: const HomePage(),
    );
  }
}
```
