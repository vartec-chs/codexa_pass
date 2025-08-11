# Toast Manager - Обновление UI

## Что нового?

### 🎨 Современный дизайн
- **Градиентные фоны** вместо обычных цветов
- **Убраны borders** для более чистого вида
- **Blur эффект** (BackdropFilter) для глубины
- **Современные тени** с несколькими слоями
- **Округлые углы** (16px) и современная типографика

### 📍 Новые позиции тостов
- `ToastPosition.top` - центр сверху (полная ширина)
- `ToastPosition.topLeft` - левый верхний угол
- `ToastPosition.topRight` - правый верхний угол
- `ToastPosition.bottom` - центр снизу (полная ширина)
- `ToastPosition.bottomLeft` - левый нижний угол
- `ToastPosition.bottomRight` - правый нижний угол
- `ToastPosition.left` - левая сторона (по центру)
- `ToastPosition.right` - правая сторона (по центру)

### ✨ Улучшенные анимации
- **Elastic bounce** эффект при появлении
- **Современные кривые** анимации (easeOutCubic)
- **Плавная прозрачность** и масштабирование
- **Правильные направления** анимации для каждой позиции

### 🎯 Умное позиционирование
- **Автоматическая ширина** для боковых позиций (320px max)
- **Полная ширина** для верхних/нижних позиций
- **Умные отступы** (16px от краев)
- **Правильное наложение** для множественных тостов

## Примеры использования

### Базовое использование
```dart
ToastManager.show(ToastConfig(
  id: ToastManager.generateId(),
  title: 'Успешно!',
  subtitle: 'Данные сохранены',
  type: ToastType.success,
  position: ToastPosition.topRight,
));
```

### С кастомными действиями
```dart
ToastManager.show(ToastConfig(
  id: ToastManager.generateId(),
  title: 'Удалить файл?',
  subtitle: 'Это действие нельзя отменить',
  type: ToastType.error,
  position: ToastPosition.bottom,
  actions: [
    ToastAction(
      label: 'Отмена',
      onPressed: () => ToastManager.dismissAll(),
      icon: Icons.cancel,
    ),
    ToastAction(
      label: 'Удалить',
      onPressed: () {
        // логика удаления
        ToastManager.dismissAll();
        ToastUtils.success('Файл удален');
      },
      icon: Icons.delete,
      color: Colors.red,
    ),
  ],
));
```

### Боковые позиции
```dart
// Левая сторона
ToastManager.show(ToastConfig(
  id: ToastManager.generateId(),
  title: 'Уведомление',
  subtitle: 'Новое сообщение получено',
  type: ToastType.info,
  position: ToastPosition.left,
));

// Правая сторона  
ToastManager.show(ToastConfig(
  id: ToastManager.generateId(),
  title: 'Ошибка сети',
  subtitle: 'Проверьте подключение',
  type: ToastType.error,
  position: ToastPosition.right,
));
```

## Технические изменения

### Файловая структура
- `toast_ui_new.dart` - новый современный UI компонент
- `toast_models.dart` - обновленные модели с градиентами
- `toast_manager.dart` - поддержка новых позиций
- `demo/toast_demo.dart` - обновленная демо страница

### Цветовые схемы
```dart
class ToastColors {
  final Gradient? gradient;      // Новое: градиентный фон
  final Color accentColor;       // Новое: акцентный цвет
  final Color shadowColor;       // Обновлено: цвет тени
  // ... остальные цвета
}
```

### Позиционирование
- Используется `Positioned` с отдельными методами для каждой стороны
- Умное вычисление отступов в `getToastOffset()`
- Поддержка наложения тостов в одной позиции

## Демо и тестирование

Перейдите в приложение → "Toast Demo" для тестирования всех новых функций:

1. **Базовые тосты** - success, error, warning, info
2. **Тесты позиций** - все 8 позиций с разными типами
3. **Тосты с действиями** - подтверждения, отмены, сохранения
4. **Управление очередью** - показать много тостов, скрыть все

## Совместимость

- ✅ Полная обратная совместимость с существующим кодом
- ✅ Все старые методы `ToastUtils` работают
- ✅ Существующие `ToastConfig` остаются без изменений
- ⚡ Новые возможности доступны сразу

## Производительность

- **Оптимизированные анимации** с правильными кривыми
- **Эффективное использование Overlay** без утечек памяти
- **Умное управление ресурсами** (автоматический dispose)
- **Минимальное влияние на UI** основного приложения
