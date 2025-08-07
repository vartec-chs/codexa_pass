# Top Snack Bar - Руководство по использованию

## Описание

Top Snack Bar - это система уведомлений для Flutter, которая отображает сообщения в верхней части экрана. Система поддерживает различные типы сообщений, очереди, приоритеты и богатые возможности кастомизации.

## Структура файлов

```
snack_bar/
├── top_snack_bar.dart              # Основной файл с экспортами и удобными методами
├── top_snack_bar_config.dart       # Модели конфигурации, цвета и утилиты
├── top_snack_bar_manager.dart      # Основной менеджер для управления показом
├── top_snack_bar_widget.dart       # UI компоненты и виджеты
├── top_snack_bar_advanced.dart     # Расширенные возможности и очередь
└── TOP_SNACK_BAR_GUIDE.md         # Данное руководство
```

## Быстрый старт

### Импорт

```dart
import 'package:codexa_pass/app/utils/snack_bar/top_snack_bar.dart';
```

### Простое использование

```dart
// Успешное сообщение
TopSnackBar.showSuccess(context, 'Операция выполнена успешно!');

// Ошибка
TopSnackBar.showError(context, 'Произошла ошибка');

// Предупреждение
TopSnackBar.showWarning(context, 'Внимание!');

// Информация
TopSnackBar.showInfo(context, 'Информационное сообщение');
```

### Использование с дополнительными параметрами

```dart
TopSnackBar.showSuccess(
  context,
  'Данные сохранены',
  subtitle: 'Все изменения применены',
  duration: Duration(seconds: 5),
  onTap: () => print('Нажато!'),
  onDismiss: () => print('Закрыто'),
);
```

## Типы сообщений

### TopSnackBarType

- `success` - Успешные операции (зеленый)
- `error` - Ошибки (красный)
- `warning` - Предупреждения (оранжевый)
- `info` - Информационные сообщения (синий)

## Конфигурация

### TopSnackBarConfig

```dart
TopSnackBarConfig(
  message: 'Основное сообщение',           // Обязательно
  subtitle: 'Дополнительный текст',        // Опционально
  type: TopSnackBarType.info,              // Тип сообщения
  duration: Duration(seconds: 3),          // Время показа
  onTap: () => {},                         // Обработчик нажатия
  onDismiss: () => {},                     // Обработчик закрытия
  showCloseButton: true,                   // Показать кнопку закрытия
  isDismissible: true,                     // Можно ли закрыть свайпом
  padding: EdgeInsets.all(16),             // Внутренние отступы
  margin: EdgeInsets.all(16),              // Внешние отступы
  borderRadius: 12,                        // Радиус скругления
  customIcon: Icon(Icons.custom),          // Кастомная иконка
)
```

## Управление

### Основные методы

```dart
// Скрыть текущее сообщение
TopSnackBar.hide();

// Очистить очередь
TopSnackBar.clearQueue();

// Проверить состояние
bool isShowing = TopSnackBar.isShowing;
int queueLength = TopSnackBar.queueLength;

// Освободить ресурсы
TopSnackBar.dispose();
```

## Расширенные возможности

### Импорт расширенных функций

Расширенные возможности автоматически доступны через основной импорт.

### Приоритетные сообщения

```dart
// Критическая ошибка (прерывает текущее сообщение)
TopSnackBarAdvanced.showCriticalError(
  context,
  'Критическая ошибка!',
  subtitle: 'Требуется немедленное внимание',
);

// Важное предупреждение
TopSnackBarAdvanced.showImportantWarning(
  context,
  'Важное предупреждение',
  subtitle: 'Обратите внимание на это сообщение',
);
```

### Последовательность сообщений

```dart
TopSnackBarAdvanced.showSequence(
  context,
  [
    'Инициализация...',
    'Загрузка данных...',
    'Обработка...',
    'Завершение',
  ],
  type: TopSnackBarType.info,
  delayBetween: Duration(milliseconds: 1000),
);
```

### Показ прогресса операции

```dart
TopSnackBarAdvanced.showProgress(
  context,
  'Синхронизация данных',
  onComplete: () => print('Готово!'),
  onCancel: () => print('Отменено'),
);
```

### Информация об очереди

```dart
QueueInfo info = TopSnackBarAdvanced.getQueueInfo();
print('Всего в очереди: ${info.totalCount}');
print('Ошибок: ${info.errorCount}');
print('Предупреждений: ${info.warningCount}');
print('Показывается сейчас: ${info.isShowing}');
```

### Управление очередью

```dart
// Пауза обработки очереди
TopSnackBarAdvanced.pauseQueue();

// Возобновить обработку
TopSnackBarAdvanced.resumeQueue();

// Очистить очередь
TopSnackBarAdvanced.clearQueue();
```

## Приоритеты сообщений

Система автоматически сортирует сообщения по приоритету:

1. **Error** (0) - Наивысший приоритет
2. **Warning** (1) - Высокий приоритет  
3. **Info** (2) - Средний приоритет
4. **Success** (3) - Низкий приоритет

Сообщения об ошибках автоматически прерывают текущие сообщения и показываются немедленно.

## Анимации

Все сообщения поддерживают плавные анимации:

- Slide-in анимация сверху
- Fade-in/out эффекты
- Scale анимации для элементов
- Анимированные иконки
- Bounce эффекты

## Кастомизация

### Цвета и темы

Цвета автоматически настраиваются в зависимости от типа сообщения, но можно использовать кастомные настройки через `TopSnackBarConfig`.

### Кастомные иконки

```dart
TopSnackBar.showInfo(
  context,
  'Сообщение с кастомной иконкой',
  customIcon: Icon(Icons.star, color: Colors.white),
);
```

## Примеры использования

### Обработка результатов API

```dart
void handleApiResponse(ApiResponse response) {
  if (response.isSuccess) {
    TopSnackBar.showSuccess(
      context,
      'Данные успешно загружены',
      subtitle: '${response.data.length} элементов получено',
    );
  } else {
    TopSnackBar.showError(
      context,
      'Ошибка загрузки данных',
      subtitle: response.errorMessage,
      onTap: () => _retryApiCall(),
    );
  }
}
```

### Валидация формы

```dart
void validateForm() {
  final errors = <String>[];
  
  if (emailController.text.isEmpty) {
    errors.add('Email не может быть пустым');
  }
  
  if (passwordController.text.length < 6) {
    errors.add('Пароль должен содержать минимум 6 символов');
  }
  
  if (errors.isNotEmpty) {
    TopSnackBarAdvanced.showSequence(
      context,
      errors,
      type: TopSnackBarType.warning,
    );
  }
}
```

### Уведомления о состоянии соединения

```dart
void onConnectionChanged(ConnectionState state) {
  switch (state) {
    case ConnectionState.connected:
      TopSnackBar.showSuccess(context, 'Соединение восстановлено');
      break;
    case ConnectionState.disconnected:
      TopSnackBarAdvanced.showCriticalError(
        context,
        'Отсутствует интернет-соединение',
        subtitle: 'Проверьте подключение и попробуйте снова',
      );
      break;
  }
}
```

## Лучшие практики

1. **Не злоупотребляйте уведомлениями** - показывайте только важную информацию
2. **Используйте правильные типы** - error для ошибок, success для успешных операций
3. **Добавляйте подзаголовки** для предоставления дополнительного контекста
4. **Используйте onTap** для интерактивных уведомлений
5. **Очищайте очередь** при смене экранов или состояний
6. **Освобождайте ресурсы** при dispose виджетов

## Совместимость

- Flutter 3.0+
- Dart 2.17+
- Поддерживает все платформы (iOS, Android, Web, Desktop)

## Производительность

- Легковесная система с минимальным влиянием на производительность
- Эффективное управление памятью
- Оптимизированные анимации
- Ленивая инициализация компонентов
