# Интеграция ScaffoldMessengerManager в CodexaPass

## Быстрый старт

### 1. Настройка в main.dart

```dart
import 'package:flutter/material.dart';
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodexaPass',
      
      // ВАЖНО: Установить глобальный ключ
      scaffoldMessengerKey: ScaffoldMessengerManager.globalKey,
      
      home: HomeScreen(),
    );
  }
}
```

### 2. Использование в любом месте приложения

```dart
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/index.dart';

class SomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          // Простое использование
          context.showError('Что-то пошло не так!');
          
          // Или через менеджер
          ScaffoldMessengerManager.instance.showSuccess('Готово!');
        },
        child: Text('Тест'),
      ),
    );
  }
}
```

## Типичные сценарии для CodexaPass

### Аутентификация

```dart
// Ошибка входа
context.showError(
  'Неверный мастер-пароль',
  showCopyButton: false,
  actionLabel: 'Забыли пароль?',
  onActionPressed: () => navigateToPasswordRecovery(),
);

// Успешный вход
context.showSuccess('Добро пожаловать!');

// Истечение сессии
ScaffoldMessengerManager.instance.showWarningBanner(
  'Сессия истекла. Войдите заново для продолжения работы',
  actions: [
    TextButton(
      onPressed: () => logout(),
      child: Text('Войти'),
    ),
    MessengerActions.closeBanner(),
  ],
);
```

### Работа с паролями

```dart
// Успешное сохранение пароля
MessengerPresets.saveSuccess(message: 'Пароль добавлен в хранилище');

// Ошибка при генерации пароля
context.showError(
  'Не удалось сгенерировать безопасный пароль',
  showCopyButton: true,
  actionLabel: 'Повторить',
  onActionPressed: () => generatePassword(),
);

// Предупреждение о слабом пароле
context.showWarning(
  'Пароль слишком простой. Рекомендуем усилить',
  actionLabel: 'Сгенерировать',
  onActionPressed: () => showPasswordGenerator(),
);

// Копирование пароля
context.showSuccess('Пароль скопирован в буфер обмена');
```

### Синхронизация данных

```dart
// Ошибка синхронизации
MessengerPresets.networkError(
  message: 'Не удалось синхронизировать данные с облаком',
  onRetry: () => startSync(),
);

// Автономный режим
MessengerPresets.offlineMode();

// Успешная синхронизация
context.showSuccess('Данные синхронизированы с облаком');
```

### Безопасность

```dart
// Предупреждение о безопасности
ScaffoldMessengerManager.instance.showErrorBanner(
  'Обнаружена подозрительная активность в аккаунте',
  actions: [
    TextButton.icon(
      onPressed: () => showSecurityLog(),
      icon: Icon(Icons.security),
      label: Text('Проверить'),
    ),
    TextButton.icon(
      onPressed: () => lockApp(),
      icon: Icon(Icons.lock),
      label: Text('Заблокировать'),
    ),
    MessengerActions.closeBanner(),
  ],
);

// Успешная проверка безопасности
context.showSuccess('Проверка безопасности пройдена');
```

### Резервное копирование

```dart
// Начало резервного копирования
context.showInfo('Создание резервной копии...');

// Успешное создание
context.showSuccess('Резервная копия создана');

// Ошибка создания копии
context.showError(
  'Не удалось создать резервную копию',
  showCopyButton: true,
  actionLabel: 'Повторить',
  onActionPressed: () => createBackup(),
);

// Предупреждение о старой копии
ScaffoldMessengerManager.instance.showWarningBanner(
  'Последняя резервная копия была создана 30 дней назад',
  actions: [
    TextButton(
      onPressed: () => createBackup(),
      child: Text('Создать сейчас'),
    ),
    MessengerActions.closeBanner(),
  ],
);
```

### Обновления

```dart
// Доступно обновление
MessengerPresets.updateAvailable(
  onUpdate: () => startAppUpdate(),
);

// Критическое обновление безопасности
ScaffoldMessengerManager.instance.showErrorBanner(
  'Доступно критическое обновление безопасности',
  actions: [
    TextButton.icon(
      onPressed: () => startAppUpdate(),
      icon: Icon(Icons.security),
      label: Text('Обновить сейчас'),
    ),
  ],
);
```

## Кастомизация под тему приложения

```dart
class CodexaPassSnackBarThemeProvider implements SnackBarThemeProvider {
  @override
  Color getBackgroundColor(BuildContext context, SnackBarType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    switch (type) {
      case SnackBarType.error:
        return isDark ? Color(0xFF8B1538) : Color(0xFFFFEBEE);
      case SnackBarType.success:
        return isDark ? Color(0xFF1B5E20) : Color(0xFFE8F5E8);
      // ... другие цвета
    }
  }
  
  // ... остальные методы
}

// Настройка в main.dart
void setupMessengerTheme() {
  ScaffoldMessengerManager.instance.configure(
    snackBarBuilder: DefaultSnackBarBuilder(
      themeProvider: CodexaPassSnackBarThemeProvider(),
    ),
  );
}
```

## Лучшие практики

### 1. Используйте правильные типы

- `error` - критические ошибки, проблемы безопасности
- `warning` - предупреждения, слабые пароли  
- `info` - нейтральная информация, процессы
- `success` - успешные операции

### 2. Для критических действий используйте Banner

```dart
// Для критических предупреждений
ScaffoldMessengerManager.instance.showErrorBanner(
  'Обнаружена попытка взлома. Приложение заблокировано',
);

// Для важной информации
ScaffoldMessengerManager.instance.showWarningBanner(
  'Срок действия мастер-пароля истекает через 7 дней',
);
```

### 3. Добавляйте кнопку копирования для ошибок

```dart
context.showError(
  'Ошибка шифрования: AES_DECRYPT_FAILED',
  showCopyButton: true, // Для отчетов об ошибках
);
```

### 4. Используйте очередь для множественных операций

```dart
// При массовых операциях сообщения автоматически встанут в очередь
for (final password in passwords) {
  try {
    await savePassword(password);
    context.showSuccess('${password.title} сохранен');
  } catch (e) {
    context.showError('Не удалось сохранить ${password.title}');
  }
}
```

### 5. Управляйте длительностью показа

```dart
// Короткие для успеха
context.showSuccess('Скопировано'); // 3 сек по умолчанию

// Длинные для ошибок  
context.showError(
  'Критическая ошибка',
  duration: Duration(seconds: 10), // Больше времени на чтение
);
```

## Интеграция с другими компонентами

### Валидация форм

```dart
class PasswordFormValidator {
  static void validateAndShow(String password, BuildContext context) {
    if (password.length < 8) {
      context.showWarning(
        'Пароль должен содержать минимум 8 символов',
        actionLabel: 'Генератор',
        onActionPressed: () => showPasswordGenerator(context),
      );
      return;
    }
    
    if (!hasSpecialChars(password)) {
      context.showWarning('Добавьте специальные символы для большей безопасности');
      return;
    }
    
    context.showSuccess('Пароль соответствует требованиям безопасности');
  }
}
```

### Сетевые запросы

```dart
class ApiService {
  static Future<void> syncPasswords() async {
    try {
      final context = ScaffoldMessengerManager.globalKey.currentContext;
      if (context != null) {
        context.showInfo('Синхронизация...');
      }
      
      await api.sync();
      
      if (context != null) {
        context.showSuccess('Данные синхронизированы');
      }
    } catch (e) {
      MessengerPresets.networkError(
        message: 'Ошибка синхронизации: ${e.toString()}',
        onRetry: () => syncPasswords(),
      );
    }
  }
}
```

Этот ScaffoldMessengerManager предоставляет полную функциональность для управления уведомлениями в вашем приложении CodexaPass с современным UI, поддержкой тем и соблюдением SOLID принципов!
