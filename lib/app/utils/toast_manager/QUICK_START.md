# Toast Manager - Краткое руководство

## Что создано

✅ **Полная система Toast Manager** с очередью и анимациями  
✅ **4 типа тостов**: Success, Error, Warning, Info  
✅ **Умная очередь**: максимум 3 активных, приоритеты для ошибок  
✅ **Красивый UI**: анимации, темы, прогресс-бар  
✅ **Кастомные действия**: кнопки в тостах  
✅ **Позиционирование**: сверху/снизу экрана  
✅ **Демо-страница**: полное тестирование функций  

## Структура файлов

```
lib/app/utils/toast_manager/
├── toast_manager.dart          # 🎯 Основной менеджер
├── toast_models.dart           # 📋 Модели и типы
├── toast_ui.dart              # 🎨 UI виджет
├── toast_utils.dart           # 🛠️ Утилиты 
├── toast_manager_export.dart  # 📦 Экспорты
├── index.dart                 # 📖 Главный экспорт
├── README.md                  # 📚 Документация
└── demo/
    └── toast_demo.dart        # 🎮 Демо-страница
```

## Инициализация

Toast Manager автоматически инициализируется в `app.dart` с глобальным `navigatorKey`.

## Быстрое использование

```dart
// Импорт
import 'package:codexa_pass/app/utils/toast_manager/toast_manager_export.dart';

// Простые тосты
ToastUtils.success('Готово!');
ToastUtils.error('Ошибка!'); 
ToastUtils.warning('Внимание!');
ToastUtils.info('Информация');

// Через контекст
context.showToastSuccess('Успех!');
context.showToastError('Ошибка!');

// С действиями
ToastUtils.confirmAction(
  title: 'Удалить файл?',
  confirmLabel: 'Удалить',
  onConfirm: () => print('Удален'),
);

// Прогресс
ToastUtils.progress(
  title: 'Загрузка...',
  duration: Duration(seconds: 3),
);
```

## Тестирование

1. **Демо-страница**: Перейди на `/toast-demo` 
2. **Главный экран**: Кнопка "Toast Manager Demo"
3. **Быстрые тесты**: В `HomeActions` есть методы тестирования

## Особенности

- **Очередь**: Тосты автоматически становятся в очередь
- **Приоритеты**: Ошибки прерывают очередь
- **Анимации**: Slide + Fade + Scale
- **Темы**: Автоматическая адаптация
- **Позиции**: Умное смещение при множественных тостах

## Управление

```dart
// Статистика
ToastManager.queueLength;     // В очереди
ToastManager.activeCount;     // Активных

// Очистка
ToastManager.dismissAll();    // Скрыть все
ToastManager.clearQueue();    // Очистить очередь
ToastUtils.clear();          // Все сразу
```

## Готово к использованию! 🎉

Система полностью настроена и готова к работе.
