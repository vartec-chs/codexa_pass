import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database_state.dart';
import 'database_service.dart';

/// StateNotifier для управления состоянием базы данных
class DatabaseStateNotifier extends StateNotifier<DatabaseState> {
  final DatabaseService _databaseService;

  DatabaseStateNotifier(this._databaseService) : super(const DatabaseState());

  /// Создать новую базу данных
  Future<void> createDatabase(DatabaseCreationRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final databaseInfo = await _databaseService.createDatabase(
        name: request.name,
        masterPassword: request.masterPassword,
        customPath: request.useDefaultPath ? null : request.customPath,
        description: request.description,
      );

      // Обновляем список доступных баз данных
      await _loadAvailableDatabases();

      state = state.copyWith(isLoading: false, currentDatabase: databaseInfo);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Открыть существующую базу данных
  Future<void> openDatabase({
    required String path,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final databaseInfo = await _databaseService.openDatabase(
        path: path,
        password: password,
      );

      // Обновляем список доступных баз данных
      await _loadAvailableDatabases();

      state = state.copyWith(isLoading: false, currentDatabase: databaseInfo);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Закрыть текущую базу данных
  Future<void> closeDatabase() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _databaseService.closeDatabase();

      // Обновляем список доступных баз данных
      await _loadAvailableDatabases();

      state = state.copyWith(isLoading: false, currentDatabase: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Загрузить список доступных баз данных
  Future<void> loadAvailableDatabases() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _loadAvailableDatabases();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Внутренний метод для загрузки списка баз данных
  Future<void> _loadAvailableDatabases() async {
    final databases = await _databaseService.getAvailableDatabases();

    // Обновляем статус текущей БД если она открыта
    final updatedDatabases = databases.map((db) {
      if (_databaseService.currentPath == db.path && _databaseService.isOpen) {
        return db.copyWith(status: DatabaseStatus.open);
      }
      return db;
    }).toList();

    state = state.copyWith(databases: updatedDatabases);
  }

  /// Удалить базу данных
  Future<void> deleteDatabase(String path) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _databaseService.deleteDatabase(path);

      // Если удаляем текущую БД, очищаем её из состояния
      if (state.currentDatabase?.path == path) {
        state = state.copyWith(currentDatabase: null);
      }

      // Обновляем список доступных баз данных
      await _loadAvailableDatabases();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Проверить пароль базы данных
  Future<bool> verifyPassword(String path, String password) async {
    try {
      return await _databaseService.verifyPassword(path, password);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Изменить пароль базы данных
  Future<void> changePassword(String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _databaseService.changePassword(newPassword);

      // Обновляем информацию о текущей БД
      final currentInfo = await _databaseService.getCurrentDatabaseInfo();
      state = state.copyWith(isLoading: false, currentDatabase: currentInfo);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Создать резервную копию
  Future<void> backupDatabase(String backupPath) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _databaseService.backupDatabase(backupPath);

      // Обновляем информацию о текущей БД
      final currentInfo = await _databaseService.getCurrentDatabaseInfo();
      state = state.copyWith(isLoading: false, currentDatabase: currentInfo);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Восстановить базу данных из резервной копии
  Future<void> restoreDatabase({
    required String backupPath,
    required String password,
    String? targetPath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final restoredInfo = await _databaseService.restoreDatabase(
        backupPath: backupPath,
        password: password,
        targetPath: targetPath,
      );

      // Обновляем список доступных баз данных
      await _loadAvailableDatabases();

      state = state.copyWith(isLoading: false, currentDatabase: restoredInfo);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Очистить ошибку
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Обновить информацию о текущей базе данных
  Future<void> refreshCurrentDatabase() async {
    if (!_databaseService.isOpen) return;

    try {
      final currentInfo = await _databaseService.getCurrentDatabaseInfo();
      if (currentInfo != null) {
        state = state.copyWith(currentDatabase: currentInfo);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Получить сервис базы данных (для прямого доступа если нужно)
  DatabaseService get databaseService => _databaseService;
}
