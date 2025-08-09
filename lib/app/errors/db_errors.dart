// lib/core/error/db_error.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'db_errors.freezed.dart';

@freezed
class DbError with _$DbError {
  const factory DbError.connectionFailed({String? message, Object? cause}) =
      DbConnectionFailed;

  const factory DbError.queryFailed({
    String? query,
    String? message,
    Object? cause,
  }) = DbQueryFailed;

  // invalid password
  const factory DbError.invalidPassword({String? message, Object? cause}) =
      DbInvalidPassword;

  // corruptedDatabase
  const factory DbError.corruptedDatabase({String? message, Object? cause}) =
      DbCorruptedDatabase;

  // accessDenied
  const factory DbError.accessDenied({String? message, Object? cause}) =
      DbAccessDenied;

  const factory DbError.writeFailed({String? reason, Object? cause}) =
      DbWriteFailed;

  const factory DbError.readFailed({String? reason, Object? cause}) =
      DbReadFailed;

  const factory DbError.notFound({String? entity}) = DbNotFound;

  const factory DbError.conflict({String? reason}) = DbConflict;

  const factory DbError.unknown({String? message, Object? cause}) = DbUnknown;
}

// handle database errors
// void handleDatabaseError(DbError error) {
//   error.when(
//     connectionFailed: (message, cause) {
//       // Handle connection failed error
//     },
//     queryFailed: (query, message, cause) {
//       // Handle query failed error
//     },
//     writeFailed: (reason, cause) {
//       // Handle write failed error
//     },
//     readFailed: (reason, cause) {
//       // Handle read failed error
//     },
//     notFound: (entity) {
//       // Handle not found error
//     },
//     conflict: (reason) {
//       // Handle conflict error
//     },
//     unknown: (message, cause) {
//       // Handle unknown error
//     },
//   );
// }
