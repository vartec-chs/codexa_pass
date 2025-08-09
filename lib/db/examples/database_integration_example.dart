import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database_services.dart';
import '../database_state.dart';

/// Простой пример интеграции сервиса БД в приложение
class DatabaseIntegrationExample extends ConsumerStatefulWidget {
  const DatabaseIntegrationExample({super.key});

  @override
  ConsumerState<DatabaseIntegrationExample> createState() =>
      _DatabaseIntegrationExampleState();
}

class _DatabaseIntegrationExampleState
    extends ConsumerState<DatabaseIntegrationExample> {
  @override
  void initState() {
    super.initState();
    // Загружаем список доступных БД при запуске
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(databaseActionsProvider).loadAvailableDatabases();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Отслеживаем состояние
    final currentDb = ref.watch(currentDatabaseInfoProvider);
    final isLoading = ref.watch(isDatabaseLoadingProvider);
    final databases = ref.watch(availableDatabasesProvider);

    // Отслеживаем ошибки и показываем уведомления
    ref.listen(databaseErrorProvider, (previous, next) {
      if (next != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Закрыть',
              onPressed: () => ref.read(databaseActionsProvider).clearError(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Service Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Индикатор загрузки
            if (isLoading) const LinearProgressIndicator(),
            const SizedBox(height: 16),

            // Статус текущей БД
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Текущая база данных',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (currentDb != null) ...[
                      Text('Имя: ${currentDb.name}'),
                      Text('Статус: ${_getStatusText(currentDb.status)}'),
                      Text('Размер: ${_formatBytes(currentDb.size)}'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text('Закрыть'),
                        onPressed: () =>
                            ref.read(databaseActionsProvider).closeDatabase(),
                      ),
                    ] else
                      const Text('Нет открытой базы данных'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Список доступных БД
            Text(
              'Доступные базы данных (${databases.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            Expanded(
              child: databases.isEmpty
                  ? const Center(child: Text('Нет доступных баз данных'))
                  : ListView.builder(
                      itemCount: databases.length,
                      itemBuilder: (context, index) {
                        final db = databases[index];
                        final isOpen = db.status == DatabaseStatus.open;

                        return Card(
                          child: ListTile(
                            leading: Icon(
                              isOpen ? Icons.lock_open : Icons.storage,
                              color: isOpen ? Colors.green : Colors.grey,
                            ),
                            title: Text(db.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Размер: ${_formatBytes(db.size)}'),
                                Text(
                                  'Изменена: ${_formatDate(db.lastModified)}',
                                ),
                                if (db.description.isNotEmpty)
                                  Text(
                                    'Описание: ${db.description}',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isOpen)
                                  IconButton(
                                    icon: const Icon(Icons.lock_open),
                                    onPressed: () => _openDatabase(db),
                                  ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteDatabase(db),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewDatabase,
        icon: const Icon(Icons.add),
        label: const Text('Создать БД'),
      ),
    );
  }

  String _getStatusText(DatabaseStatus status) {
    switch (status) {
      case DatabaseStatus.open:
        return 'Открыта';
      case DatabaseStatus.closed:
        return 'Закрыта';
      case DatabaseStatus.opening:
        return 'Открывается...';
      case DatabaseStatus.error:
        return 'Ошибка';
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _openDatabase(DatabaseInfo db) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Открыть ${db.name}'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Пароль',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final password = passwordController.text;
              Navigator.of(context).pop();
              if (password.isNotEmpty) {
                ref
                    .read(databaseActionsProvider)
                    .openDatabase(path: db.path, password: password);
              }
            },
            child: const Text('Открыть'),
          ),
        ],
      ),
    );
  }

  void _deleteDatabase(DatabaseInfo db) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: Text(
          'Удалить базу данных "${db.name}"?\nЭто действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseActionsProvider).deleteDatabase(db.path);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _createNewDatabase() {
    final nameController = TextEditingController();
    final passwordController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать базу данных'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Имя базы данных',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Мастер-пароль',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Описание (необязательно)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final password = passwordController.text;
              final description = descriptionController.text.trim();

              if (name.isNotEmpty && password.isNotEmpty) {
                Navigator.of(context).pop();
                ref
                    .read(databaseActionsProvider)
                    .createDatabase(
                      DatabaseCreationRequest(
                        name: name,
                        masterPassword: password,
                        description: description,
                      ),
                    );
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }
}
