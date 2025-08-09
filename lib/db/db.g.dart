// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $StoreMetaTable extends StoreMeta
    with TableInfo<$StoreMetaTable, StoreMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoreMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1.0'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _masterPasswordMeta = const VerificationMeta(
    'masterPassword',
  );
  @override
  late final GeneratedColumn<String> masterPassword = GeneratedColumn<String>(
    'master_password',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 3),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastBackupMeta = const VerificationMeta(
    'lastBackup',
  );
  @override
  late final GeneratedColumn<DateTime> lastBackup = GeneratedColumn<DateTime>(
    'last_backup',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    version,
    createdAt,
    lastModified,
    masterPassword,
    lastBackup,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoreMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('master_password')) {
      context.handle(
        _masterPasswordMeta,
        masterPassword.isAcceptableOrUnknown(
          data['master_password']!,
          _masterPasswordMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_masterPasswordMeta);
    }
    if (data.containsKey('last_backup')) {
      context.handle(
        _lastBackupMeta,
        lastBackup.isAcceptableOrUnknown(data['last_backup']!, _lastBackupMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoreMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreMetaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      masterPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}master_password'],
      )!,
      lastBackup: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_backup'],
      ),
    );
  }

  @override
  $StoreMetaTable createAlias(String alias) {
    return $StoreMetaTable(attachedDatabase, alias);
  }
}

class StoreMetaData extends DataClass implements Insertable<StoreMetaData> {
  final int id;
  final String name;
  final String? description;
  final String version;
  final DateTime createdAt;
  final DateTime lastModified;
  final String masterPassword;
  final DateTime? lastBackup;
  const StoreMetaData({
    required this.id,
    required this.name,
    this.description,
    required this.version,
    required this.createdAt,
    required this.lastModified,
    required this.masterPassword,
    this.lastBackup,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['version'] = Variable<String>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['master_password'] = Variable<String>(masterPassword);
    if (!nullToAbsent || lastBackup != null) {
      map['last_backup'] = Variable<DateTime>(lastBackup);
    }
    return map;
  }

  StoreMetaCompanion toCompanion(bool nullToAbsent) {
    return StoreMetaCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      version: Value(version),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
      masterPassword: Value(masterPassword),
      lastBackup: lastBackup == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBackup),
    );
  }

  factory StoreMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreMetaData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      version: serializer.fromJson<String>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      masterPassword: serializer.fromJson<String>(json['masterPassword']),
      lastBackup: serializer.fromJson<DateTime?>(json['lastBackup']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'version': serializer.toJson<String>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'masterPassword': serializer.toJson<String>(masterPassword),
      'lastBackup': serializer.toJson<DateTime?>(lastBackup),
    };
  }

  StoreMetaData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? version,
    DateTime? createdAt,
    DateTime? lastModified,
    String? masterPassword,
    Value<DateTime?> lastBackup = const Value.absent(),
  }) => StoreMetaData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
    masterPassword: masterPassword ?? this.masterPassword,
    lastBackup: lastBackup.present ? lastBackup.value : this.lastBackup,
  );
  StoreMetaData copyWithCompanion(StoreMetaCompanion data) {
    return StoreMetaData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      masterPassword: data.masterPassword.present
          ? data.masterPassword.value
          : this.masterPassword,
      lastBackup: data.lastBackup.present
          ? data.lastBackup.value
          : this.lastBackup,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreMetaData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('masterPassword: $masterPassword, ')
          ..write('lastBackup: $lastBackup')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    version,
    createdAt,
    lastModified,
    masterPassword,
    lastBackup,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreMetaData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified &&
          other.masterPassword == this.masterPassword &&
          other.lastBackup == this.lastBackup);
}

class StoreMetaCompanion extends UpdateCompanion<StoreMetaData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<String> masterPassword;
  final Value<DateTime?> lastBackup;
  const StoreMetaCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.masterPassword = const Value.absent(),
    this.lastBackup = const Value.absent(),
  });
  StoreMetaCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    required String masterPassword,
    this.lastBackup = const Value.absent(),
  }) : name = Value(name),
       masterPassword = Value(masterPassword);
  static Insertable<StoreMetaData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<String>? masterPassword,
    Expression<DateTime>? lastBackup,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (masterPassword != null) 'master_password': masterPassword,
      if (lastBackup != null) 'last_backup': lastBackup,
    });
  }

  StoreMetaCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<String>? masterPassword,
    Value<DateTime?>? lastBackup,
  }) {
    return StoreMetaCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      masterPassword: masterPassword ?? this.masterPassword,
      lastBackup: lastBackup ?? this.lastBackup,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (masterPassword.present) {
      map['master_password'] = Variable<String>(masterPassword.value);
    }
    if (lastBackup.present) {
      map['last_backup'] = Variable<DateTime>(lastBackup.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreMetaCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('masterPassword: $masterPassword, ')
          ..write('lastBackup: $lastBackup')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppEncryptedDatabase extends GeneratedDatabase {
  _$AppEncryptedDatabase(QueryExecutor e) : super(e);
  $AppEncryptedDatabaseManager get managers =>
      $AppEncryptedDatabaseManager(this);
  late final $StoreMetaTable storeMeta = $StoreMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [storeMeta];
}

typedef $$StoreMetaTableCreateCompanionBuilder =
    StoreMetaCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<String> version,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      required String masterPassword,
      Value<DateTime?> lastBackup,
    });
typedef $$StoreMetaTableUpdateCompanionBuilder =
    StoreMetaCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String> version,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<String> masterPassword,
      Value<DateTime?> lastBackup,
    });

class $$StoreMetaTableFilterComposer
    extends Composer<_$AppEncryptedDatabase, $StoreMetaTable> {
  $$StoreMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get masterPassword => $composableBuilder(
    column: $table.masterPassword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastBackup => $composableBuilder(
    column: $table.lastBackup,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoreMetaTableOrderingComposer
    extends Composer<_$AppEncryptedDatabase, $StoreMetaTable> {
  $$StoreMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get masterPassword => $composableBuilder(
    column: $table.masterPassword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastBackup => $composableBuilder(
    column: $table.lastBackup,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoreMetaTableAnnotationComposer
    extends Composer<_$AppEncryptedDatabase, $StoreMetaTable> {
  $$StoreMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get masterPassword => $composableBuilder(
    column: $table.masterPassword,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastBackup => $composableBuilder(
    column: $table.lastBackup,
    builder: (column) => column,
  );
}

class $$StoreMetaTableTableManager
    extends
        RootTableManager<
          _$AppEncryptedDatabase,
          $StoreMetaTable,
          StoreMetaData,
          $$StoreMetaTableFilterComposer,
          $$StoreMetaTableOrderingComposer,
          $$StoreMetaTableAnnotationComposer,
          $$StoreMetaTableCreateCompanionBuilder,
          $$StoreMetaTableUpdateCompanionBuilder,
          (
            StoreMetaData,
            BaseReferences<
              _$AppEncryptedDatabase,
              $StoreMetaTable,
              StoreMetaData
            >,
          ),
          StoreMetaData,
          PrefetchHooks Function()
        > {
  $$StoreMetaTableTableManager(_$AppEncryptedDatabase db, $StoreMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoreMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoreMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoreMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<String> masterPassword = const Value.absent(),
                Value<DateTime?> lastBackup = const Value.absent(),
              }) => StoreMetaCompanion(
                id: id,
                name: name,
                description: description,
                version: version,
                createdAt: createdAt,
                lastModified: lastModified,
                masterPassword: masterPassword,
                lastBackup: lastBackup,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                required String masterPassword,
                Value<DateTime?> lastBackup = const Value.absent(),
              }) => StoreMetaCompanion.insert(
                id: id,
                name: name,
                description: description,
                version: version,
                createdAt: createdAt,
                lastModified: lastModified,
                masterPassword: masterPassword,
                lastBackup: lastBackup,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoreMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppEncryptedDatabase,
      $StoreMetaTable,
      StoreMetaData,
      $$StoreMetaTableFilterComposer,
      $$StoreMetaTableOrderingComposer,
      $$StoreMetaTableAnnotationComposer,
      $$StoreMetaTableCreateCompanionBuilder,
      $$StoreMetaTableUpdateCompanionBuilder,
      (
        StoreMetaData,
        BaseReferences<_$AppEncryptedDatabase, $StoreMetaTable, StoreMetaData>,
      ),
      StoreMetaData,
      PrefetchHooks Function()
    >;

class $AppEncryptedDatabaseManager {
  final _$AppEncryptedDatabase _db;
  $AppEncryptedDatabaseManager(this._db);
  $$StoreMetaTableTableManager get storeMeta =>
      $$StoreMetaTableTableManager(_db, _db.storeMeta);
}
