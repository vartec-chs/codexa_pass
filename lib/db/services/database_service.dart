import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../db.dart';
import '../database_state.dart';
import '../../app/errors/db_errors.dart';
import '../../app/logger/app_logger.dart';
import '../../app/config/constants.dart';

/// Менеджер для хеширования и валидации паролей
class PasswordManager {
  static const int _saltLength = 32;

  /// Хеширование пароля с солью
  String hashPassword(String password, [String? salt]) {
    salt ??= _generateSalt();
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return '$salt:${digest.toString()}';
  }

  /// Проверка пароля
  bool verifyPassword(String password, String hashedPassword) {
    try {
      final parts = hashedPassword.split(':');
      if (parts.length != 2) return false;

      final salt = parts[0];

      final newHash = hashPassword(password, salt);
      return newHash == hashedPassword;
    } catch (e) {
      return false;
    }
  }

  /// Генерация соли
  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(_saltLength, (i) => random.nextInt(256));
    return base64.encode(bytes);
  }

  /// Валидация пароля
  void validatePassword(String password) {
    if (password.isEmpty) {
      throw const DbError.invalidPassword(
        message: 'Пароль не может быть пустым',
      );
    }
    if (password.length < 6) {
      throw const DbError.invalidPassword(
        message: 'Пароль должен содержать минимум 6 символов',
      );
    }
  }

  /// Валидация имени базы данных
  void validateDatabaseName(String name) {
    if (name.isEmpty) {
      throw const DbError.unknown(
        message: 'Имя базы данных не может быть пустым',
      );
    }
    if (name.length > 100) {
      throw const DbError.unknown(message: 'Имя базы данных слишком длинное');
    }
    if (RegExp(r'[<>:"/\\|?*]').hasMatch(name)) {
      throw const DbError.unknown(message: 'Имя содержит недопустимые символы');
    }
  }
}

/// События базы данных
sealed class DatabaseEvent {
  const DatabaseEvent();

  factory DatabaseEvent.opening(String path) = DatabaseOpening;
  factory DatabaseEvent.opened(DatabaseInfo info) = DatabaseOpened;
  factory DatabaseEvent.closed() = DatabaseClosed;
  factory DatabaseEvent.error(DbError error) = DatabaseError;
}

class DatabaseOpening extends DatabaseEvent {
  final String path;
  const DatabaseOpening(this.path);
}

class DatabaseOpened extends DatabaseEvent {
  final DatabaseInfo info;
  const DatabaseOpened(this.info);
}

class DatabaseClosed extends DatabaseEvent {
  const DatabaseClosed();
}

class DatabaseError extends DatabaseEvent {
  final DbError error;
  const DatabaseError(this.error);
}

/// Сервис для управления базами данных AppEncryptedDatabase
class DatabaseService {
  AppEncryptedDatabase? _database;
  String? _currentPath;
  String? _currentPassword;
  final _passwordManager = PasswordManager();

  final StreamController<DatabaseEvent> _eventController =
      StreamController<DatabaseEvent>.broadcast();

  /// Поток событий базы данных
  Stream<DatabaseEvent> get events => _eventController.stream;

  /// Получить текущую базу данных
  AppEncryptedDatabase? get currentDatabase => _database;

  /// Получить путь к текущей базе данных
  String? get currentPath => _currentPath;

  /// Проверить, открыта ли база данных
  bool get isOpen => _database != null;

  /// Логирование с маскированием чувствительных данных
  void _log(String message, {String? tag, Map<String, dynamic>? data}) {
    logInfo(message, tag: tag ?? 'DatabaseService', data: data);
  }

  void _logError(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    logError(
      message,
      error: error,
      stackTrace: stackTrace,
      tag: 'DatabaseService',
      data: data,
    );
  }

  void _logDebug(String message, {Map<String, dynamic>? data}) {
    logDebug(message, tag: 'DatabaseService', data: data);
  }

  /// Маскирование чувствительных данных
  String _maskSensitiveData(String data) {
    return AppConstants.logSensitiveData
        ? data
        : AppConstants.sensitiveDataMask;
  }

  /// Получить безопасные данные для логирования
  Map<String, dynamic> _getSafeLogData({
    String? path,
    String? password,
    String? name,
    Map<String, dynamic>? additionalData,
  }) {
    final data = <String, dynamic>{};

    if (path != null) {
      data['path'] = AppConstants.logSensitiveData ? path : _maskPath(path);
    }

    if (password != null) {
      data['password_length'] = password.length;
      if (AppConstants.logSensitiveData) {
        data['password_masked'] = _maskSensitiveData(password);
      }
    }

    if (name != null) {
      data['name'] = name;
    }

    if (additionalData != null) {
      data.addAll(additionalData);
    }

    return data;
  }

  /// Маскирование пути (показываем только имя файла)
  String _maskPath(String fullPath) {
    if (AppConstants.logSensitiveData) return fullPath;
    return path.basename(fullPath);
  }

  /// Создать новую базу данных
  Future<DatabaseInfo> createDatabase({
    required String name,
    required String masterPassword,
    String? customPath,
    String description = '',
  }) async {
    _logDebug(
      'Creating database',
      data: _getSafeLogData(
        name: name,
        password: masterPassword,
        additionalData: {'customPath': customPath, 'description': description},
      ),
    );

    try {
      // Валидация параметров
      _passwordManager.validateDatabaseName(name);
      _passwordManager.validatePassword(masterPassword);

      _eventController.add(DatabaseEvent.opening('Создание базы данных $name'));

      // Определяем путь для новой БД
      final String dbPath;
      if (customPath != null && customPath.isNotEmpty) {
        dbPath = path.join(customPath, '$name.db');
      } else {
        final documentsDir = await getApplicationDocumentsDirectory();
        final appDir = Directory(path.join(documentsDir.path, 'CodexaPass'));
        if (!await appDir.exists()) {
          await appDir.create(recursive: true);
        }
        dbPath = path.join(appDir.path, '$name.db');
      }

      _logDebug(
        'Database path determined',
        data: _getSafeLogData(path: dbPath),
      );

      // Проверяем, что файл не существует
      final file = File(dbPath);
      if (await file.exists()) {
        _logError(
          'Database file already exists',
          data: _getSafeLogData(path: dbPath),
        );
        throw const DbError.conflict(
          reason: 'База данных с таким именем уже существует',
        );
      }

      // Создаем новую базу данных
      _log('Creating new database instance');
      final database = AppEncryptedDatabase(dbPath, masterPassword);

      // Проверяем подключение
      await database.getDatabaseMetadata();

      // Устанавливаем метаданные
      await database.setDatabaseMetadata(name, description, masterPassword);

      // Закрываем соединение (будет открыто при необходимости)
      await database.close();

      // Получаем информацию о файле
      final fileStats = await file.stat();

      final databaseInfo = DatabaseInfo(
        name: name,
        path: dbPath,
        createdAt: fileStats.changed,
        lastModified: fileStats.modified,
        size: fileStats.size,
        status: DatabaseStatus.closed,
        description: description,
        isCustomPath: customPath != null && customPath.isNotEmpty,
      );

      _log(
        'Database created successfully',
        data: _getSafeLogData(
          path: dbPath,
          name: name,
          additionalData: {'size': fileStats.size, 'status': 'closed'},
        ),
      );

      _eventController.add(DatabaseEvent.opened(databaseInfo));
      return databaseInfo;
    } on DbError catch (e) {
      _logError(
        'Database creation failed (DbError)',
        error: e,
        data: _getSafeLogData(name: name),
      );
      rethrow;
    } catch (e, stackTrace) {
      _logError(
        'Database creation failed (Unknown)',
        error: e,
        stackTrace: stackTrace,
        data: _getSafeLogData(name: name),
      );
      final error = DbError.unknown(message: 'Ошибка создания базы данных: $e');
      _eventController.add(DatabaseEvent.error(error));
      throw error;
    }
  }

  /// Открыть существующую базу данных
  Future<DatabaseInfo> openDatabase({
    required String path,
    required String password,
  }) async {
    _logDebug(
      'Opening database',
      data: _getSafeLogData(path: path, password: password),
    );

    try {
      // Проверяем существование файла
      final file = File(path);
      if (!await file.exists()) {
        _logError('Database file not found', data: _getSafeLogData(path: path));
        throw const DbError.notFound(entity: 'Файл базы данных');
      }

      // Закрываем текущую БД если открыта
      await closeDatabase();

      _eventController.add(DatabaseEvent.opening(path));

      // Создаем новое подключение
      _logDebug('Creating database connection');
      final database = AppEncryptedDatabase(path, password);

      // Проверяем подключение и получаем метаданные
      final metadata = await database.getDatabaseMetadata();
      if (metadata == null) {
        await database.close();
        _logError(
          'Invalid password or corrupted database',
          data: _getSafeLogData(path: path),
        );
        throw const DbError.invalidPassword(
          message: 'Неверный пароль или поврежденная база данных',
        );
      }

      // Сохраняем текущие параметры
      _database = database;
      _currentPath = path;
      _currentPassword = password;

      // Получаем информацию о файле
      final fileStats = await file.stat();

      final databaseInfo = DatabaseInfo(
        name: metadata.name,
        path: path,
        createdAt: metadata.createdAt,
        lastModified: fileStats.modified,
        size: fileStats.size,
        status: DatabaseStatus.open,
        description: metadata.description ?? '',
        isCustomPath: !path.contains('CodexaPass'),
      );

      _log(
        'Database opened successfully',
        data: _getSafeLogData(
          path: path,
          name: metadata.name,
          additionalData: {'size': fileStats.size, 'status': 'open'},
        ),
      );

      _eventController.add(DatabaseEvent.opened(databaseInfo));
      return databaseInfo;
    } on DbError catch (e) {
      await closeDatabase();
      _logError(
        'Database opening failed (DbError)',
        error: e,
        data: _getSafeLogData(path: path),
      );
      rethrow;
    } catch (e, stackTrace) {
      await closeDatabase();
      _logError(
        'Database opening failed (Unknown)',
        error: e,
        stackTrace: stackTrace,
        data: _getSafeLogData(path: path),
      );
      final error = DbError.unknown(message: 'Ошибка открытия базы данных: $e');
      _eventController.add(DatabaseEvent.error(error));
      throw error;
    }
  }

  /// Закрыть текущую базу данных
  Future<void> closeDatabase() async {
    if (_database != null) {
      _log('Closing database', data: _getSafeLogData(path: _currentPath));
      await _database!.close();
      _database = null;
      _currentPath = null;
      _currentPassword = null;
      _eventController.add(DatabaseEvent.closed());
      _log('Database closed successfully');
    }
  }

  /// Получить список всех баз данных в директории приложения
  Future<List<DatabaseInfo>> getAvailableDatabases() async {
    _logDebug('Getting available databases');

    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final appDir = Directory(path.join(documentsDir.path, 'CodexaPass'));

      if (!await appDir.exists()) {
        _logDebug('App directory does not exist', data: {'path': appDir.path});
        return [];
      }

      final databases = <DatabaseInfo>[];
      await for (final entity in appDir.list()) {
        if (entity is File && entity.path.endsWith('.db')) {
          try {
            final fileStats = await entity.stat();
            final fileName = path.basenameWithoutExtension(entity.path);

            databases.add(
              DatabaseInfo(
                name: fileName,
                path: entity.path,
                createdAt: fileStats.changed,
                lastModified: fileStats.modified,
                size: fileStats.size,
                status: DatabaseStatus.closed,
                description: '',
                isCustomPath: false,
              ),
            );
          } catch (e) {
            _logError(
              'Failed to process database file',
              error: e,
              data: _getSafeLogData(path: entity.path),
            );
            // Игнорируем поврежденные файлы
            continue;
          }
        }
      }

      // Сортируем по дате последнего изменения
      databases.sort((a, b) => b.lastModified.compareTo(a.lastModified));

      _log('Found ${databases.length} available databases');
      return databases;
    } catch (e, stackTrace) {
      _logError(
        'Failed to get available databases',
        error: e,
        stackTrace: stackTrace,
      );
      throw DbError.unknown(message: 'Ошибка получения списка баз данных: $e');
    }
  }

  /// Удалить базу данных
  Future<void> deleteDatabase(String path) async {
    _log('Deleting database', data: _getSafeLogData(path: path));

    try {
      // Закрываем если это текущая БД
      if (_currentPath == path) {
        _logDebug('Closing current database before deletion');
        await closeDatabase();
      }

      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        _log(
          'Database deleted successfully',
          data: _getSafeLogData(path: path),
        );
      } else {
        _logDebug(
          'Database file does not exist',
          data: _getSafeLogData(path: path),
        );
      }
    } catch (e, stackTrace) {
      _logError(
        'Failed to delete database',
        error: e,
        stackTrace: stackTrace,
        data: _getSafeLogData(path: path),
      );
      throw DbError.writeFailed(reason: 'Ошибка удаления базы данных: $e');
    }
  }

  /// Проверить пароль базы данных
  Future<bool> verifyPassword(String path, String password) async {
    try {
      final database = AppEncryptedDatabase(path, password);
      final metadata = await database.getDatabaseMetadata();
      await database.close();
      return metadata != null;
    } catch (e) {
      return false;
    }
  }

  /// Изменить пароль базы данных
  Future<void> changePassword(String newPassword) async {
    if (_database == null || _currentPath == null) {
      _logError('No open database for password change');
      throw const DbError.accessDenied(message: 'Нет открытой базы данных');
    }

    _logDebug(
      'Changing database password',
      data: _getSafeLogData(path: _currentPath, password: newPassword),
    );

    try {
      // Валидация нового пароля
      _passwordManager.validatePassword(newPassword);

      // Получаем текущие метаданные
      final metadata = await _database!.getDatabaseMetadata();
      if (metadata == null) {
        _logError('Cannot get database metadata');
        throw const DbError.readFailed(
          reason: 'Не удается получить метаданные базы данных',
        );
      }

      // Закрываем текущее соединение
      await _database!.close();

      // Создаем временный файл
      final tempPath = '${_currentPath!}.temp';
      _logDebug(
        'Creating temporary database file',
        data: {'tempPath': _maskPath(tempPath)},
      );
      final tempDatabase = AppEncryptedDatabase(tempPath, newPassword);

      // Переносим данные (пока только метаданные, в будущем нужно добавить перенос всех данных)
      await tempDatabase.setDatabaseMetadata(
        metadata.name,
        metadata.description ?? '',
        newPassword,
      );

      await tempDatabase.close();

      // Заменяем файлы
      final originalFile = File(_currentPath!);
      final tempFile = File(tempPath);

      await originalFile.delete();
      await tempFile.rename(_currentPath!);

      // Переоткрываем с новым паролем
      _database = AppEncryptedDatabase(_currentPath!, newPassword);
      _currentPassword = newPassword;

      _log(
        'Database password changed successfully',
        data: _getSafeLogData(path: _currentPath),
      );
    } on DbError catch (e) {
      _logError(
        'Password change failed (DbError)',
        error: e,
        data: _getSafeLogData(path: _currentPath),
      );
      rethrow;
    } catch (e, stackTrace) {
      _logError(
        'Password change failed (Unknown)',
        error: e,
        stackTrace: stackTrace,
        data: _getSafeLogData(path: _currentPath),
      );
      throw DbError.writeFailed(reason: 'Ошибка изменения пароля: $e');
    }
  }

  /// Получить информацию о текущей базе данных
  Future<DatabaseInfo?> getCurrentDatabaseInfo() async {
    if (_database == null || _currentPath == null) {
      _logDebug('No current database available');
      return null;
    }

    try {
      final metadata = await _database!.getDatabaseMetadata();
      if (metadata == null) {
        _logError('Cannot get current database metadata');
        return null;
      }

      final file = File(_currentPath!);
      final fileStats = await file.stat();

      final info = DatabaseInfo(
        name: metadata.name,
        path: _currentPath!,
        createdAt: metadata.createdAt,
        lastModified: fileStats.modified,
        size: fileStats.size,
        status: DatabaseStatus.open,
        description: metadata.description ?? '',
        isCustomPath: !_currentPath!.contains('CodexaPass'),
      );

      _logDebug(
        'Retrieved current database info',
        data: _getSafeLogData(
          path: _currentPath,
          name: metadata.name,
          additionalData: {'size': fileStats.size},
        ),
      );

      return info;
    } catch (e, stackTrace) {
      _logError(
        'Failed to get current database info',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Резервное копирование базы данных
  Future<void> backupDatabase(String backupPath) async {
    if (_database == null || _currentPath == null) {
      _logError('No open database for backup');
      throw const DbError.accessDenied(message: 'Нет открытой базы данных');
    }

    _log(
      'Creating database backup',
      data: _getSafeLogData(
        path: _currentPath,
        additionalData: {'backupPath': _maskPath(backupPath)},
      ),
    );

    try {
      final sourceFile = File(_currentPath!);

      await sourceFile.copy(backupPath);

      // Обновляем время последнего бэкапа в метаданных
      final metadata = await _database!.getDatabaseMetadata();
      if (metadata != null) {
        await _database!.setDatabaseMetadata(
          metadata.name,
          metadata.description ?? '',
          _currentPassword!,
        );
      }

      _log(
        'Database backup created successfully',
        data: _getSafeLogData(
          path: _currentPath,
          additionalData: {'backupPath': _maskPath(backupPath)},
        ),
      );
    } catch (e, stackTrace) {
      _logError(
        'Failed to create database backup',
        error: e,
        stackTrace: stackTrace,
        data: _getSafeLogData(
          path: _currentPath,
          additionalData: {'backupPath': _maskPath(backupPath)},
        ),
      );
      throw DbError.writeFailed(reason: 'Ошибка создания резервной копии: $e');
    }
  }

  /// Восстановить базу данных из резервной копии
  Future<DatabaseInfo> restoreDatabase({
    required String backupPath,
    required String password,
    String? targetPath,
  }) async {
    _log(
      'Restoring database from backup',
      data: _getSafeLogData(
        password: password,
        additionalData: {
          'backupPath': _maskPath(backupPath),
          'targetPath': targetPath != null ? _maskPath(targetPath) : null,
        },
      ),
    );

    try {
      if (!await File(backupPath).exists()) {
        _logError(
          'Backup file not found',
          data: {'backupPath': _maskPath(backupPath)},
        );
        throw const DbError.notFound(entity: 'Файл резервной копии');
      }

      // Определяем путь для восстановления
      final String restorePath;
      if (targetPath != null) {
        restorePath = targetPath;
      } else {
        final documentsDir = await getApplicationDocumentsDirectory();
        final appDir = Directory(path.join(documentsDir.path, 'CodexaPass'));
        if (!await appDir.exists()) {
          await appDir.create(recursive: true);
        }
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        restorePath = path.join(appDir.path, 'restored_$timestamp.db');
      }

      _logDebug(
        'Restore path determined',
        data: {'restorePath': _maskPath(restorePath)},
      );

      // Копируем файл
      await File(backupPath).copy(restorePath);

      // Проверяем что можем открыть восстановленную БД
      final restoredDatabase = AppEncryptedDatabase(restorePath, password);
      final metadata = await restoredDatabase.getDatabaseMetadata();
      await restoredDatabase.close();

      if (metadata == null) {
        await File(restorePath).delete();
        _logError(
          'Invalid password or corrupted backup',
          data: {'restorePath': _maskPath(restorePath)},
        );
        throw const DbError.invalidPassword(
          message: 'Неверный пароль или поврежденная резервная копия',
        );
      }

      // Получаем информацию о восстановленном файле
      final fileStats = await File(restorePath).stat();

      final info = DatabaseInfo(
        name: metadata.name,
        path: restorePath,
        createdAt: metadata.createdAt,
        lastModified: fileStats.modified,
        size: fileStats.size,
        status: DatabaseStatus.closed,
        description: metadata.description ?? '',
        isCustomPath: targetPath != null,
      );

      _log(
        'Database restored successfully',
        data: _getSafeLogData(
          path: restorePath,
          name: metadata.name,
          additionalData: {'size': fileStats.size},
        ),
      );

      return info;
    } catch (e) {
      if (e is DbError) {
        _logError(
          'Database restore failed (DbError)',
          error: e,
          data: {'backupPath': _maskPath(backupPath)},
        );
        rethrow;
      }
      _logError(
        'Database restore failed (Unknown)',
        error: e,
        data: {'backupPath': _maskPath(backupPath)},
      );
      throw DbError.unknown(message: 'Ошибка восстановления базы данных: $e');
    }
  }

  /// Освободить ресурсы
  void dispose() {
    _log('Disposing DatabaseService');
    _eventController.close();
  }
}
