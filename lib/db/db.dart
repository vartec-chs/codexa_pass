import 'dart:io';

import 'package:codexa_pass/app/config/constants.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'models/db_meta.dart';

part 'db.g.dart';

@DriftDatabase(tables: [StoreMetadata])
class AppEncryptedDatabase extends _$AppEncryptedDatabase {
  AppEncryptedDatabase(String path, String password)
    : super(_openConnection(path, password));

  @override
  int get schemaVersion => AppConstants.dbSchemaVersion;

  static QueryExecutor _openConnection(String path, String password) {
    return NativeDatabase(
      File(path),
      setup: (rawDb) {
        rawDb.execute("PRAGMA key = '$password'");
        rawDb.execute("PRAGMA cipher_compatibility = 4");
      },
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();

      // Создаем категории по умолчанию
      // await into(categories).insert(CategoriesCompanion.insert(
      //   name: 'General',
      //   color: '#2196F3',
      // ));
      // await into(categories).insert(CategoriesCompanion.insert(
      //   name: 'Social',
      //   color: '#4CAF50',
      // ));
      // await into(categories).insert(CategoriesCompanion.insert(
      //   name: 'Banking',
      //   color: '#FF9800',
      // ));
    },
  );

  Future<StoreMetadataData?> getDatabaseMetadata() async {
    final result = await (select(storeMetadata)..limit(1)).getSingleOrNull();
    return result;
  }

  Future<void> setDatabaseMetadata(
    String name,
    String description,
    String masterPassword,
  ) async {
    final existing = await getDatabaseMetadata();
    if (existing != null) {
      await (update(
        storeMetadata,
      )..where((m) => m.id.equals(existing.id))).write(
        StoreMetadataCompanion(
          name: Value(name),
          description: Value(description),
          masterPassword: Value(masterPassword),
        ),
      );
    } else {
      await into(storeMetadata).insert(
        StoreMetadataCompanion.insert(
          name: name,
          description: Value(description),
          version: Value(1.0),
          createdAt: Value(DateTime.now()),
          lastModified: Value(DateTime.now()),
          masterPassword: masterPassword,
          lastBackup: Value(null),
        ),
      );
    }
  }
}
