# SnackBar Manager - Улучшенный UI

Современная система уведомлений для Flutter приложений с красивым дизайном, анимациями и расширенным функционалом.

## 🎨 Основные улучшения UI

### Визуальные эффекты
- **Градиентные фоны** - каждый тип уведомления имеет уникальный градиент
- **Анимированные тени** - объемные тени создают эффект глубины
- **Скругленные углы** - современный дизайн с радиусом 16px
- **Прозрачность и blur-эффекты** - элегантное наложение
- **Цветовые акценты** - четкое разделение по типам уведомлений

### Типографика
- **Иерархия шрифтов** - основное сообщение и подзаголовок
- **Читаемость** - оптимизированные размеры и контрастность
- **Многострочный текст** - поддержка длинных сообщений

### Интерактивность
- **Swipe-to-dismiss** - смахивание для закрытия
- **Анимированные кнопки** - плавные переходы при нажатии
- **Tactile feedback** - обратная связь при взаимодействии

## 📋 Новые возможности

### Расширенная структура сообщений

```dart
SnackBarManager.showInfo(
  'Основное сообщение',
  subtitle: 'Дополнительная информация', // Новое!
  showProgress: true,                     // Новое!
  progress: 65.0,                         // Новое!
  customIcon: Icon(Icons.download),       // Новое!
  isDismissible: true,                    // Новое!
);
```

### Индикаторы прогресса

```dart
// Фиксированный прогресс
SnackBarManager.showInfo(
  'Загрузка файла',
  showProgress: true,
  progress: 45.0, // 0-100
);

// Неопределенный прогресс (анимированная полоса)
SnackBarManager.showInfo(
  'Обработка данных',
  showProgress: true, // без progress - показывает анимацию
);
```

### Кастомные иконки

```dart
SnackBarManager.showSuccess(
  'Файл загружен',
  customIcon: Icon(Icons.cloud_upload),
);
```

### Неотключаемые уведомления

```dart
SnackBarManager.showError(
  'Критическая ошибка',
  isDismissible: false, // Нельзя закрыть смахиванием
);
```

## 🎯 Готовые шаблоны

Используйте `SnackBarTemplates` для типичных сценариев:

```dart
// Сетевые операции
SnackBarTemplates.showNetworkError(onRetry: () {
  // Логика повторной попытки
});

// Файловые операции
SnackBarTemplates.showFileSaved('document.pdf');
SnackBarTemplates.showFileDeleted('old_file.txt', onUndo: () {
  // Восстановить файл
});

// Аутентификация
SnackBarTemplates.showLoginSuccess('Иван Петров');
SnackBarTemplates.showSessionExpired(onLogin: () {
  // Перейти к экрану входа
});

// Системные уведомления
SnackBarTemplates.showUpdateAvailable(onUpdate: () {
  // Запустить обновление
});
```

## 🎨 Цветовая схема

### Info (Синий градиент)
- Основной: `#42A5F5` → `#1E88E5` → `#1565C0`
- Использование: информационные сообщения, статусы

### Warning (Оранжевый градиент)
- Основной: `#FFB74D` → `#FF9800` → `#F57C00`
- Использование: предупреждения, требующие внимания

### Error (Красный градиент)
- Основной: `#EF5350` → `#F44336` → `#D32F2F`
- Использование: ошибки, критические состояния

### Success (Зеленый градиент)
- Основной: `#66BB6A` → `#4CAF50` → `#388E3C`
- Использование: успешные операции, подтверждения

## 🔧 Параметры настройки

### Длительность показа
```dart
SnackBarManager.showInfo(
  'Сообщение',
  duration: Duration(seconds: 10), // Пользовательская длительность
);
```

### Положение и отступы
- Floating behavior с отступами 16px
- Вертикальный отступ 12px от края экрана
- Автоматическое позиционирование

### Анимации
- Появление: slide + fade (300ms)
- Скрытие: slide + fade (200ms)
- Прогресс-бар: smooth animation (500ms)

## 💡 Примеры использования

### Загрузка файла с прогрессом

```dart
void uploadFile() {
  SnackBarManager.showInfo(
    'Загрузка файла',
    subtitle: 'document.pdf (2.5 MB)',
    showProgress: true,
    progress: 0,
  );
  
  // Обновление прогресса
  Timer.periodic(Duration(milliseconds: 100), (timer) {
    progress += 2;
    if (progress >= 100) {
      timer.cancel();
      SnackBarTemplates.showFileSaved('document.pdf');
    } else {
      SnackBarManager.showInfo(
        'Загрузка файла',
        subtitle: '$progress% завершено',
        showProgress: true,
        progress: progress.toDouble(),
      );
    }
  });
}
```

### Подтверждение критического действия

```dart
void deleteAccount() {
  SnackBarManager.showError(
    'Удалить аккаунт?',
    subtitle: 'Это действие нельзя будет отменить',
    actionLabel: 'Удалить',
    onAction: () {
      // Выполнить удаление
      performAccountDeletion();
    },
    isDismissible: false, // Требует явного выбора
  );
}
```

### Последовательность уведомлений

```dart
void initializeApp() {
  SnackBarManager.showInfo('Инициализация...');
  
  Timer(Duration(seconds: 1), () {
    SnackBarManager.showInfo('Загрузка данных...');
  });
  
  Timer(Duration(seconds: 2), () {
    SnackBarTemplates.showSyncCompleted();
  });
}
```

## 🚀 Производительность

- Оптимизированная очередь сообщений
- Lazy loading анимаций
- Минимальный memory footprint
- Smooth 60fps анимации

## 📱 Адаптивность

- Автоматическая адаптация к размеру экрана
- Поддержка альбомной ориентации
- Оптимизация для планшетов
- Accessibility поддержка

## 🛠 Кастомизация

Для глубокой кастомизации можно переопределить методы `_getColorsForType` и `_getThemeForType` в классе `SnackBarManager`.

---

**Совет**: Используйте `SnackBarTemplates` для стандартных сценариев и кастомные вызовы `SnackBarManager` для уникальных случаев.
