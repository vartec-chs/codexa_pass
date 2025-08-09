import 'package:codexa_pass/app/config/constants.dart';
import 'package:drift/drift.dart';

import 'models/db_meta.dart';

part 'db.g.dart';

@DriftDatabase(tables: [StoreMeta])
class AppEncryptedDatabase extends _$AppEncryptedDatabase {
  AppEncryptedDatabase(super.e);

  @override
  int get schemaVersion => AppConstants.dbSchemaVersion;
}
