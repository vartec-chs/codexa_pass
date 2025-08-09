import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database_services.dart';
import '../database_state.dart';

/// Пример виджета для демонстрации использования сервиса базы данных
class DatabaseManagerExample extends ConsumerWidget {
  const DatabaseManagerExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseState = ref.watch(databaseStateProvider);
    final databaseActions = ref.read(databaseActionsProvider);
    final isLoading = ref.watch(isDatabaseLoadingProvider);
    final error = ref.watch(databaseErrorProvider);
    final currentDb = ref.watch(currentDatabaseInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление базами данных'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => databaseActions.loadAvailableDatabases(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Индикатор загрузки
          if (isLoading) const LinearProgressIndicator(),

          // Отображение ошибки
          if (error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => databaseActions.clearError(),
                  ),
                ],
              ),
            ),

          // Информация о текущей БД
          if (currentDb != null)
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storage, color: Colors.green.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Открытая база данных',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Имя: ${currentDb.name}'),
                    Text('Путь: ${currentDb.path}'),
                    Text('Создана: ${_formatDate(currentDb.createdAt)}'),
                    Text('Изменена: ${_formatDate(currentDb.lastModified)}'),
                    Text('Размер: ${_formatSize(currentDb.size)}'),
                    if (currentDb.description.isNotEmpty)
                      Text('Описание: ${currentDb.description}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text('Закрыть'),
                          onPressed: () => databaseActions.closeDatabase(),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.backup),
                          label: const Text('Резервная копия'),
                          onPressed: () =>
                              _showBackupDialog(context, databaseActions),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Список доступных баз данных
          Expanded(
            child: databaseState.databases.isEmpty
                ? const Center(child: Text('Нет доступных баз данных'))
                : ListView.builder(
                    itemCount: databaseState.databases.length,
                    itemBuilder: (context, index) {
                      final db = databaseState.databases[index];
                      final isOpen = db.status == DatabaseStatus.open;

                      return ListTile(
                        leading: Icon(
                          isOpen ? Icons.lock_open : Icons.lock,
                          color: isOpen ? Colors.green : Colors.grey,
                        ),
                        title: Text(db.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Размер: ${_formatSize(db.size)}'),
                            Text('Изменена: ${_formatDate(db.lastModified)}'),
                            if (db.description.isNotEmpty)
                              Text('Описание: ${db.description}'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) => _handleDatabaseAction(
                            context,
                            value,
                            db,
                            databaseActions,
                          ),
                          itemBuilder: (context) => [
                            if (!isOpen)
                              const PopupMenuItem(
                                value: 'open',
                                child: Row(
                                  children: [
                                    Icon(Icons.lock_open),
                                    SizedBox(width: 8),
                                    Text('Открыть'),
                                  ],
                                ),
                              ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Удалить'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDatabaseDialog(context, databaseActions),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _handleDatabaseAction(
    BuildContext context,
    String action,
    DatabaseInfo db,
    DatabaseActions databaseActions,
  ) {
    switch (action) {
      case 'open':
        _showPasswordDialog(context, db, databaseActions);
        break;
      case 'delete':
        _showDeleteConfirmDialog(context, db, databaseActions);
        break;
    }
  }

  void _showPasswordDialog(
    BuildContext context,
    DatabaseInfo db,
    DatabaseActions databaseActions,
  ) {
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final password = passwordController.text;
              if (password.isEmpty) return;

              Navigator.of(context).pop();

              try {
                await databaseActions.openDatabase(
                  path: db.path,
                  password: password,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('База данных ${db.name} открыта')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ошибка открытия БД: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Открыть'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    DatabaseInfo db,
    DatabaseActions databaseActions,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение удаления'),
        content: Text(
          'Вы уверены, что хотите удалить базу данных "${db.name}"? Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(context).pop();

              try {
                await databaseActions.deleteDatabase(db.path);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('База данных ${db.name} удалена')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ошибка удаления БД: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showCreateDatabaseDialog(
    BuildContext context,
    DatabaseActions databaseActions,
  ) {
    final nameController = TextEditingController();
    final passwordController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать новую базу данных'),
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
            onPressed: () async {
              final name = nameController.text.trim();
              final password = passwordController.text;
              final description = descriptionController.text.trim();

              if (name.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Заполните обязательные поля'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              Navigator.of(context).pop();

              try {
                await databaseActions.createDatabase(
                  DatabaseCreationRequest(
                    name: name,
                    masterPassword: password,
                    description: description,
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('База данных $name создана')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ошибка создания БД: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(
    BuildContext context,
    DatabaseActions databaseActions,
  ) {
    // Здесь можно добавить диалог для выбора места сохранения резервной копии
    // Пока что просто показываем заглушку
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция резервного копирования будет реализована'),
      ),
    );
  }
}
