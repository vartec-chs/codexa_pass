# Сервис управления базами данных

Комплексный сервис для управления зашифрованными базами данных AppEncryptedDatabase с использованием Riverpod.

## Структура файлов

```
lib/db/services/
├── database_service.dart           # Основной сервис для работы с БД
├── database_state_notifier.dart    # StateNotifier для управления состоянием
├── database_providers.dart         # Провайдеры Riverpod
├── database_services.dart          # Barrel file для экспорта
└── ../examples/
    └── database_manager_example.dart # Пример использования
```

## Быстрый старт

### 1. Импорт

```dart
import 'package:codexa_pass/db/services/database_services.dart';
import 'package:codexa_pass/db/database_state.dart';
```

### 2. Основные операции

#### Создание новой базы данных

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseActions = ref.read(databaseActionsProvider);
    
    return ElevatedButton(
      onPressed: () async {
        try {
          await databaseActions.createDatabase(
            DatabaseCreationRequest(
              name: 'MyDatabase',
              masterPassword: 'SecurePassword123',
              description: 'Моя личная база данных',
            ),
          );
        } catch (e) {
          // Обработка ошибки
        }
      },
      child: Text('Создать БД'),
    );
  }
}
```

#### Открытие существующей базы данных

```dart
class OpenDatabaseWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseActions = ref.read(databaseActionsProvider);
    
    return ElevatedButton(
      onPressed: () async {
        try {
          await databaseActions.openDatabase(
            path: '/path/to/database.db',
            password: 'SecurePassword123',
          );
        } catch (e) {
          // Обработка ошибки
        }
      },
      child: Text('Открыть БД'),
    );
  }
}
```

### 3. Отслеживание состояния

#### Получение информации о текущей БД

```dart
class DatabaseInfoWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDb = ref.watch(currentDatabaseInfoProvider);
    final isOpen = ref.watch(isDatabaseOpenProvider);
    final isLoading = ref.watch(isDatabaseLoadingProvider);
    final error = ref.watch(databaseErrorProvider);
    
    if (isLoading) {
      return CircularProgressIndicator();
    }
    
    if (error != null) {
      return Text('Ошибка: $error');
    }
    
    if (currentDb != null) {
      return Column(
        children: [
          Text('Открыта БД: ${currentDb.name}'),
          Text('Размер: ${currentDb.size} байт'),
          Text('Создана: ${currentDb.createdAt}'),
        ],
      );
    }
    
    return Text('Нет открытой БД');
  }
}
```

#### Список доступных баз данных

```dart
class DatabaseListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databases = ref.watch(availableDatabasesProvider);
    final databaseActions = ref.read(databaseActionsProvider);
    
    // Загружаем список при первом отображении
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        databaseActions.loadAvailableDatabases();
      });
      return null;
    }, []);
    
    return ListView.builder(
      itemCount: databases.length,
      itemBuilder: (context, index) {
        final db = databases[index];
        return ListTile(
          title: Text(db.name),
          subtitle: Text('Размер: ${db.size} байт'),
          trailing: Icon(
            db.status == DatabaseStatus.open 
              ? Icons.lock_open 
              : Icons.lock,
          ),
          onTap: () {
            // Открыть БД
          },
        );
      },
    );
  }
}
```

## Доступные провайдеры

### Основные провайдеры

- `databaseStateProvider` - Основное состояние управления БД
- `databaseActionsProvider` - Действия для управления БД
- `currentDatabaseProvider` - Текущая открытая база данных
- `currentDatabaseInfoProvider` - Информация о текущей БД

### Провайдеры состояния

- `isDatabaseOpenProvider` - Проверка, открыта ли БД
- `isDatabaseLoadingProvider` - Индикатор загрузки
- `databaseErrorProvider` - Текущая ошибка
- `availableDatabasesProvider` - Список доступных БД

### Утилитарные провайдеры

- `databasesByStatusProvider` - Фильтрация БД по статусу
- `databaseCountProvider` - Количество БД
- `lastModifiedDatabaseProvider` - Последняя измененная БД
- `totalDatabasesSizeProvider` - Общий размер всех БД
- `databaseExistsProvider` - Проверка существования БД по пути
- `databaseByNameProvider` - Поиск БД по имени
- `databaseByPathProvider` - Поиск БД по пути

## Доступные действия

### DatabaseActions

```dart
final databaseActions = ref.read(databaseActionsProvider);

// Создать новую БД
await databaseActions.createDatabase(request);

// Открыть БД
await databaseActions.openDatabase(path: path, password: password);

// Закрыть БД
await databaseActions.closeDatabase();

// Удалить БД
await databaseActions.deleteDatabase(path);

// Загрузить список доступных БД
await databaseActions.loadAvailableDatabases();

// Проверить пароль
bool isValid = await databaseActions.verifyPassword(path, password);

// Изменить пароль
await databaseActions.changePassword(newPassword);

// Создать резервную копию
await databaseActions.backupDatabase(backupPath);

// Восстановить из резервной копии
await databaseActions.restoreDatabase(
  backupPath: backupPath,
  password: password,
  targetPath: targetPath,
);

// Очистить ошибку
databaseActions.clearError();

// Обновить информацию о текущей БД
await databaseActions.refreshCurrentDatabase();
```

## Обработка ошибок

Все методы могут выбрасывать `DatabaseException` с описанием ошибки:

```dart
try {
  await databaseActions.openDatabase(
    path: path,
    password: password,
  );
} on DatabaseException catch (e) {
  // Обработка специфичных ошибок БД
  print('Ошибка БД: ${e.message}');
} catch (e) {
  // Обработка других ошибок
  print('Общая ошибка: $e');
}
```

Также можно отслеживать ошибки через состояние:

```dart
ref.listen(databaseErrorProvider, (previous, next) {
  if (next != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка: $next')),
    );
  }
});
```

## Типы данных

### DatabaseState

```dart
class DatabaseState {
  final List<DatabaseInfo> databases;  // Список доступных БД
  final bool isLoading;                // Состояние загрузки
  final DatabaseInfo? currentDatabase; // Текущая открытая БД
  final String? error;                 // Текущая ошибка
}
```

### DatabaseInfo

```dart
class DatabaseInfo {
  final String name;               // Имя БД
  final String path;               // Путь к файлу
  final DateTime createdAt;        // Дата создания
  final DateTime lastModified;     // Дата изменения
  final int size;                  // Размер файла
  final DatabaseStatus status;     // Статус БД
  final String description;        // Описание
  final bool isCustomPath;         // Пользовательский путь
}
```

### DatabaseCreationRequest

```dart
class DatabaseCreationRequest {
  final String name;               // Имя БД
  final String masterPassword;     // Мастер-пароль
  final String description;        // Описание
  final bool useDefaultPath;       // Использовать путь по умолчанию
  final String customPath;         // Пользовательский путь
}
```

### DatabaseStatus

```dart
enum DatabaseStatus {
  closed,    // Закрыта
  opening,   // Открывается
  open,      // Открыта
  error,     // Ошибка
}
```

## Пример полного виджета

См. файл `database_manager_example.dart` для полного примера использования всех возможностей сервиса.

## Зависимости

Убедитесь, что в `pubspec.yaml` добавлены следующие зависимости:

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  drift: ^2.28.0
  path_provider: ^2.1.5
  path: ^1.9.1
```

## Безопасность

- Все пароли передаются напрямую в SQLCipher без дополнительного хеширования
- Базы данных автоматически шифруются с помощью SQLCipher
- Пароли не сохраняются в памяти дольше необходимого
- При смене пароля создается новый зашифрованный файл

## Производительность

- Список доступных БД кешируется в состоянии
- Операции с файловой системой выполняются асинхронно
- Большие операции (backup/restore) могут занимать время

## Ограничения

- Одновременно может быть открыта только одна база данных
- Смена пароля пока поддерживается только для метаданных (требует доработки для полных данных)
- Резервное копирование - простое копирование файла
