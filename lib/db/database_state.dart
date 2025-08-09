import 'package:freezed_annotation/freezed_annotation.dart';

part 'database_state.freezed.dart';

@freezed
abstract class DatabaseState with _$DatabaseState {
  const factory DatabaseState({
    @Default([]) List<DatabaseInfo> databases,
    @Default(false) bool isLoading,
    @Default(null) DatabaseInfo? currentDatabase,
    @Default(null) String? error,
  }) = _DatabaseState;
}

@freezed
abstract class DatabaseInfo with _$DatabaseInfo {
  const factory DatabaseInfo({
    required String name,
    required String path,
    required DateTime createdAt,
    required DateTime lastModified,
    required int size,
    @Default(DatabaseStatus.closed) DatabaseStatus status,
    @Default('') String description,
    @Default(false) bool isCustomPath,
  }) = _DatabaseInfo;
}

@freezed
abstract class DatabaseCreationRequest with _$DatabaseCreationRequest {
  const factory DatabaseCreationRequest({
    required String name,
    required String masterPassword,
    @Default('') String description,
    @Default(true) bool useDefaultPath,
    @Default('') String customPath,
  }) = _DatabaseCreationRequest;
}

enum DatabaseStatus { closed, opening, open, error }
