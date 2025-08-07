# Руководство по миграции на Unified Notification System

Это руководство поможет вам перейти со старых систем уведомлений на новую унифицированную систему.

## Быстрая миграция

### 1. Импорт новой системы

```dart
// Добавьте этот импорт вместо старых
import 'package:codexa_pass/app/utils/unified_notifications/unified_notifications.dart';
```

### 2. Настройка приложения

Добавьте глобальный ключ в ваше главное приложение:

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

## Миграция с SnackBarManager

### Было:
```dart
import 'package:codexa_pass/app/utils/snack_bar_message.dart';

SnackBarManager.showSuccess('Операция выполнена!');
SnackBarManager.showError('Ошибка!');
SnackBarManager.showWarning('Предупреждение!');
SnackBarManager.showInfo('Информация');
```

### Стало:
```dart
import 'package:codexa_pass/app/utils/unified_notifications/unified_notifications.dart';

UnifiedNotification.success('Операция выполнена!');
UnifiedNotification.error('Ошибка!');
UnifiedNotification.warning('Предупреждение!');
UnifiedNotification.info('Информация');
```

### Дополнительные параметры:

#### Было:
```dart
SnackBarManager.showSuccess(
  'Файл сохранен',
  duration: Duration(seconds: 5),
  onAction: () => print('Действие'),
  actionLabel: 'Открыть',
  subtitle: 'document.pdf',
);
```

#### Стало:
```dart
UnifiedNotification.success(
  'Файл сохранен',
  duration: Duration(seconds: 5),
  onAction: () => print('Действие'),
  actionLabel: 'Открыть',
  subtitle: 'document.pdf',
);
```

## Миграция с TopSnackBar

### Было:
```dart
import 'package:codexa_pass/app/utils/snack_bar/top_snack_bar.dart';

TopSnackBar.showSuccess(context, 'Успешно!');
TopSnackBar.showError(context, 'Ошибка!');
TopSnackBar.showWarning(context, 'Предупреждение!');
TopSnackBar.showInfo(context, 'Информация');
```

### Стало:
```dart
import 'package:codexa_pass/app/utils/unified_notifications/unified_notifications.dart';

UnifiedNotification.success(
  'Успешно!',
  context: context,
  position: NotificationPosition.top,
);
UnifiedNotification.error(
  'Ошибка!',
  context: context,
  position: NotificationPosition.top,
);
UnifiedNotification.warning(
  'Предупреждение!',
  context: context,
  position: NotificationPosition.top,
);
UnifiedNotification.info(
  'Информация',
  context: context,
  position: NotificationPosition.top,
);
```

## Миграция шаблонов

### Было:
```dart
import 'package:codexa_pass/app/utils/snack_bar_extensions.dart';

SnackBarTemplates.showNetworkError(onRetry: () => retry());
SnackBarTemplates.showFileSaved('document.pdf');
SnackBarTemplates.showLoginSuccess('Иван');
```

### Стало:
```dart
import 'package:codexa_pass/app/utils/unified_notifications/unified_notifications.dart';

UnifiedNotificationTemplates.showNetworkError(
  context: context,
  onRetry: () => retry(),
);
UnifiedNotificationTemplates.showFileSaved(
  'document.pdf',
  context: context,
);
UnifiedNotificationTemplates.showLoginSuccess(
  'Иван',
  context: context,
);
```

## Миграция управления

### Было:
```dart
// SnackBarManager
SnackBarManager.hideCurrent();
SnackBarManager.clearQueue();
SnackBarManager.dispose();

// TopSnackBar
TopSnackBar.hide();
TopSnackBar.clearQueue();
TopSnackBar.dispose();
```

### Стало:
```dart
// Единое управление
UnifiedNotification.hideAll();          // Скрыть все
UnifiedNotification.hideSnackBar();     // Скрыть только SnackBar
UnifiedNotification.hideOverlay();      // Скрыть только Overlay

UnifiedNotification.clearQueue();       // Очистить все очереди
UnifiedNotification.clearSnackBarQueue(); // Очистить очередь SnackBar
UnifiedNotification.clearOverlayQueue();  // Очистить очередь Overlay

UnifiedNotification.dispose();          // Освободить ресурсы
```

## Новые возможности

### 1. Выбор позиции для любого уведомления

```dart
// Bottom (SnackBar стиль) - по умолчанию
UnifiedNotification.info('Сообщение снизу');

// Top (Overlay стиль)
UnifiedNotification.info(
  'Сообщение сверху',
  context: context,
  position: NotificationPosition.top,
);
```

### 2. Прогресс-уведомления

```dart
// Статический прогресс
UnifiedNotification.progress(
  'Загрузка файлов...',
  context: context,
  progress: 75.0,
  subtitle: '75% завершено',
);

// Анимированный прогресс
UnifiedNotification.progress(
  'Обработка данных...',
  context: context,
  // progress не указан = анимация
);
```

### 3. Расширенные возможности

```dart
// Прогресс с потоком
UnifiedNotificationManagerExtensions.showProgress(
  progressStream,
  context: context,
  initialMessage: 'Начинаем...',
);

// Группа уведомлений
UnifiedNotificationManagerExtensions.showGroup([
  (message: 'Шаг 1', type: NotificationType.info, delay: null),
  (message: 'Шаг 2', type: NotificationType.success, delay: Duration(seconds: 1)),
]);

// Уведомление с таймером
UnifiedNotificationManagerExtensions.showWithCountdown(
  'Автообновление',
  NotificationType.warning,
  context: context,
  countdownDuration: Duration(seconds: 10),
);
```

## Совместимость

Старые системы остаются рабочими, но рекомендуется постепенная миграция на новую систему:

1. **Этап 1**: Установите новую систему параллельно со старой
2. **Этап 2**: Мигрируйте новые функции на новую систему
3. **Этап 3**: Постепенно переписывайте существующий код
4. **Этап 4**: Удалите старые зависимости

## Преимущества новой системы

- ✅ **Единый API** для всех типов уведомлений
- ✅ **Лучшая производительность** за счет оптимизации
- ✅ **Больше возможностей** (прогресс, анимации, расширения)
- ✅ **Умная система приоритетов** для ошибок
- ✅ **Гибкое позиционирование** (top/bottom)
- ✅ **Совместимость** со старыми системами
- ✅ **Лучшая документация** и примеры

## Помощь и поддержка

Если у вас возникли проблемы с миграцией:

1. Проверьте примеры в `/examples/unified_notification_demo.dart`
2. Изучите документацию в `README.md`
3. Убедитесь, что глобальный ключ настроен корректно
4. Для сложных случаев используйте кастомную конфигурацию

## Пример полной миграции

### Было (старый код):
```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void _saveData() {
    try {
      // Логика сохранения
      SnackBarManager.showSuccess('Данные сохранены');
    } catch (e) {
      SnackBarManager.showError('Ошибка: $e');
    }
  }

  void _showProgress() {
    TopSnackBar.showInfo(context, 'Обработка...');
  }

  @override
  void dispose() {
    SnackBarManager.dispose();
    TopSnackBar.dispose();
    super.dispose();
  }

  // ... остальной код
}
```

### Стало (новый код):
```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void _saveData() {
    try {
      // Логика сохранения
      UnifiedNotification.success('Данные сохранены');
    } catch (e) {
      UnifiedNotification.error('Ошибка: $e');
    }
  }

  void _showProgress() {
    UnifiedNotification.progress(
      'Обработка...',
      context: context,
      position: NotificationPosition.top,
    );
  }

  @override
  void dispose() {
    UnifiedNotification.dispose();
    super.dispose();
  }

  // ... остальной код
}
```
