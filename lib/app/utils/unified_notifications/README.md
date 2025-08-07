# Unified Notification System

Объединенная система уведомлений для Flutter приложений, которая совмещает возможности SnackBar и Top/Overlay уведомлений.

## Особенности

- ✅ **Top и Bottom уведомления** - Поддержка overlay-позиционированных уведомлений сверху и снизу экрана
- ✅ **SnackBar интеграция** - Совместимость с стандартными SnackBar уведомлениями Flutter
- ✅ **Приоритетные ошибки** - Автоматическое прерывание других уведомлений для показа ошибок
- ✅ **Очереди сообщений** - Умная система очередей с приоритизацией по типам
- ✅ **Прогресс-бары** - Встроенная поддержка индикаторов прогресса
- ✅ **Анимации** - Плавные анимации появления, исчезновения и взаимодействия
- ✅ **Расширения** - Дополнительные возможности и предустановленные шаблоны
- ✅ **Гибкая конфигурация** - Настройка внешнего вида, поведения и взаимодействия

## Быстрый старт

### Базовое использование

```dart
import 'package:codexa_pass/app/utils/unified_notifications/unified_notification.dart';

// Информационное сообщение (bottom)
UnifiedNotification.info('Данные обновлены');

// Успешное сообщение (top)
UnifiedNotification.success(
  'Операция выполнена успешно!',
  context: context,
  position: NotificationPosition.top,
  subtitle: 'Все файлы сохранены',
);

// Ошибка (приоритетная)
UnifiedNotification.error(
  'Произошла ошибка при загрузке',
  context: context,
  subtitle: 'Проверьте подключение к интернету',
);

// Прогресс
UnifiedNotification.progress(
  'Загрузка файлов...',
  context: context,
  progress: 75.0,
  subtitle: '75% завершено',
);
```

### Настройка приложения

Для корректной работы SnackBar уведомлений без контекста, добавьте глобальный ключ в ваше приложение:

```dart
import 'package:codexa_pass/app/utils/unified_notifications/notification_manager.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: globalSnackbarKey, // Добавьте эту строку
      home: MyHomePage(),
    );
  }
}
```

## Типы уведомлений

### 1. Базовые типы

```dart
// Информация
UnifiedNotification.info('Информационное сообщение');

// Успех
UnifiedNotification.success('Операция завершена успешно');

// Предупреждение
UnifiedNotification.warning('Внимание! Проверьте данные');

// Ошибка (автоматически прерывает другие уведомления)
UnifiedNotification.error('Критическая ошибка системы');
```

### 2. Позиционирование

```dart
// Bottom уведомления (SnackBar)
UnifiedNotification.info(
  'Сообщение снизу',
  position: NotificationPosition.bottom,
);

// Top уведомления (Overlay)
UnifiedNotification.info(
  'Сообщение сверху',
  context: context,
  position: NotificationPosition.top,
);
```

### 3. Дополнительные параметры

```dart
UnifiedNotification.warning(
  'Основное сообщение',
  context: context,
  subtitle: 'Дополнительная информация',
  duration: Duration(seconds: 5),
  onTap: () => print('Уведомление нажато'),
  onDismiss: () => print('Уведомление закрыто'),
  customIcon: Icon(Icons.warning_amber),
);
```

## Расширенные возможности

### Шаблоны уведомлений

```dart
import 'package:codexa_pass/app/utils/unified_notifications/notification_extensions.dart';

// Сетевые операции
UnifiedNotificationTemplates.showNetworkError(
  context: context,
  onRetry: () => retryConnection(),
);

UnifiedNotificationTemplates.showNetworkSuccess(context: context);

// Операции с файлами
UnifiedNotificationTemplates.showFileSaved('document.pdf', context: context);
UnifiedNotificationTemplates.showFileDeleted(
  'old_file.txt',
  context: context,
  onUndo: () => restoreFile(),
);

// Аутентификация
UnifiedNotificationTemplates.showLoginSuccess('Иван Иванов', context: context);
UnifiedNotificationTemplates.showSessionExpired(context: context);
```

### Прогресс-уведомления с потоками

```dart
import 'package:codexa_pass/app/utils/unified_notifications/notification_extensions.dart';

// Подписка на поток прогресса
StreamController<String> progressController = StreamController<String>();

UnifiedNotificationManagerExtensions.showProgress(
  progressController.stream,
  context: context,
  initialMessage: 'Начинаем загрузку...',
);

// Обновление прогресса
progressController.add('Загружено 25%');
progressController.add('Загружено 50%');
progressController.add('Загружено 75%');
progressController.add('Загрузка завершена!');

// Остановка показа прогресса
UnifiedNotificationManagerExtensions.stopProgress();
```

### Условные уведомления

```dart
// Показать уведомление пока выполняется условие
UnifiedNotificationManagerExtensions.showConditional(
  'Ожидание подключения...',
  NotificationType.info,
  context: context,
  hideCondition: () => isConnected,
  checkInterval: Duration(seconds: 1),
  maxDuration: Duration(seconds: 30),
);
```

### Группы уведомлений

```dart
// Показать последовательность связанных уведомлений
UnifiedNotificationManagerExtensions.showGroup([
  (message: 'Шаг 1: Подготовка данных', type: NotificationType.info, delay: null),
  (message: 'Шаг 2: Обработка файлов', type: NotificationType.info, delay: Duration(seconds: 1)),
  (message: 'Шаг 3: Сохранение результата', type: NotificationType.success, delay: Duration(seconds: 2)),
], context: context);
```

## Управление очередями

```dart
// Очистить все очереди
UnifiedNotification.clearQueue();

// Очистить только overlay очередь
UnifiedNotification.clearOverlayQueue();

// Очистить только SnackBar очередь
UnifiedNotification.clearSnackBarQueue();

// Получить статистику очередей
print('Overlay: ${UnifiedNotification.overlayQueueLength}');
print('SnackBar: ${UnifiedNotification.snackBarQueueLength}');
print('Всего: ${UnifiedNotification.totalQueueLength}');
```

## Скрытие уведомлений

```dart
// Скрыть все уведомления
UnifiedNotification.hideAll();

// Скрыть только overlay уведомления
UnifiedNotification.hideOverlay();

// Скрыть только SnackBar уведомления
UnifiedNotification.hideSnackBar();
```

## Статус показа

```dart
// Проверить состояние показа
bool overlayShowing = UnifiedNotification.isOverlayShowing;
bool snackBarShowing = UnifiedNotification.isSnackBarShowing;
bool anyShowing = UnifiedNotification.isAnyShowing;
```

## Автоматический показ

```dart
// Запустить автоматический показ очереди SnackBar
UnifiedNotification.startAutoShow(interval: Duration(seconds: 2));

// Остановить автоматический показ
UnifiedNotification.stopAutoShow();
```

## Кастомные уведомления

```dart
// Создание полностью кастомного уведомления
final config = NotificationConfig(
  message: 'Кастомное уведомление',
  type: NotificationType.info,
  position: NotificationPosition.top,
  duration: Duration(seconds: 10),
  padding: EdgeInsets.all(20),
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  borderRadius: 16,
  showProgress: true,
  progress: 60.0,
  onTap: () => print('Нажато'),
  onDismiss: () => print('Закрыто'),
  customIcon: Icon(Icons.star, color: Colors.amber),
);

UnifiedNotification.custom(context, config);
```

## Освобождение ресурсов

```dart
// В dispose методе вашего виджета или при завершении приложения
@override
void dispose() {
  UnifiedNotification.dispose();
  UnifiedNotificationManagerExtensions.disposeExtensions();
  super.dispose();
}
```

## Примеры интеграции

### В StatefulWidget

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void _showNotification() {
    UnifiedNotification.success(
      'Виджет обновлен!',
      context: context,
      subtitle: 'Состояние сохранено',
    );
  }

  @override
  void dispose() {
    UnifiedNotification.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _showNotification,
          child: Text('Показать уведомление'),
        ),
      ),
    );
  }
}
```

### В BLoC/Provider

```dart
class MyBlocState {
  void _handleSuccess(String message) {
    UnifiedNotification.success(message);
  }

  void _handleError(String error) {
    UnifiedNotification.error(
      'Ошибка в BLoC',
      subtitle: error,
    );
  }
}
```

## Миграция со старых систем

### Из SnackBarManager

```dart
// Старый код
SnackBarManager.showSuccess('Успех!');

// Новый код
UnifiedNotification.success('Успех!');
```

### Из TopSnackBar

```dart
// Старый код
TopSnackBar.showSuccess(context, 'Успех!');

// Новый код
UnifiedNotification.success(
  'Успех!',
  context: context,
  position: NotificationPosition.top,
);
```

## Архитектура

```
unified_notifications/
├── unified_notification.dart          # Главный класс с удобными методами
├── notification_config.dart           # Конфигурация и модели данных
├── notification_manager.dart          # Логика управления уведомлениями
├── notification_widget.dart           # Виджет отображения уведомлений
├── notification_extensions.dart       # Расширения и шаблоны
└── README.md                          # Документация
```

## Производительность

- Ленивая инициализация менеджеров
- Автоматическая очистка завершённых анимаций
- Умное управление памятью для очередей
- Оптимизированные анимации с использованием SingleTickerProviderStateMixin

## Совместимость

- Flutter 2.0+
- Dart 2.12+ (null safety)
- Android, iOS, Web, Desktop

## Лицензия

Часть проекта CodeXa Pass. Все права защищены.
