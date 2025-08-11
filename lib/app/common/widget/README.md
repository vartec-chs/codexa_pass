# Messenger Widgets

Набор виджетов для демонстрации и тестирования возможностей ScaffoldMessengerManager.

## Виджеты

### 1. MessengerDemoWidget

Полнофункциональный виджет для демонстрации всех возможностей ScaffoldMessengerManager.

**Возможности:**
- Демонстрация всех типов SnackBar (Error, Warning, Info, Success)
- Тестирование MaterialBanner
- Готовые пресеты для типичных сценариев
- Тестирование очереди сообщений
- Управление уведомлениями
- Анимации и современный UI

**Использование:**
```dart
Scaffold(
  body: SingleChildScrollView(
    child: MessengerDemoWidget(),
  ),
)
```

### 2. MessengerDebugPanel

Компактная отладочная панель для быстрого тестирования во время разработки.

**Возможности:**
- Компактный интерфейс (56x56 в свернутом виде)
- Расширяется до полной панели управления
- Быстрые кнопки для всех типов уведомлений
- Тестирование очереди
- Индикатор количества сообщений в очереди
- Настраиваемое положение на экране

**Использование:**
```dart
// Автоматическое добавление панели
MessengerDebugWrapper(
  child: YourWidget(),
)

// Или ручное размещение
Stack(
  children: [
    YourWidget(),
    MessengerDebugPanel(
      position: MessengerDebugPosition.bottomRight,
    ),
  ],
)
```

**Позиции панели:**
- `topLeft` - верхний левый угол
- `topRight` - верхний правый угол  
- `bottomLeft` - нижний левый угол
- `bottomRight` - нижний правый угол (по умолчанию)

### 3. SimpleMessengerTest

Простой тестовый экран с отладочной панелью для быстрого начала работы.

**Возможности:**
- Готовый экран для тестирования
- Встроенная отладочная панель
- Переход к полному демо
- Информационные карточки

**Использование:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SimpleMessengerTest(),
  ),
)
```

### 4. QuickMessengerDemo

Минималистичный виджет для быстрого тестирования основных функций.

**Возможности:**
- 4 кнопки для основных типов уведомлений
- Компактный размер
- Легко встраивается в любой экран

**Использование:**
```dart
Column(
  children: [
    YourContent(),
    QuickMessengerDemo(),
  ],
)
```

## Примеры интеграции

### В режиме разработки

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: ScaffoldMessengerManager.globalKey,
      home: MessengerDebugWrapper(
        child: HomeScreen(),
      ),
    );
  }
}
```

### Для тестирования в отдельном экране

```dart
class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: MessengerDemoWidget(),
    );
  }
}
```

### Быстрая проверка в любом месте

```dart
class AnyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Ваш контент
          YourMainContent(),
          
          // Быстрый тест в конце
          if (kDebugMode) QuickMessengerDemo(),
        ],
      ),
    );
  }
}
```

## Настройка

Все виджеты автоматически используют текущую тему приложения и адаптируются под светлый/темный режим.

Для кастомизации ScaffoldMessengerManager используйте:

```dart
ScaffoldMessengerManager.instance.configure(
  snackBarBuilder: YourCustomSnackBarBuilder(),
  bannerBuilder: YourCustomBannerBuilder(),
);
```

## Лучшие практики

1. **Используйте MessengerDebugWrapper** в режиме разработки для быстрого доступа к тестированию
2. **QuickMessengerDemo** подходит для быстрой проверки базовых функций  
3. **MessengerDemoWidget** используйте для полной демонстрации возможностей
4. **SimpleMessengerTest** идеален как отдельный экран для тестирования
5. Панель автоматически скрывается в production сборках

## Зависимости

Все виджеты зависят от ScaffoldMessengerManager и должны использоваться только после его правильной настройки в приложении.
