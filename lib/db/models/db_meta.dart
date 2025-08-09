import 'package:drift/drift.dart';

class StoreMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get version => real().withDefault(const Constant(1.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastModified =>
      dateTime().withDefault(currentDateAndTime)();

  TextColumn get masterPassword => text().withLength(min: 3)();
  DateTimeColumn get lastBackup => dateTime().nullable()();
}
