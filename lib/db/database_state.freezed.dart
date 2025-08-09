// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'database_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DatabaseState {

 List<DatabaseInfo> get databases; bool get isLoading; DatabaseInfo? get currentDatabase; String? get error;
/// Create a copy of DatabaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatabaseStateCopyWith<DatabaseState> get copyWith => _$DatabaseStateCopyWithImpl<DatabaseState>(this as DatabaseState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatabaseState&&const DeepCollectionEquality().equals(other.databases, databases)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentDatabase, currentDatabase) || other.currentDatabase == currentDatabase)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(databases),isLoading,currentDatabase,error);

@override
String toString() {
  return 'DatabaseState(databases: $databases, isLoading: $isLoading, currentDatabase: $currentDatabase, error: $error)';
}


}

/// @nodoc
abstract mixin class $DatabaseStateCopyWith<$Res>  {
  factory $DatabaseStateCopyWith(DatabaseState value, $Res Function(DatabaseState) _then) = _$DatabaseStateCopyWithImpl;
@useResult
$Res call({
 List<DatabaseInfo> databases, bool isLoading, DatabaseInfo? currentDatabase, String? error
});


$DatabaseInfoCopyWith<$Res>? get currentDatabase;

}
/// @nodoc
class _$DatabaseStateCopyWithImpl<$Res>
    implements $DatabaseStateCopyWith<$Res> {
  _$DatabaseStateCopyWithImpl(this._self, this._then);

  final DatabaseState _self;
  final $Res Function(DatabaseState) _then;

/// Create a copy of DatabaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? databases = null,Object? isLoading = null,Object? currentDatabase = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
databases: null == databases ? _self.databases : databases // ignore: cast_nullable_to_non_nullable
as List<DatabaseInfo>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentDatabase: freezed == currentDatabase ? _self.currentDatabase : currentDatabase // ignore: cast_nullable_to_non_nullable
as DatabaseInfo?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of DatabaseState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatabaseInfoCopyWith<$Res>? get currentDatabase {
    if (_self.currentDatabase == null) {
    return null;
  }

  return $DatabaseInfoCopyWith<$Res>(_self.currentDatabase!, (value) {
    return _then(_self.copyWith(currentDatabase: value));
  });
}
}


/// Adds pattern-matching-related methods to [DatabaseState].
extension DatabaseStatePatterns on DatabaseState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DatabaseState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DatabaseState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DatabaseState value)  $default,){
final _that = this;
switch (_that) {
case _DatabaseState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DatabaseState value)?  $default,){
final _that = this;
switch (_that) {
case _DatabaseState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DatabaseInfo> databases,  bool isLoading,  DatabaseInfo? currentDatabase,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DatabaseState() when $default != null:
return $default(_that.databases,_that.isLoading,_that.currentDatabase,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DatabaseInfo> databases,  bool isLoading,  DatabaseInfo? currentDatabase,  String? error)  $default,) {final _that = this;
switch (_that) {
case _DatabaseState():
return $default(_that.databases,_that.isLoading,_that.currentDatabase,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DatabaseInfo> databases,  bool isLoading,  DatabaseInfo? currentDatabase,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _DatabaseState() when $default != null:
return $default(_that.databases,_that.isLoading,_that.currentDatabase,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _DatabaseState implements DatabaseState {
  const _DatabaseState({final  List<DatabaseInfo> databases = const [], this.isLoading = false, this.currentDatabase = null, this.error = null}): _databases = databases;
  

 final  List<DatabaseInfo> _databases;
@override@JsonKey() List<DatabaseInfo> get databases {
  if (_databases is EqualUnmodifiableListView) return _databases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_databases);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  DatabaseInfo? currentDatabase;
@override@JsonKey() final  String? error;

/// Create a copy of DatabaseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatabaseStateCopyWith<_DatabaseState> get copyWith => __$DatabaseStateCopyWithImpl<_DatabaseState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatabaseState&&const DeepCollectionEquality().equals(other._databases, _databases)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentDatabase, currentDatabase) || other.currentDatabase == currentDatabase)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_databases),isLoading,currentDatabase,error);

@override
String toString() {
  return 'DatabaseState(databases: $databases, isLoading: $isLoading, currentDatabase: $currentDatabase, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DatabaseStateCopyWith<$Res> implements $DatabaseStateCopyWith<$Res> {
  factory _$DatabaseStateCopyWith(_DatabaseState value, $Res Function(_DatabaseState) _then) = __$DatabaseStateCopyWithImpl;
@override @useResult
$Res call({
 List<DatabaseInfo> databases, bool isLoading, DatabaseInfo? currentDatabase, String? error
});


@override $DatabaseInfoCopyWith<$Res>? get currentDatabase;

}
/// @nodoc
class __$DatabaseStateCopyWithImpl<$Res>
    implements _$DatabaseStateCopyWith<$Res> {
  __$DatabaseStateCopyWithImpl(this._self, this._then);

  final _DatabaseState _self;
  final $Res Function(_DatabaseState) _then;

/// Create a copy of DatabaseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? databases = null,Object? isLoading = null,Object? currentDatabase = freezed,Object? error = freezed,}) {
  return _then(_DatabaseState(
databases: null == databases ? _self._databases : databases // ignore: cast_nullable_to_non_nullable
as List<DatabaseInfo>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentDatabase: freezed == currentDatabase ? _self.currentDatabase : currentDatabase // ignore: cast_nullable_to_non_nullable
as DatabaseInfo?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of DatabaseState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatabaseInfoCopyWith<$Res>? get currentDatabase {
    if (_self.currentDatabase == null) {
    return null;
  }

  return $DatabaseInfoCopyWith<$Res>(_self.currentDatabase!, (value) {
    return _then(_self.copyWith(currentDatabase: value));
  });
}
}

/// @nodoc
mixin _$DatabaseInfo {

 String get name; String get path; DateTime get createdAt; DateTime get lastModified; int get size; DatabaseStatus get status; String get description; bool get isCustomPath;
/// Create a copy of DatabaseInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatabaseInfoCopyWith<DatabaseInfo> get copyWith => _$DatabaseInfoCopyWithImpl<DatabaseInfo>(this as DatabaseInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatabaseInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified)&&(identical(other.size, size) || other.size == size)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCustomPath, isCustomPath) || other.isCustomPath == isCustomPath));
}


@override
int get hashCode => Object.hash(runtimeType,name,path,createdAt,lastModified,size,status,description,isCustomPath);

@override
String toString() {
  return 'DatabaseInfo(name: $name, path: $path, createdAt: $createdAt, lastModified: $lastModified, size: $size, status: $status, description: $description, isCustomPath: $isCustomPath)';
}


}

/// @nodoc
abstract mixin class $DatabaseInfoCopyWith<$Res>  {
  factory $DatabaseInfoCopyWith(DatabaseInfo value, $Res Function(DatabaseInfo) _then) = _$DatabaseInfoCopyWithImpl;
@useResult
$Res call({
 String name, String path, DateTime createdAt, DateTime lastModified, int size, DatabaseStatus status, String description, bool isCustomPath
});




}
/// @nodoc
class _$DatabaseInfoCopyWithImpl<$Res>
    implements $DatabaseInfoCopyWith<$Res> {
  _$DatabaseInfoCopyWithImpl(this._self, this._then);

  final DatabaseInfo _self;
  final $Res Function(DatabaseInfo) _then;

/// Create a copy of DatabaseInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = null,Object? createdAt = null,Object? lastModified = null,Object? size = null,Object? status = null,Object? description = null,Object? isCustomPath = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastModified: null == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DatabaseStatus,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCustomPath: null == isCustomPath ? _self.isCustomPath : isCustomPath // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DatabaseInfo].
extension DatabaseInfoPatterns on DatabaseInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DatabaseInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DatabaseInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DatabaseInfo value)  $default,){
final _that = this;
switch (_that) {
case _DatabaseInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DatabaseInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DatabaseInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String path,  DateTime createdAt,  DateTime lastModified,  int size,  DatabaseStatus status,  String description,  bool isCustomPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DatabaseInfo() when $default != null:
return $default(_that.name,_that.path,_that.createdAt,_that.lastModified,_that.size,_that.status,_that.description,_that.isCustomPath);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String path,  DateTime createdAt,  DateTime lastModified,  int size,  DatabaseStatus status,  String description,  bool isCustomPath)  $default,) {final _that = this;
switch (_that) {
case _DatabaseInfo():
return $default(_that.name,_that.path,_that.createdAt,_that.lastModified,_that.size,_that.status,_that.description,_that.isCustomPath);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String path,  DateTime createdAt,  DateTime lastModified,  int size,  DatabaseStatus status,  String description,  bool isCustomPath)?  $default,) {final _that = this;
switch (_that) {
case _DatabaseInfo() when $default != null:
return $default(_that.name,_that.path,_that.createdAt,_that.lastModified,_that.size,_that.status,_that.description,_that.isCustomPath);case _:
  return null;

}
}

}

/// @nodoc


class _DatabaseInfo implements DatabaseInfo {
  const _DatabaseInfo({required this.name, required this.path, required this.createdAt, required this.lastModified, required this.size, this.status = DatabaseStatus.closed, this.description = '', this.isCustomPath = false});
  

@override final  String name;
@override final  String path;
@override final  DateTime createdAt;
@override final  DateTime lastModified;
@override final  int size;
@override@JsonKey() final  DatabaseStatus status;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool isCustomPath;

/// Create a copy of DatabaseInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatabaseInfoCopyWith<_DatabaseInfo> get copyWith => __$DatabaseInfoCopyWithImpl<_DatabaseInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatabaseInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified)&&(identical(other.size, size) || other.size == size)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCustomPath, isCustomPath) || other.isCustomPath == isCustomPath));
}


@override
int get hashCode => Object.hash(runtimeType,name,path,createdAt,lastModified,size,status,description,isCustomPath);

@override
String toString() {
  return 'DatabaseInfo(name: $name, path: $path, createdAt: $createdAt, lastModified: $lastModified, size: $size, status: $status, description: $description, isCustomPath: $isCustomPath)';
}


}

/// @nodoc
abstract mixin class _$DatabaseInfoCopyWith<$Res> implements $DatabaseInfoCopyWith<$Res> {
  factory _$DatabaseInfoCopyWith(_DatabaseInfo value, $Res Function(_DatabaseInfo) _then) = __$DatabaseInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String path, DateTime createdAt, DateTime lastModified, int size, DatabaseStatus status, String description, bool isCustomPath
});




}
/// @nodoc
class __$DatabaseInfoCopyWithImpl<$Res>
    implements _$DatabaseInfoCopyWith<$Res> {
  __$DatabaseInfoCopyWithImpl(this._self, this._then);

  final _DatabaseInfo _self;
  final $Res Function(_DatabaseInfo) _then;

/// Create a copy of DatabaseInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? createdAt = null,Object? lastModified = null,Object? size = null,Object? status = null,Object? description = null,Object? isCustomPath = null,}) {
  return _then(_DatabaseInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastModified: null == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DatabaseStatus,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCustomPath: null == isCustomPath ? _self.isCustomPath : isCustomPath // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$DatabaseCreationRequest {

 String get name; String get masterPassword; String get description; bool get useDefaultPath; String get customPath;
/// Create a copy of DatabaseCreationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatabaseCreationRequestCopyWith<DatabaseCreationRequest> get copyWith => _$DatabaseCreationRequestCopyWithImpl<DatabaseCreationRequest>(this as DatabaseCreationRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatabaseCreationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.masterPassword, masterPassword) || other.masterPassword == masterPassword)&&(identical(other.description, description) || other.description == description)&&(identical(other.useDefaultPath, useDefaultPath) || other.useDefaultPath == useDefaultPath)&&(identical(other.customPath, customPath) || other.customPath == customPath));
}


@override
int get hashCode => Object.hash(runtimeType,name,masterPassword,description,useDefaultPath,customPath);

@override
String toString() {
  return 'DatabaseCreationRequest(name: $name, masterPassword: $masterPassword, description: $description, useDefaultPath: $useDefaultPath, customPath: $customPath)';
}


}

/// @nodoc
abstract mixin class $DatabaseCreationRequestCopyWith<$Res>  {
  factory $DatabaseCreationRequestCopyWith(DatabaseCreationRequest value, $Res Function(DatabaseCreationRequest) _then) = _$DatabaseCreationRequestCopyWithImpl;
@useResult
$Res call({
 String name, String masterPassword, String description, bool useDefaultPath, String customPath
});




}
/// @nodoc
class _$DatabaseCreationRequestCopyWithImpl<$Res>
    implements $DatabaseCreationRequestCopyWith<$Res> {
  _$DatabaseCreationRequestCopyWithImpl(this._self, this._then);

  final DatabaseCreationRequest _self;
  final $Res Function(DatabaseCreationRequest) _then;

/// Create a copy of DatabaseCreationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? masterPassword = null,Object? description = null,Object? useDefaultPath = null,Object? customPath = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,masterPassword: null == masterPassword ? _self.masterPassword : masterPassword // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,useDefaultPath: null == useDefaultPath ? _self.useDefaultPath : useDefaultPath // ignore: cast_nullable_to_non_nullable
as bool,customPath: null == customPath ? _self.customPath : customPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DatabaseCreationRequest].
extension DatabaseCreationRequestPatterns on DatabaseCreationRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DatabaseCreationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DatabaseCreationRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DatabaseCreationRequest value)  $default,){
final _that = this;
switch (_that) {
case _DatabaseCreationRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DatabaseCreationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DatabaseCreationRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String masterPassword,  String description,  bool useDefaultPath,  String customPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DatabaseCreationRequest() when $default != null:
return $default(_that.name,_that.masterPassword,_that.description,_that.useDefaultPath,_that.customPath);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String masterPassword,  String description,  bool useDefaultPath,  String customPath)  $default,) {final _that = this;
switch (_that) {
case _DatabaseCreationRequest():
return $default(_that.name,_that.masterPassword,_that.description,_that.useDefaultPath,_that.customPath);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String masterPassword,  String description,  bool useDefaultPath,  String customPath)?  $default,) {final _that = this;
switch (_that) {
case _DatabaseCreationRequest() when $default != null:
return $default(_that.name,_that.masterPassword,_that.description,_that.useDefaultPath,_that.customPath);case _:
  return null;

}
}

}

/// @nodoc


class _DatabaseCreationRequest implements DatabaseCreationRequest {
  const _DatabaseCreationRequest({required this.name, required this.masterPassword, this.description = '', this.useDefaultPath = true, this.customPath = ''});
  

@override final  String name;
@override final  String masterPassword;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool useDefaultPath;
@override@JsonKey() final  String customPath;

/// Create a copy of DatabaseCreationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatabaseCreationRequestCopyWith<_DatabaseCreationRequest> get copyWith => __$DatabaseCreationRequestCopyWithImpl<_DatabaseCreationRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatabaseCreationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.masterPassword, masterPassword) || other.masterPassword == masterPassword)&&(identical(other.description, description) || other.description == description)&&(identical(other.useDefaultPath, useDefaultPath) || other.useDefaultPath == useDefaultPath)&&(identical(other.customPath, customPath) || other.customPath == customPath));
}


@override
int get hashCode => Object.hash(runtimeType,name,masterPassword,description,useDefaultPath,customPath);

@override
String toString() {
  return 'DatabaseCreationRequest(name: $name, masterPassword: $masterPassword, description: $description, useDefaultPath: $useDefaultPath, customPath: $customPath)';
}


}

/// @nodoc
abstract mixin class _$DatabaseCreationRequestCopyWith<$Res> implements $DatabaseCreationRequestCopyWith<$Res> {
  factory _$DatabaseCreationRequestCopyWith(_DatabaseCreationRequest value, $Res Function(_DatabaseCreationRequest) _then) = __$DatabaseCreationRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String masterPassword, String description, bool useDefaultPath, String customPath
});




}
/// @nodoc
class __$DatabaseCreationRequestCopyWithImpl<$Res>
    implements _$DatabaseCreationRequestCopyWith<$Res> {
  __$DatabaseCreationRequestCopyWithImpl(this._self, this._then);

  final _DatabaseCreationRequest _self;
  final $Res Function(_DatabaseCreationRequest) _then;

/// Create a copy of DatabaseCreationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? masterPassword = null,Object? description = null,Object? useDefaultPath = null,Object? customPath = null,}) {
  return _then(_DatabaseCreationRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,masterPassword: null == masterPassword ? _self.masterPassword : masterPassword // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,useDefaultPath: null == useDefaultPath ? _self.useDefaultPath : useDefaultPath // ignore: cast_nullable_to_non_nullable
as bool,customPath: null == customPath ? _self.customPath : customPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
