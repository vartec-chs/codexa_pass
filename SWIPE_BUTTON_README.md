# SwipeButton - Переиспользуемый компонент

Переиспользуемый компонент для подтверждения действий свайпом с анимациями и иконками.

## Особенности

- ✨ **Анимации**: Плавные анимации слайда, успеха и подсказок
- 🎨 **Кастомизация**: Полная настройка цветов, размеров и иконок  
- 📱 **Тактильная обратная связь**: Вибрация при успешном действии
- 🎯 **Готовые стили**: Предустановленные стили для разных типов действий
- 🔄 **Автосброс**: Автоматический возврат при неполном свайпе
- ⚠️ **Двойное подтверждение**: Поддержка критических действий
- ⏱️ **Таймаут**: Автоматическое отключение через заданное время

## Базовое использование

```dart
import 'package:codexa_pass/app/common/widget/swipe_button.dart';

SwipeButton(
  onSwipeComplete: () {
    // Ваш код действия
    print('Действие подтверждено!');
  },
  text: 'Свайпните для подтверждения',
  icon: Icons.check,
)
```

## Готовые стили

### Опасное действие (удаление)
```dart
SwipeButtonStyles.danger(
  onSwipeComplete: () => deleteItem(),
)
```

### Успешное действие (сохранение)
```dart
SwipeButtonStyles.success(
  onSwipeComplete: () => saveData(),
)
```

### Предупреждение
```dart
SwipeButtonStyles.warning(
  onSwipeComplete: () => performWarningAction(),
)
```

### Информационное действие
```dart
SwipeButtonStyles.info(
  onSwipeComplete: () => showInfo(),
)
```

## Кастомизация

```dart
SwipeButton(
  onSwipeComplete: () => customAction(),
  text: 'Свайп для магии ✨',
  icon: Icons.auto_awesome,
  height: 70,
  backgroundColor: Colors.purple.withOpacity(0.1),
  sliderColor: Colors.purple,
  textColor: Colors.purple.shade700,
  borderColor: Colors.purple.shade300,
  iconColor: Colors.white,
  borderRadius: 35,
  fontSize: 18,
  iconSize: 28,
  threshold: 0.7, // 70% свайпа для активации
  showArrows: true, // Показывать анимированные стрелки
)
```

## Продвинутые функции

### Двойное подтверждение
Для критических действий, требующих двойного подтверждения:

```dart
AdvancedSwipeButton(
  onSwipeComplete: () => criticalAction(),
  text: 'Критическое действие',
  icon: Icons.warning_amber,
  requiresDoubleConfirmation: true,
  timeoutDuration: Duration(seconds: 30),
  onTimeout: () => print('Время истекло'),
)
```

## Параметры SwipeButton

| Параметр | Тип | По умолчанию | Описание |
|----------|-----|--------------|----------|
| `onSwipeComplete` | `VoidCallback` | **обязательный** | Функция, вызываемая при успешном свайпе |
| `text` | `String` | `'Свайпните для подтверждения'` | Текст на кнопке |
| `icon` | `IconData` | `Icons.arrow_forward` | Иконка на слайдере |
| `width` | `double?` | `null` | Ширина кнопки (auto если null) |
| `height` | `double` | `60.0` | Высота кнопки |
| `backgroundColor` | `Color?` | `null` | Цвет фона (авто из темы если null) |
| `sliderColor` | `Color?` | `null` | Цвет слайдера (primary из темы если null) |
| `textColor` | `Color?` | `null` | Цвет текста (onSurface из темы если null) |
| `iconColor` | `Color?` | `null` | Цвет иконки (onPrimary из темы если null) |
| `borderRadius` | `double` | `30.0` | Радиус скругления |
| `borderWidth` | `double` | `2.0` | Толщина границы |
| `borderColor` | `Color?` | `null` | Цвет границы (outline из темы если null) |
| `enabled` | `bool` | `true` | Включена ли кнопка |
| `showSuccessAnimation` | `bool` | `true` | Показывать ли анимацию успеха |
| `animationDuration` | `Duration` | `Duration(milliseconds: 300)` | Длительность анимации |
| `threshold` | `double` | `0.85` | Минимальный процент свайпа для активации (0.0 - 1.0) |
| `showArrows` | `bool` | `true` | Показывать ли анимированные стрелки-подсказки |
| `iconSize` | `double` | `24.0` | Размер иконки |
| `fontSize` | `double` | `16.0` | Размер текста |

## Параметры AdvancedSwipeButton

Дополнительные параметры для продвинутой версии:

| Параметр | Тип | По умолчанию | Описание |
|----------|-----|--------------|----------|
| `requiresDoubleConfirmation` | `bool` | `false` | Требует два свайпа для подтверждения |
| `timeoutDuration` | `Duration` | `Duration(seconds: 30)` | Время до автоотключения |
| `onTimeout` | `VoidCallback?` | `null` | Функция, вызываемая при истечении времени |

## Примеры использования в приложении

### В форме подтверждения заказа
```dart
SwipeButtonStyles.success(
  onSwipeComplete: () async {
    await processOrder();
    Navigator.pop(context);
  },
)
```

### В настройках для сброса данных
```dart
SwipeButtonStyles.danger(
  onSwipeComplete: () => showResetConfirmation(context),
)
```

### В процессе авторизации
```dart
SwipeButton(
  onSwipeComplete: () => authenticateUser(),
  text: 'Свайпните для входа',
  icon: Icons.login,
  backgroundColor: Colors.green.withOpacity(0.1),
  sliderColor: Colors.green,
)
```

## Состояния кнопки

1. **Активная** - готова к взаимодействию, показывает анимированные стрелки
2. **В процессе свайпа** - пользователь начал свайп, стрелки останавливаются
3. **Завершенная** - свайп завершен успешно, показывается анимация успеха
4. **Сброшенная** - свайп не завершен, кнопка возвращается в исходное состояние
5. **Отключенная** - кнопка неактивна, серый цвет

## Анимации

- **Слайд анимация**: Плавное движение слайдера
- **Анимация стрелок**: Пульсирующие стрелки-подсказки
- **Анимация успеха**: Масштабирование иконки при завершении
- **Тактильная обратная связь**: Вибрация при успешном действии

## Интеграция с темой

Компонент автоматически адаптируется к текущей теме приложения:

- Использует цвета из `ColorScheme`
- Поддерживает светлую и темную темы
- Автоматические цвета с прозрачностью для фона

## Файлы

- `lib/app/common/widget/swipe_button.dart` - Основной компонент
- `lib/demo/swipe_button_demo.dart` - Полная демонстрация с примерами
- `lib/demo/swipe_button_example.dart` - Простые примеры использования

## Зависимости

Компонент использует только стандартные Flutter виджеты и не требует дополнительных зависимостей.
