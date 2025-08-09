import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database_state.dart';
import '../db.dart';
import 'database_service.dart';
import 'database_state_notifier.dart';

/// Провайдер для сервиса базы данных
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

/// Провайдер для состояния базы данных
final databaseStateProvider =
    StateNotifierProvider<DatabaseStateNotifier, DatabaseState>((ref) {
      final databaseService = ref.read(databaseServiceProvider);
      return DatabaseStateNotifier(databaseService);
    });

/// Провайдер для текущей открытой базы данных
final currentDatabaseProvider = Provider<AppEncryptedDatabase?>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return databaseService.currentDatabase;
});

/// Провайдер для проверки, открыта ли база данных
final isDatabaseOpenProvider = Provider<bool>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return databaseService.isOpen;
});

/// Провайдер для информации о текущей базе данных
final currentDatabaseInfoProvider = Provider<DatabaseInfo?>((ref) {
  final state = ref.watch(databaseStateProvider);
  return state.currentDatabase;
});

/// Провайдер для списка доступных баз данных
final availableDatabasesProvider = Provider<List<DatabaseInfo>>((ref) {
  final state = ref.watch(databaseStateProvider);
  return state.databases;
});

/// Провайдер для состояния загрузки
final isDatabaseLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(databaseStateProvider);
  return state.isLoading;
});

/// Провайдер для ошибок базы данных
final databaseErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(databaseStateProvider);
  return state.error;
});

/// Провайдер для фильтрованного списка баз данных (по статусу)
final databasesByStatusProvider =
    Provider.family<List<DatabaseInfo>, DatabaseStatus>((ref, status) {
      final databases = ref.watch(availableDatabasesProvider);
      return databases.where((db) => db.status == status).toList();
    });

/// Провайдер для количества баз данных
final databaseCountProvider = Provider<int>((ref) {
  final databases = ref.watch(availableDatabasesProvider);
  return databases.length;
});

/// Провайдер для последней измененной базы данных
final lastModifiedDatabaseProvider = Provider<DatabaseInfo?>((ref) {
  final databases = ref.watch(availableDatabasesProvider);
  if (databases.isEmpty) return null;

  return databases.reduce(
    (a, b) => a.lastModified.isAfter(b.lastModified) ? a : b,
  );
});

/// Провайдер для общего размера всех баз данных
final totalDatabasesSizeProvider = Provider<int>((ref) {
  final databases = ref.watch(availableDatabasesProvider);
  return databases.fold<int>(0, (sum, db) => sum + db.size);
});

/// Провайдер для проверки существования базы данных по пути
final databaseExistsProvider = Provider.family<bool, String>((ref, path) {
  final databases = ref.watch(availableDatabasesProvider);
  return databases.any((db) => db.path == path);
});

/// Провайдер для поиска базы данных по имени
final databaseByNameProvider = Provider.family<DatabaseInfo?, String>((
  ref,
  name,
) {
  final databases = ref.watch(availableDatabasesProvider);
  try {
    return databases.firstWhere((db) => db.name == name);
  } catch (e) {
    return null;
  }
});

/// Провайдер для поиска базы данных по пути
final databaseByPathProvider = Provider.family<DatabaseInfo?, String>((
  ref,
  path,
) {
  final databases = ref.watch(availableDatabasesProvider);
  try {
    return databases.firstWhere((db) => db.path == path);
  } catch (e) {
    return null;
  }
});

/// Провайдер для методов управления базой данных
final databaseActionsProvider = Provider<DatabaseActions>((ref) {
  return DatabaseActions(ref);
});

/// Класс с действиями для управления базой данных
class DatabaseActions {
  final Ref _ref;

  DatabaseActions(this._ref);

  /// Создать новую базу данных
  Future<void> createDatabase(DatabaseCreationRequest request) async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    await notifier.createDatabase(request);
  }

  /// Открыть базу данных
  Future<void> openDatabase({
    required String path,
    required String password,
  }) async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    await notifier.openDatabase(path: path, password: password);
  }

  /// Закрыть базу данных
  Future<void> closeDatabase() async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    await notifier.closeDatabase();
  }

  /// Удалить базу данных
  Future<void> deleteDatabase(String path) async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    await notifier.deleteDatabase(path);
  }

  /// Загрузить список доступных баз данных
  Future<void> loadAvailableDatabases() async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    await notifier.loadAvailableDatabases();
  }

  /// Проверить пароль
  Future<bool> verifyPassword(String path, String password) async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    return await notifier.verifyPassword(path, password);
  }

  /// Изменить пароль
  Future<void> changePassword(String newPassword) async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    await notifier.changePassword(newPassword);
  }

  /// Создать резервную копию
  Future<void> backupDatabase(String backupPath) async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    await notifier.backupDatabase(backupPath);
  }

  /// Восстановить из резервной копии
  Future<void> restoreDatabase({
    required String backupPath,
    required String password,
    String? targetPath,
  }) async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    await notifier.restoreDatabase(
      backupPath: backupPath,
      password: password,
      targetPath: targetPath,
    );
  }

  /// Очистить ошибку
  void clearError() {
    final notifier = _ref.read(databaseStateProvider.notifier);
    notifier.clearError();
  }

  /// Обновить информацию о текущей базе данных
  Future<void> refreshCurrentDatabase() async {
    final notifier = _ref.read(databaseStateProvider.notifier);
    await notifier.refreshCurrentDatabase();
  }
}
