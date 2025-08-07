# Top Snack Bar

Система уведомлений для Flutter, отображающихся в верхней части экрана с поддержкой анимаций, очередей и приоритетов.

## Структура

```
snack_bar/
├── top_snack_bar.dart              # 🎯 Основной файл (импортируйте только его!)
├── top_snack_bar_config.dart       # ⚙️ Конфигурация, модели и утилиты
├── top_snack_bar_manager.dart      # 🔧 Менеджер управления
├── top_snack_bar_widget.dart       # 🎨 UI компоненты
├── top_snack_bar_advanced.dart     # 🚀 Расширенные возможности
├── TOP_SNACK_BAR_GUIDE.md         # 📖 Подробная документация
├── README.md                       # 📝 Этот файл
└── examples/
    └── top_snack_bar_demo.dart     # 🎮 Демо-страница
```

## Быстрый старт

### 1. Импорт

```dart
import 'package:codexa_pass/app/utils/snack_bar/top_snack_bar.dart';
```

### 2. Использование

```dart
// Простые сообщения
TopSnackBar.showSuccess(context, 'Успешно!');
TopSnackBar.showError(context, 'Ошибка!');
TopSnackBar.showWarning(context, 'Внимание!');
TopSnackBar.showInfo(context, 'Информация');

// С дополнительными параметрами
TopSnackBar.showSuccess(
  context,
  'Данные сохранены',
  subtitle: 'Все изменения применены',
  onTap: () => print('Нажато!'),
);
```

### 3. Расширенные возможности

```dart
// Критическая ошибка (прерывает текущие сообщения)
TopSnackBarAdvanced.showCriticalError(
  context,
  'Критическая ошибка!',
  subtitle: 'Требуется внимание',
);

// Последовательность сообщений
TopSnackBarAdvanced.showSequence(
  context,
  ['Шаг 1', 'Шаг 2', 'Шаг 3'],
);

// Прогресс операции
TopSnackBarAdvanced.showProgress(
  context,
  'Загрузка данных',
  onComplete: () => print('Готово!'),
);
```

## Особенности

✅ **4 типа сообщений** (success, error, warning, info)  
✅ **Плавные анимации** (slide, fade, scale, bounce)  
✅ **Система приоритетов** (ошибки прерывают другие сообщения)  
✅ **Очередь сообщений** с автоматической обработкой  
✅ **Кастомизация** (цвета, иконки, время показа)  
✅ **Интерактивность** (нажатия, свайпы для закрытия)  
✅ **Управление ресурсами** (автоматическая очистка)  

## Основные классы

- **`TopSnackBar`** - Простые методы для повседневного использования
- **`TopSnackBarAdvanced`** - Расширенные возможности и управление очередью
- **`TopSnackBarManager`** - Низкоуровневое управление (обычно не нужно)
- **`TopSnackBarConfig`** - Конфигурация сообщений

## Управление

```dart
// Состояние
bool isShowing = TopSnackBar.isShowing;
int queueLength = TopSnackBar.queueLength;

// Управление
TopSnackBar.hide();           // Скрыть текущее
TopSnackBar.clearQueue();     // Очистить очередь
TopSnackBar.dispose();        // Освободить ресурсы

// Расширенное управление
TopSnackBarAdvanced.pauseQueue();    // Пауза очереди
TopSnackBarAdvanced.resumeQueue();   // Возобновить очередь
QueueInfo info = TopSnackBarAdvanced.getQueueInfo(); // Статистика
```

## Демо

Запустите `TopSnackBarDemo` из папки `examples/` для интерактивного тестирования всех возможностей.

## Документация

Подробная документация находится в файле [`TOP_SNACK_BAR_GUIDE.md`](TOP_SNACK_BAR_GUIDE.md).

---

💡 **Совет**: Всегда вызывайте `TopSnackBar.dispose()` в методе `dispose()` ваших виджетов для правильной очистки ресурсов.
