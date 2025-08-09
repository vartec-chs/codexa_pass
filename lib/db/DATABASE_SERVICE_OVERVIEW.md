# Сервис управления базами данных AppEncryptedDatabase

## Обзор

Создан комплексный сервис для управления зашифрованными базами данных с использованием Riverpod state management. Сервис предоставляет полный функционал для создания, открытия, закрытия, удаления и управления SQLCipher базами данных.

## Созданные файлы

### 📁 `lib/db/services/`

1. **`database_service.dart`** - Основной сервис для работы с БД
   - Создание и открытие баз данных
   - Управление паролями и шифрованием
   - Резервное копирование и восстановление
   - Валидация и проверка целостности

2. **`database_state_notifier.dart`** - StateNotifier для управления состоянием
   - Реактивное управление состоянием БД
   - Асинхронные операции с обработкой ошибок
   - Автоматическое обновление списка БД

3. **`database_providers.dart`** - Провайдеры Riverpod
   - 15+ специализированных провайдеров
   - Удобные действия через `DatabaseActions`
   - Фильтрация и поиск БД

4. **`database_services.dart`** - Barrel файл для экспорта
5. **`README.md`** - Подробная документация

### 📁 `lib/db/examples/`

1. **`database_manager_example.dart`** - Полнофункциональный пример UI
2. **`database_integration_example.dart`** - Простой пример интеграции

### 📁 `lib/db/`

1. **`database.dart`** - Главный экспорт файл

## Ключевые возможности

### ✅ Управление БД
- ✅ Создание новых зашифрованных БД
- ✅ Открытие существующих БД с паролем
- ✅ Закрытие активных подключений
- ✅ Удаление БД с подтверждением
- ✅ Автоматическое сканирование доступных БД

### ✅ Безопасность
- ✅ SQLCipher шифрование
- ✅ Защита паролей в памяти
- ✅ Валидация доступа к БД
- ✅ Обработка поврежденных файлов

### ✅ Riverpod интеграция
- ✅ Реактивное состояние
- ✅ Автоматические обновления UI
- ✅ Централизованная обработка ошибок
- ✅ Оптимизированные провайдеры

### ✅ Резервное копирование
- ✅ Создание backup файлов
- ✅ Восстановление из backup
- ✅ Проверка целостности при восстановлении

### ✅ Мониторинг
- ✅ Отслеживание размеров БД
- ✅ История изменений
- ✅ Статистика использования
- ✅ Индикаторы состояния

## Быстрый старт

### 1. Импорт сервиса

```dart
import 'package:codexa_pass/db/database.dart';
```

### 2. Создание БД

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(databaseActionsProvider);
    
    return ElevatedButton(
      onPressed: () => actions.createDatabase(
        DatabaseCreationRequest(
          name: 'MyDB',
          masterPassword: 'SecurePass123',
          description: 'Описание БД',
        ),
      ),
      child: Text('Создать БД'),
    );
  }
}
```

### 3. Отслеживание состояния

```dart
class DatabaseStatus extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDb = ref.watch(currentDatabaseInfoProvider);
    final isLoading = ref.watch(isDatabaseLoadingProvider);
    final databases = ref.watch(availableDatabasesProvider);
    
    return Column(
      children: [
        if (isLoading) CircularProgressIndicator(),
        if (currentDb != null) Text('Открыта: ${currentDb.name}'),
        Text('Всего БД: ${databases.length}'),
      ],
    );
  }
}
```

## Провайдеры

### Основные
- `databaseStateProvider` - Главное состояние
- `databaseActionsProvider` - Действия для управления
- `currentDatabaseProvider` - Текущая БД
- `currentDatabaseInfoProvider` - Информация о текущей БД

### Состояние
- `isDatabaseOpenProvider` - Открыта ли БД
- `isDatabaseLoadingProvider` - Индикатор загрузки
- `databaseErrorProvider` - Ошибки
- `availableDatabasesProvider` - Список всех БД

### Утилиты
- `databasesByStatusProvider` - Фильтр по статусу
- `databaseCountProvider` - Количество БД
- `totalDatabasesSizeProvider` - Общий размер
- `databaseByNameProvider` - Поиск по имени
- `databaseByPathProvider` - Поиск по пути

## Типы данных

### `DatabaseState`
```dart
class DatabaseState {
  final List<DatabaseInfo> databases;
  final bool isLoading;
  final DatabaseInfo? currentDatabase;
  final String? error;
}
```

### `DatabaseInfo`
```dart
class DatabaseInfo {
  final String name;
  final String path;
  final DateTime createdAt;
  final DateTime lastModified;
  final int size;
  final DatabaseStatus status;
  final String description;
  final bool isCustomPath;
}
```

### `DatabaseCreationRequest`
```dart
class DatabaseCreationRequest {
  final String name;
  final String masterPassword;
  final String description;
  final bool useDefaultPath;
  final String customPath;
}
```

## Обработка ошибок

### Через исключения
```dart
try {
  await actions.openDatabase(path: path, password: password);
} on DatabaseException catch (e) {
  print('Ошибка БД: ${e.message}');
}
```

### Через провайдер
```dart
ref.listen(databaseErrorProvider, (previous, next) {
  if (next != null) {
    showErrorSnackBar(next);
  }
});
```

## Примеры использования

1. **`database_manager_example.dart`** - Полный UI для управления БД
2. **`database_integration_example.dart`** - Простая интеграция

## Зависимости

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  drift: ^2.28.0
  path_provider: ^2.1.5
  path: ^1.9.1
```

## Безопасность

- 🔒 SQLCipher шифрование по умолчанию
- 🔒 Пароли не кешируются
- 🔒 Автоматическое закрытие подключений
- 🔒 Валидация целостности файлов

## Производительность

- ⚡ Асинхронные операции
- ⚡ Кеширование списка БД
- ⚡ Оптимизированные провайдеры
- ⚡ Ленивая инициализация

## Следующие шаги

1. Интеграция в основное приложение
2. Добавление в роутинг
3. Создание UI компонентов
4. Настройка автоматических backup
5. Добавление миграций схемы

## Тестирование

Для тестирования используйте `database_integration_example.dart`:

```dart
// В main.dart или любом месте приложения
MaterialApp(
  home: DatabaseIntegrationExample(),
)
```

Этот пример покажет все возможности сервиса в простом интерфейсе.
