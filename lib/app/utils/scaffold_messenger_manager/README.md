# ScaffoldMessengerManager

Современный менеджер для управления SnackBar и MaterialBanner в Flutter приложениях с поддержкой тем, очереди и SOLID принципов.

## Возможности

- ✅ Глобальный доступ через ключ
- ✅ Очередь SnackBar с автоматической обработкой
- ✅ Современный UI с поддержкой тем
- ✅ Типизированные SnackBar (error, warning, info, success)
- ✅ Кнопки копирования и закрытия
- ✅ MaterialBanner с базовыми случаями
- ✅ Полная кастомизация
- ✅ SOLID принципы
- ✅ Легкое тестирование

## Быстрый старт

### 1. Настройка глобального ключа

```dart
import 'package:flutter/material.dart';
import 'package:your_app/app/utils/scaffold_messenger_manager/index.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: ScaffoldMessengerManager.globalKey,
      home: HomeScreen(),
    );
  }
}
```

### 2. Основное использование

```dart
import 'package:your_app/app/utils/scaffold_messenger_manager/index.dart';

final messenger = ScaffoldMessengerManager.instance;

// Простые методы
messenger.showError('Произошла ошибка!');
messenger.showWarning('Внимание!');
messenger.showInfo('Информация');
messenger.showSuccess('Успешно выполнено!');

// С дополнительными параметрами
messenger.showError(
  'Ошибка сети',
  showCopyButton: true,
  actionLabel: 'Повторить',
  onActionPressed: () => retryAction(),
);
```

### 3. MaterialBanner

```dart
// Простые методы
messenger.showErrorBanner('Критическая ошибка!');
messenger.showWarningBanner('Предупреждение');

// С кастомными действиями
messenger.showErrorBanner(
  'Нет подключения к интернету',
  actions: [
    TextButton(
      onPressed: () => checkConnection(),
      child: Text('Проверить'),
    ),
    TextButton(
      onPressed: () => messenger.hideCurrentBanner(),
      child: Text('Закрыть'),
    ),
  ],
);
```

## Расширенное использование

### Кастомизация тем

```dart
class CustomSnackBarThemeProvider implements SnackBarThemeProvider {
  @override
  Color getBackgroundColor(BuildContext context, SnackBarType type) {
    // Ваша логика
    return Colors.blue;
  }
  
  // Реализация других методов...
}

// Настройка
ScaffoldMessengerManager.instance.configure(
  snackBarBuilder: DefaultSnackBarBuilder(
    themeProvider: CustomSnackBarThemeProvider(),
  ),
);
```

### Продвинутые SnackBar

```dart
messenger.showSnackBar(SnackBarData(
  message: 'Кастомное сообщение',
  type: SnackBarType.info,
  duration: Duration(seconds: 10),
  showCopyButton: true,
  showCloseButton: true,
  actionLabel: 'Действие',
  onActionPressed: () => performAction(),
  onCopyPressed: () => customCopyLogic(),
));
```

### Продвинутые MaterialBanner

```dart
messenger.showBanner(BannerData(
  message: 'Кастомный баннер',
  type: BannerType.warning,
  forceActionsBelow: true,
  backgroundColor: Colors.orange,
  elevation: 4,
  actions: [
    TextButton(
      onPressed: () => handleAction(),
      child: Text('Действие'),
    ),
  ],
));
```

### Управление очередью

```dart
// Проверка состояния
if (messenger.queueLength > 0) {
  print('В очереди ${messenger.queueLength} сообщений');
}

// Очистка очереди
messenger.clearSnackBarQueue();

// Скрытие текущих элементов
messenger.hideCurrentSnackBar();
messenger.hideCurrentBanner();
```

## Архитектура

Проект следует SOLID принципам:

- **Single Responsibility**: Каждый класс имеет одну ответственность
- **Open/Closed**: Легко расширяется через интерфейсы
- **Liskov Substitution**: Реализации взаимозаменяемы
- **Interface Segregation**: Интерфейсы сфокусированы
- **Dependency Inversion**: Зависимости инвертированы

### Основные компоненты

- `ScaffoldMessengerManager` - главный синглтон
- `SnackBarQueueManager` - управление очередью
- `SnackBarBuilder` / `BannerBuilder` - создание UI
- `ThemeProvider` - провайдеры тем
- `Data` модели - типизированные данные

## Тестирование

```dart
// Мокание зависимостей
class MockSnackBarQueueManager implements SnackBarQueueManager {
  // Реализация для тестов
}

// В тестах
ScaffoldMessengerManager.instance.configure(
  queueManager: MockSnackBarQueueManager(),
);
```

## Типы сообщений

### SnackBar типы
- `error` - красный, 8 сек, с кнопкой копирования
- `warning` - желтый, 6 сек
- `info` - синий, 4 сек
- `success` - зеленый, 3 сек

### Banner типы
- `error` - критические ошибки
- `warning` - предупреждения
- `info` - информационные сообщения
- `success` - успешные операции

## Рекомендации

1. Используйте `error` для критических ошибок с кнопкой копирования
2. `warning` для предупреждений пользователя
3. `info` для нейтральной информации
4. `success` для подтверждения успешных действий
5. MaterialBanner для важных постоянных уведомлений
6. Настраивайте темы под ваш дизайн
7. Тестируйте с моками зависимостей
