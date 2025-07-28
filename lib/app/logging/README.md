# Flutter Logger System

Продвинутая система логирования для Flutter приложений с поддержкой файлового логирования, ротации логов, сессий и краш-репортов.

## Особенности

- ✅ Все стандартные уровни логирования (debug, info, warning, error, fatal, crash)
- ✅ Запись в файлы по датам с учетом переходного времени
- ✅ Краш-репорты с автоматическим сбросом на диск
- ✅ Красивый консольный вывод
- ✅ Структурированная запись в JSON формате
- ✅ Сессии с полной информацией об устройстве и приложении
- ✅ Ротация по размеру и ограничение общего объема
- ✅ Буферизация в памяти с периодическим сбросом
- ✅ Асинхронная и неблокирующая запись

## Установка

Добавьте в `pubspec.yaml`:

```yaml
dependencies:
  logger: ^2.6.1
  path_provider: ^2.1.5
  path: ^1.9.1
  device_info_plus: ^11.5.0
  package_info_plus: ^8.3.0
  uuid: ^4.5.1
```

## Быстрый старт

### Инициализация

```dart
import 'package:flutter/material.dart';
import 'system/logging/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация с настройками по умолчанию
  await initLogger();
  
  // Или с кастомными настройками
  await initLogger(
    config: const LoggerConfig(
      enableFileLogging: true,
      enableConsoleLogging: true,
      maxFileSize: 10 * 1024 * 1024, // 10MB
      maxTotalSize: 100 * 1024 * 1024, // 100MB
      flushIntervalMs: 5000, // 5 секунд
      maxMemoryEntries: 100,
      minLevel: AppLogLevel.debug,
      enableSessionLogging: true,
    ),
  );
  
  runApp(MyApp());
}
```

### Использование

```dart
// Простое логирование
logDebug('Debug сообщение');
logInfo('Информационное сообщение');
logWarning('Предупреждение');
logError('Ошибка');
logFatal('Критическая ошибка');
logCrash('Краш приложения');

// С тегами
logInfo('Пользователь вошел в систему', tag: 'AUTH');
logError('Ошибка подключения к серверу', tag: 'NETWORK');

// С дополнительными данными
logInfo('Покупка совершена', tag: 'PURCHASE', extra: {
  'userId': 12345,
  'productId': 'premium_subscription',
  'amount': 99.99,
  'currency': 'USD',
});

// С трассировкой стека
try {
  throw Exception('Что-то пошло не так');
} catch (e, stackTrace) {
  logError('Ошибка в обработке данных: $e', 
           tag: 'DATA_PROCESSING',
           stackTrace: stackTrace.toString());
}
```

### Использование через экземпляр

```dart
// Получение экземпляра логгера
final logger = AppLogger.instance;

// Все те же методы доступны
logger.debug('Debug сообщение');
logger.info('Info сообщение');
logger.warning('Warning сообщение');
logger.error('Error сообщение');
logger.fatal('Fatal сообщение');
logger.crash('Crash сообщение');
```

## Конфигурация

### LoggerConfig параметры

```dart
const LoggerConfig({
  this.enableFileLogging = true,        // Включить запись в файлы
  this.enableConsoleLogging = true,     // Включить консольный вывод
  this.maxFileSize = 10 * 1024 * 1024,  // Максимальный размер файла (10MB)
  this.maxTotalSize = 100 * 1024 * 1024, // Максимальный общий размер (100MB)
  this.flushIntervalMs = 5000,          // Интервал сброса на диск (5 сек)
  this.maxMemoryEntries = 100,          // Максимум записей в памяти
  this.minLevel = AppLogLevel.debug,    // Минимальный уровень логирования
  this.enableSessionLogging = true,     // Включить логирование сессий
});
```

## Структура файлов логов

Логи сохраняются в директории приложения:
- `logs/app_log_YYYY-MM-DD.jsonl` - основные логи по дням **с встроенной информацией о сессии**

### Формат файла лога

Каждый файл лога начинается с комментария, содержащего информацию о сессии, затем следует запись о начале сессии и все последующие логи:

```
// Session Info: {"sessionId":"uuid","startTime":"2025-01-26T10:00:00.000Z","deviceInfo":{...},"appInfo":{...}}
{"sessionId":"uuid","timestamp":"2025-01-26T10:00:00.123Z","level":"info","message":"Session started","tag":"SESSION","extra":{"sessionInfo":{...},"config":{...}}}
{"sessionId":"uuid","timestamp":"2025-01-26T10:30:45.123Z","level":"info","message":"Сообщение лога","tag":"MY_TAG","extra":{"key":"value"}}
```

### Формат записи лога

```json
{
  "sessionId": "uuid-сессии",
  "timestamp": "2025-01-26T10:30:45.123Z",
  "level": "info",
  "message": "Сообщение лога",
  "tag": "MY_TAG",
  "extra": {
    "key": "value",
    "userId": 123
  },
  "stackTrace": "стек вызовов при ошибке"
}
```

### Запись информации о сессии

Информация о сессии автоматически записывается в каждый новый файл лога и включает:
- Полную информацию об устройстве (платформа, модель, версия ОС и т.д.)
- Информацию о приложении (название, версия, номер сборки)
- Конфигурацию логгера
- Уникальный ID сессии

## Работа с логами

### Получение логов

```dart
// Логи за определенную дату
final logs = await logger.getLogsByDate(DateTime.now());

// Логи определенного уровня
final errorLogs = await logger.getLogsByLevel(AppLogLevel.error);

// Логи за период
final crashLogs = await logger.getLogsByLevel(
  AppLogLevel.crash,
  from: DateTime.now().subtract(Duration(days: 7)),
  to: DateTime.now(),
);

// Информация о текущей сессии
final sessionInfo = await logger.getSessionInfo();

// Информация о сессии из файла логов
final sessionFromFile = await logger.getSessionInfoFromLogFile(DateTime.now());

// Статистика логов
final stats = await logger.getLogStatistics(
  from: DateTime.now().subtract(Duration(days: 30)),
  to: DateTime.now(),
);
// Результат: {totalLogs: 1500, levelCounts: {debug: 800, info: 500, ...}, uniqueSessions: 25, topTags: [...]}

// Фильтрованные логи
final filteredLogs = await logger.getFilteredLogs(
  from: DateTime.now().subtract(Duration(days: 1)),
  levels: [AppLogLevel.error, AppLogLevel.crash],
  tags: ['NETWORK', 'DATABASE'],
  messageContains: 'connection',
  limit: 100,
);

// Экспорт логов в JSON
final jsonExport = await logger.exportLogsToJson(
  from: DateTime.now().subtract(Duration(days: 7)),
  levels: [AppLogLevel.error, AppLogLevel.crash],
);

// Удобные функции для получения ошибок и крашей
final errors = await getErrors(from: DateTime.now().subtract(Duration(days: 1)));
final crashes = await getCrashReports(from: DateTime.now().subtract(Duration(days: 7)));
```

### Принудительный сброс

```dart
// Принудительно сбросить все буферизованные логи на диск
await logger.flush();
```

## Ротация логов

Система автоматически управляет размером логов:

1. **По размеру файла**: когда файл превышает `maxFileSize`, создается новый ротированный файл
2. **По общему размеру**: когда общий размер превышает `maxTotalSize`, удаляются старые файлы
3. **Автоматическая очистка**: старые файлы удаляются в порядке их создания

## Производительность

- **Асинхронная запись**: все операции записи выполняются асинхронно
- **Буферизация**: логи накапливаются в памяти и сбрасываются пакетами
- **Неблокирующие операции**: логирование не блокирует UI поток
- **Оптимизированный JSON**: эффективная сериализация данных

## Обработка ошибок

Логгер автоматически перехватывает:
- Flutter ошибки (`FlutterError.onError`)
- Dart ошибки (`PlatformDispatcher.instance.onError`)
- Isolate ошибки (`Isolate.current.addErrorListener`)

## Пример полного использования

```dart
import 'package:flutter/material.dart';
import 'system/logging/logger.dart';

class MyService {
  Future<void> performOperation() async {
    logInfo('Начинаем операцию', tag: 'SERVICE');
    
    try {
      // Имитация работы
      await Future.delayed(Duration(seconds: 2));
      
      logInfo('Операция завершена успешно', tag: 'SERVICE', extra: {
        'duration': 2000,
        'result': 'success'
      });
      
    } catch (e, stackTrace) {
      logError('Ошибка при выполнении операции: $e', 
               tag: 'SERVICE',
               extra: {'operation': 'performOperation'},
               stackTrace: stackTrace.toString());
      rethrow;
    }
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final MyService _service = MyService();
  
  @override
  void initState() {
    super.initState();
    logDebug('MyWidget инициализирован', tag: 'WIDGET');
  }
  
  void _handleButtonPress() async {
    logInfo('Кнопка нажата', tag: 'UI', extra: {
      'widget': 'MyWidget',
      'action': 'button_press'
    });
    
    try {
      await _service.performOperation();
    } catch (e) {
      logWarning('Операция не удалась, показываем пользователю ошибку', tag: 'UI');
      // Показать SnackBar или диалог
    }
  }
  
  @override
  void dispose() {
    logDebug('MyWidget уничтожен', tag: 'WIDGET');
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _handleButtonPress,
          child: Text('Выполнить операцию'),
        ),
      ),
    );
  }
}
```

## Тестирование

Система включает тесты для проверки основной функциональности:

```bash
flutter test test/logger_test.dart
```

## Устранение неполадок

### Логи не записываются в файлы
- Проверьте, что `enableFileLogging = true`
- Убедитесь, что приложение имеет права на запись
- Проверьте доступное место на диске

### Плохая производительность
- Увеличьте `flushIntervalMs` для менее частых сбросов
- Уменьшите `maxMemoryEntries`
- Повысьте `minLevel` для фильтрации ненужных логов

### Логи занимают много места
- Уменьшите `maxTotalSize` и `maxFileSize`
- Повысьте `minLevel` в продакшене
- Реализуйте внешнюю отправку логов с последующим удалением

## Лицензия

MIT License
