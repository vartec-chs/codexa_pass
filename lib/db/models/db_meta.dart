import 'package:drift/drift.dart';

class StoreMeta extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 2, max: 100)();
  TextColumn get description => text().withLength(min: 2, max: 500)();
  TextColumn get masterPassword => text().withLength()();
}
