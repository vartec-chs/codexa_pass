import 'package:codexa_pass/app/config/constants.dart';
import 'package:drift/drift.dart';

import 'models/db_meta.dart';
import 'dto/store_dto.dart';

part 'db.g.dart';

@DriftDatabase(tables: [StoreMeta])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => AppConstants.dbSchemaVersion;

  // Add any additional database-related methods or properties here
}
