# Toast Manager

Красивый и функциональный менеджер тостов для Flutter приложения с поддержкой очередей, анимаций и тем.

## Особенности

- ✅ **Очередь тостов** - автоматическое управление очередью с приоритетами
- ✅ **Максимум 3 активных тоста** - оптимальное отображение без перегрузки UI
- ✅ **Анимации** - плавные анимации появления и исчезновения
- ✅ **Темы** - автоматическая поддержка светлой и темной темы
- ✅ **Типы тостов** - Success, Error, Warning, Info с соответствующими цветами
- ✅ **Позиционирование** - сверху или снизу экрана
- ✅ **Кастомные действия** - кнопки с действиями в тосте
- ✅ **Прогресс-бар** - индикатор времени отображения
- ✅ **Приоритеты** - ошибки имеют высокий приоритет и прерывают очередь
- ✅ **Overlay система** - использует OverlayEntry и Positioned для точного позиционирования

## Быстрый старт

### Инициализация

Toast Manager автоматически инициализируется в `app.dart` с глобальным `navigatorKey`.

### Базовое использование

```dart
// Простые тосты
ToastUtils.success('Операция выполнена успешно');
ToastUtils.error('Произошла ошибка');
ToastUtils.warning('Внимание!');
ToastUtils.info('Информация');

// С подзаголовком
ToastUtils.success(
  'Файл сохранен',
  subtitle: 'Данные успешно записаны на диск',
);
```

### Использование через контекст

```dart
context.showToastSuccess('Операция выполнена');
context.showToastError('Произошла ошибка');
context.showToastWarning('Предупреждение');
context.showToastInfo('Информация');
```

### Кастомные тосты

```dart
// Тост с подтверждением
ToastUtils.confirmAction(
  title: 'Удалить файл?',
  subtitle: 'Это действие нельзя отменить',
  confirmLabel: 'Удалить',
  onConfirm: () => deleteFile(),
  type: ToastType.error,
);

// Тост с кастомными действиями
ToastUtils.withActions(
  title: 'Настройки изменены',
  subtitle: 'Требуется перезапуск приложения',
  actions: [
    ToastAction(
      label: 'Позже',
      onPressed: () => print('Перезапуск отложен'),
      icon: Icons.schedule,
    ),
    ToastAction(
      label: 'Перезапустить',
      onPressed: () => restartApp(),
      color: Colors.green,
      icon: Icons.refresh,
    ),
  ],
);

// Тост с прогрессом
ToastUtils.progress(
  title: 'Синхронизация данных',
  subtitle: 'Пожалуйста, подождите...',
  duration: Duration(seconds: 5),
);

// Сохранение с действием
ToastUtils.saveAction(
  title: 'Сохранить изменения?',
  subtitle: 'Файл был изменен',
  onSave: () => saveFile(),
);

// Отмена действия
ToastUtils.undoAction(
  title: 'Элемент удален',
  onUndo: () => restoreItem(),
);
```

### Продвинутое использование

```dart
// Полная кастомизация
ToastManager.show(ToastConfig(
  id: ToastManager.generateId(),
  title: 'Кастомный тост',
  subtitle: 'С полной настройкой',
  type: ToastType.warning,
  position: ToastPosition.bottom,
  duration: Duration(seconds: 8),
  showProgressBar: true,
  dismissible: true,
  showCloseButton: true,
  priority: 2,
  actions: [
    ToastAction(
      label: 'Действие',
      onPressed: () => performAction(),
      color: Colors.blue,
      icon: Icons.star,
    ),
  ],
  onTap: () => print('Тост нажат'),
  onDismiss: () => print('Тост закрыт'),
  width: 350,
  margin: EdgeInsets.all(20),
));
```

## API Reference

### ToastManager

Основной класс для управления тостами.

#### Статические методы

```dart
// Показать тосты разных типов
ToastManager.showSuccess(String title, {...});
ToastManager.showError(String title, {...});
ToastManager.showWarning(String title, {...});
ToastManager.showInfo(String title, {...});

// Управление
ToastManager.show(ToastConfig config);
ToastManager.dismiss(String id);
ToastManager.dismissAll();
ToastManager.clearQueue();

// Информация
ToastManager.queueLength; // int
ToastManager.activeCount; // int
ToastManager.generateId(); // String

// Инициализация и очистка
ToastManager.initialize(GlobalKey<NavigatorState> navigatorKey);
ToastManager.dispose();
```

### ToastUtils

Утилиты для упрощенного использования.

```dart
// Быстрые методы
ToastUtils.success(String message, {String? subtitle});
ToastUtils.error(String message, {String? subtitle});
ToastUtils.warning(String message, {String? subtitle});
ToastUtils.info(String message, {String? subtitle});

// Специальные тосты
ToastUtils.confirmAction({...});
ToastUtils.progress({...});
ToastUtils.withActions({...});
ToastUtils.saveAction({...});
ToastUtils.undoAction({...});

// Управление
ToastUtils.clear();
ToastUtils.getStats(); // String
```

### ToastConfig

Конфигурация тоста.

```dart
class ToastConfig {
  final String id;
  final String title;
  final String? subtitle;
  final ToastType type;                    // success, error, warning, info
  final ToastPosition position;            // top, bottom
  final Duration duration;                 // default: 4s
  final Duration animationDuration;        // default: 300ms
  final bool dismissible;                  // default: true
  final bool showProgressBar;              // default: true
  final bool showCloseButton;              // default: true
  final List<ToastAction> actions;         // default: []
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final EdgeInsets margin;                 // default: EdgeInsets.all(16)
  final double? width;
  final int priority;                      // 0-3, higher = more priority
}
```

### ToastAction

Действие в тосте.

```dart
class ToastAction {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;
}
```

### ToastType

```dart
enum ToastType {
  success,   // Зеленый цвет, иконка check_circle
  error,     // Красный цвет, иконка error
  warning,   // Оранжевый цвет, иконка warning
  info,      // Синий цвет, иконка info
}
```

### ToastPosition

```dart
enum ToastPosition {
  top,       // Сверху экрана
  bottom,    // Снизу экрана
}
```

## Управление очередью

- **Максимум активных тостов**: 3 одновременно
- **Приоритеты**: Ошибки (priority: 3) показываются в первую очередь
- **Задержка между тостами**: 200ms для плавности
- **Автоматическое позиционирование**: Тосты автоматически располагаются друг под другом

## Анимации

- **Появление**: SlideTransition + FadeTransition + ScaleTransition
- **Исчезновение**: Reverse анимации
- **Прогресс-бар**: Linear анимация от 100% до 0%
- **Иконка**: Delayed анимация для эффектности

## Темы

Цвета автоматически адаптируются к светлой и темной теме:

- **Success**: Зеленые оттенки
- **Error**: Красные оттенки  
- **Warning**: Оранжевые оттенки
- **Info**: Синие оттенки

## Демо

Для тестирования всех возможностей используйте демо-страницу:

```
/toast-demo
```

Или в коде:
```dart
Navigator.push(context, MaterialPageRoute(
  builder: (context) => ToastManagerDemo(),
));
```

## Структура файлов

```
lib/app/utils/toast_manager/
├── toast_manager.dart          # Основной менеджер
├── toast_models.dart           # Модели и типы
├── toast_ui.dart              # UI виджет тоста
├── toast_widget.dart          # Экспорт виджета
├── toast_utils.dart           # Утилиты
├── toast_manager_export.dart  # Главный экспорт
└── demo/
    └── toast_demo.dart        # Демо-страница
```

## Лучшие практики

1. **Используйте ToastUtils** для большинства случаев
2. **Ошибки показывайте немедленно** - они имеют высокий приоритет
3. **Не злоупотребляйте тостами** - максимум 3 активных
4. **Используйте короткие заголовки** и информативные подзаголовки
5. **Добавляйте действия** только когда они действительно нужны
6. **Тестируйте на разных темах** - цвета адаптируются автоматически

## Пример интеграции

```dart
// В error handler
try {
  await riskyOperation();
  ToastUtils.success('Операция выполнена');
} catch (e) {
  ToastUtils.error(
    'Ошибка операции', 
    subtitle: e.toString(),
  );
}

// При сохранении
await saveData();
ToastUtils.saveAction(
  title: 'Данные изменены',
  subtitle: 'Сохранить изменения?',
  onSave: () => saveToFile(),
);

// При удалении
deleteItem(item);
ToastUtils.undoAction(
  title: 'Элемент удален',
  onUndo: () => restoreItem(item),
);
```
