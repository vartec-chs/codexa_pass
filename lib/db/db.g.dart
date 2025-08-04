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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 100,
    ),
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
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masterPasswordMeta = const VerificationMeta(
    'masterPassword',
  );
  @override
  late final GeneratedColumn<String> masterPassword = GeneratedColumn<String>(
    'master_password',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, masterPassword];
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
    } else if (isInserting) {
      context.missing(_descriptionMeta);
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
      )!,
      masterPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}master_password'],
      )!,
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
  final String description;
  final String masterPassword;
  const StoreMetaData({
    required this.id,
    required this.name,
    required this.description,
    required this.masterPassword,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['master_password'] = Variable<String>(masterPassword);
    return map;
  }

  StoreMetaCompanion toCompanion(bool nullToAbsent) {
    return StoreMetaCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      masterPassword: Value(masterPassword),
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
      description: serializer.fromJson<String>(json['description']),
      masterPassword: serializer.fromJson<String>(json['masterPassword']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'masterPassword': serializer.toJson<String>(masterPassword),
    };
  }

  StoreMetaData copyWith({
    int? id,
    String? name,
    String? description,
    String? masterPassword,
  }) => StoreMetaData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    masterPassword: masterPassword ?? this.masterPassword,
  );
  StoreMetaData copyWithCompanion(StoreMetaCompanion data) {
    return StoreMetaData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      masterPassword: data.masterPassword.present
          ? data.masterPassword.value
          : this.masterPassword,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreMetaData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('masterPassword: $masterPassword')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, masterPassword);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreMetaData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.masterPassword == this.masterPassword);
}

class StoreMetaCompanion extends UpdateCompanion<StoreMetaData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> masterPassword;
  const StoreMetaCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.masterPassword = const Value.absent(),
  });
  StoreMetaCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required String masterPassword,
  }) : name = Value(name),
       description = Value(description),
       masterPassword = Value(masterPassword);
  static Insertable<StoreMetaData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? masterPassword,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (masterPassword != null) 'master_password': masterPassword,
    });
  }

  StoreMetaCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? masterPassword,
  }) {
    return StoreMetaCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      masterPassword: masterPassword ?? this.masterPassword,
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
    if (masterPassword.present) {
      map['master_password'] = Variable<String>(masterPassword.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreMetaCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('masterPassword: $masterPassword')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
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
      required String description,
      required String masterPassword,
    });
typedef $$StoreMetaTableUpdateCompanionBuilder =
    StoreMetaCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<String> masterPassword,
    });

class $$StoreMetaTableFilterComposer
    extends Composer<_$AppDatabase, $StoreMetaTable> {
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

  ColumnFilters<String> get masterPassword => $composableBuilder(
    column: $table.masterPassword,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoreMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $StoreMetaTable> {
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

  ColumnOrderings<String> get masterPassword => $composableBuilder(
    column: $table.masterPassword,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoreMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoreMetaTable> {
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

  GeneratedColumn<String> get masterPassword => $composableBuilder(
    column: $table.masterPassword,
    builder: (column) => column,
  );
}

class $$StoreMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoreMetaTable,
          StoreMetaData,
          $$StoreMetaTableFilterComposer,
          $$StoreMetaTableOrderingComposer,
          $$StoreMetaTableAnnotationComposer,
          $$StoreMetaTableCreateCompanionBuilder,
          $$StoreMetaTableUpdateCompanionBuilder,
          (
            StoreMetaData,
            BaseReferences<_$AppDatabase, $StoreMetaTable, StoreMetaData>,
          ),
          StoreMetaData,
          PrefetchHooks Function()
        > {
  $$StoreMetaTableTableManager(_$AppDatabase db, $StoreMetaTable table)
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
                Value<String> description = const Value.absent(),
                Value<String> masterPassword = const Value.absent(),
              }) => StoreMetaCompanion(
                id: id,
                name: name,
                description: description,
                masterPassword: masterPassword,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String description,
                required String masterPassword,
              }) => StoreMetaCompanion.insert(
                id: id,
                name: name,
                description: description,
                masterPassword: masterPassword,
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
      _$AppDatabase,
      $StoreMetaTable,
      StoreMetaData,
      $$StoreMetaTableFilterComposer,
      $$StoreMetaTableOrderingComposer,
      $$StoreMetaTableAnnotationComposer,
      $$StoreMetaTableCreateCompanionBuilder,
      $$StoreMetaTableUpdateCompanionBuilder,
      (
        StoreMetaData,
        BaseReferences<_$AppDatabase, $StoreMetaTable, StoreMetaData>,
      ),
      StoreMetaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StoreMetaTableTableManager get storeMeta =>
      $$StoreMetaTableTableManager(_db, _db.storeMeta);
}
