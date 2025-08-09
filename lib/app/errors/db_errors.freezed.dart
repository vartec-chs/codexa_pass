// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'db_errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DbError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DbError()';
}


}

/// @nodoc
class $DbErrorCopyWith<$Res>  {
$DbErrorCopyWith(DbError _, $Res Function(DbError) __);
}


/// Adds pattern-matching-related methods to [DbError].
extension DbErrorPatterns on DbError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DbConnectionFailed value)?  connectionFailed,TResult Function( DbQueryFailed value)?  queryFailed,TResult Function( DbInvalidPassword value)?  invalidPassword,TResult Function( DbCorruptedDatabase value)?  corruptedDatabase,TResult Function( DbAccessDenied value)?  accessDenied,TResult Function( DbWriteFailed value)?  writeFailed,TResult Function( DbReadFailed value)?  readFailed,TResult Function( DbNotFound value)?  notFound,TResult Function( DbConflict value)?  conflict,TResult Function( DbUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DbConnectionFailed() when connectionFailed != null:
return connectionFailed(_that);case DbQueryFailed() when queryFailed != null:
return queryFailed(_that);case DbInvalidPassword() when invalidPassword != null:
return invalidPassword(_that);case DbCorruptedDatabase() when corruptedDatabase != null:
return corruptedDatabase(_that);case DbAccessDenied() when accessDenied != null:
return accessDenied(_that);case DbWriteFailed() when writeFailed != null:
return writeFailed(_that);case DbReadFailed() when readFailed != null:
return readFailed(_that);case DbNotFound() when notFound != null:
return notFound(_that);case DbConflict() when conflict != null:
return conflict(_that);case DbUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DbConnectionFailed value)  connectionFailed,required TResult Function( DbQueryFailed value)  queryFailed,required TResult Function( DbInvalidPassword value)  invalidPassword,required TResult Function( DbCorruptedDatabase value)  corruptedDatabase,required TResult Function( DbAccessDenied value)  accessDenied,required TResult Function( DbWriteFailed value)  writeFailed,required TResult Function( DbReadFailed value)  readFailed,required TResult Function( DbNotFound value)  notFound,required TResult Function( DbConflict value)  conflict,required TResult Function( DbUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case DbConnectionFailed():
return connectionFailed(_that);case DbQueryFailed():
return queryFailed(_that);case DbInvalidPassword():
return invalidPassword(_that);case DbCorruptedDatabase():
return corruptedDatabase(_that);case DbAccessDenied():
return accessDenied(_that);case DbWriteFailed():
return writeFailed(_that);case DbReadFailed():
return readFailed(_that);case DbNotFound():
return notFound(_that);case DbConflict():
return conflict(_that);case DbUnknown():
return unknown(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DbConnectionFailed value)?  connectionFailed,TResult? Function( DbQueryFailed value)?  queryFailed,TResult? Function( DbInvalidPassword value)?  invalidPassword,TResult? Function( DbCorruptedDatabase value)?  corruptedDatabase,TResult? Function( DbAccessDenied value)?  accessDenied,TResult? Function( DbWriteFailed value)?  writeFailed,TResult? Function( DbReadFailed value)?  readFailed,TResult? Function( DbNotFound value)?  notFound,TResult? Function( DbConflict value)?  conflict,TResult? Function( DbUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case DbConnectionFailed() when connectionFailed != null:
return connectionFailed(_that);case DbQueryFailed() when queryFailed != null:
return queryFailed(_that);case DbInvalidPassword() when invalidPassword != null:
return invalidPassword(_that);case DbCorruptedDatabase() when corruptedDatabase != null:
return corruptedDatabase(_that);case DbAccessDenied() when accessDenied != null:
return accessDenied(_that);case DbWriteFailed() when writeFailed != null:
return writeFailed(_that);case DbReadFailed() when readFailed != null:
return readFailed(_that);case DbNotFound() when notFound != null:
return notFound(_that);case DbConflict() when conflict != null:
return conflict(_that);case DbUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message,  Object? cause)?  connectionFailed,TResult Function( String? query,  String? message,  Object? cause)?  queryFailed,TResult Function( String? message,  Object? cause)?  invalidPassword,TResult Function( String? message,  Object? cause)?  corruptedDatabase,TResult Function( String? message,  Object? cause)?  accessDenied,TResult Function( String? reason,  Object? cause)?  writeFailed,TResult Function( String? reason,  Object? cause)?  readFailed,TResult Function( String? entity)?  notFound,TResult Function( String? reason)?  conflict,TResult Function( String? message,  Object? cause)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DbConnectionFailed() when connectionFailed != null:
return connectionFailed(_that.message,_that.cause);case DbQueryFailed() when queryFailed != null:
return queryFailed(_that.query,_that.message,_that.cause);case DbInvalidPassword() when invalidPassword != null:
return invalidPassword(_that.message,_that.cause);case DbCorruptedDatabase() when corruptedDatabase != null:
return corruptedDatabase(_that.message,_that.cause);case DbAccessDenied() when accessDenied != null:
return accessDenied(_that.message,_that.cause);case DbWriteFailed() when writeFailed != null:
return writeFailed(_that.reason,_that.cause);case DbReadFailed() when readFailed != null:
return readFailed(_that.reason,_that.cause);case DbNotFound() when notFound != null:
return notFound(_that.entity);case DbConflict() when conflict != null:
return conflict(_that.reason);case DbUnknown() when unknown != null:
return unknown(_that.message,_that.cause);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message,  Object? cause)  connectionFailed,required TResult Function( String? query,  String? message,  Object? cause)  queryFailed,required TResult Function( String? message,  Object? cause)  invalidPassword,required TResult Function( String? message,  Object? cause)  corruptedDatabase,required TResult Function( String? message,  Object? cause)  accessDenied,required TResult Function( String? reason,  Object? cause)  writeFailed,required TResult Function( String? reason,  Object? cause)  readFailed,required TResult Function( String? entity)  notFound,required TResult Function( String? reason)  conflict,required TResult Function( String? message,  Object? cause)  unknown,}) {final _that = this;
switch (_that) {
case DbConnectionFailed():
return connectionFailed(_that.message,_that.cause);case DbQueryFailed():
return queryFailed(_that.query,_that.message,_that.cause);case DbInvalidPassword():
return invalidPassword(_that.message,_that.cause);case DbCorruptedDatabase():
return corruptedDatabase(_that.message,_that.cause);case DbAccessDenied():
return accessDenied(_that.message,_that.cause);case DbWriteFailed():
return writeFailed(_that.reason,_that.cause);case DbReadFailed():
return readFailed(_that.reason,_that.cause);case DbNotFound():
return notFound(_that.entity);case DbConflict():
return conflict(_that.reason);case DbUnknown():
return unknown(_that.message,_that.cause);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message,  Object? cause)?  connectionFailed,TResult? Function( String? query,  String? message,  Object? cause)?  queryFailed,TResult? Function( String? message,  Object? cause)?  invalidPassword,TResult? Function( String? message,  Object? cause)?  corruptedDatabase,TResult? Function( String? message,  Object? cause)?  accessDenied,TResult? Function( String? reason,  Object? cause)?  writeFailed,TResult? Function( String? reason,  Object? cause)?  readFailed,TResult? Function( String? entity)?  notFound,TResult? Function( String? reason)?  conflict,TResult? Function( String? message,  Object? cause)?  unknown,}) {final _that = this;
switch (_that) {
case DbConnectionFailed() when connectionFailed != null:
return connectionFailed(_that.message,_that.cause);case DbQueryFailed() when queryFailed != null:
return queryFailed(_that.query,_that.message,_that.cause);case DbInvalidPassword() when invalidPassword != null:
return invalidPassword(_that.message,_that.cause);case DbCorruptedDatabase() when corruptedDatabase != null:
return corruptedDatabase(_that.message,_that.cause);case DbAccessDenied() when accessDenied != null:
return accessDenied(_that.message,_that.cause);case DbWriteFailed() when writeFailed != null:
return writeFailed(_that.reason,_that.cause);case DbReadFailed() when readFailed != null:
return readFailed(_that.reason,_that.cause);case DbNotFound() when notFound != null:
return notFound(_that.entity);case DbConflict() when conflict != null:
return conflict(_that.reason);case DbUnknown() when unknown != null:
return unknown(_that.message,_that.cause);case _:
  return null;

}
}

}

/// @nodoc


class DbConnectionFailed implements DbError {
  const DbConnectionFailed({this.message, this.cause});
  

 final  String? message;
 final  Object? cause;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbConnectionFailedCopyWith<DbConnectionFailed> get copyWith => _$DbConnectionFailedCopyWithImpl<DbConnectionFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbConnectionFailed&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'DbError.connectionFailed(message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class $DbConnectionFailedCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbConnectionFailedCopyWith(DbConnectionFailed value, $Res Function(DbConnectionFailed) _then) = _$DbConnectionFailedCopyWithImpl;
@useResult
$Res call({
 String? message, Object? cause
});




}
/// @nodoc
class _$DbConnectionFailedCopyWithImpl<$Res>
    implements $DbConnectionFailedCopyWith<$Res> {
  _$DbConnectionFailedCopyWithImpl(this._self, this._then);

  final DbConnectionFailed _self;
  final $Res Function(DbConnectionFailed) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? cause = freezed,}) {
  return _then(DbConnectionFailed(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class DbQueryFailed implements DbError {
  const DbQueryFailed({this.query, this.message, this.cause});
  

 final  String? query;
 final  String? message;
 final  Object? cause;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbQueryFailedCopyWith<DbQueryFailed> get copyWith => _$DbQueryFailedCopyWithImpl<DbQueryFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbQueryFailed&&(identical(other.query, query) || other.query == query)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,query,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'DbError.queryFailed(query: $query, message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class $DbQueryFailedCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbQueryFailedCopyWith(DbQueryFailed value, $Res Function(DbQueryFailed) _then) = _$DbQueryFailedCopyWithImpl;
@useResult
$Res call({
 String? query, String? message, Object? cause
});




}
/// @nodoc
class _$DbQueryFailedCopyWithImpl<$Res>
    implements $DbQueryFailedCopyWith<$Res> {
  _$DbQueryFailedCopyWithImpl(this._self, this._then);

  final DbQueryFailed _self;
  final $Res Function(DbQueryFailed) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = freezed,Object? message = freezed,Object? cause = freezed,}) {
  return _then(DbQueryFailed(
query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class DbInvalidPassword implements DbError {
  const DbInvalidPassword({this.message, this.cause});
  

 final  String? message;
 final  Object? cause;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbInvalidPasswordCopyWith<DbInvalidPassword> get copyWith => _$DbInvalidPasswordCopyWithImpl<DbInvalidPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbInvalidPassword&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'DbError.invalidPassword(message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class $DbInvalidPasswordCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbInvalidPasswordCopyWith(DbInvalidPassword value, $Res Function(DbInvalidPassword) _then) = _$DbInvalidPasswordCopyWithImpl;
@useResult
$Res call({
 String? message, Object? cause
});




}
/// @nodoc
class _$DbInvalidPasswordCopyWithImpl<$Res>
    implements $DbInvalidPasswordCopyWith<$Res> {
  _$DbInvalidPasswordCopyWithImpl(this._self, this._then);

  final DbInvalidPassword _self;
  final $Res Function(DbInvalidPassword) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? cause = freezed,}) {
  return _then(DbInvalidPassword(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class DbCorruptedDatabase implements DbError {
  const DbCorruptedDatabase({this.message, this.cause});
  

 final  String? message;
 final  Object? cause;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbCorruptedDatabaseCopyWith<DbCorruptedDatabase> get copyWith => _$DbCorruptedDatabaseCopyWithImpl<DbCorruptedDatabase>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbCorruptedDatabase&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'DbError.corruptedDatabase(message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class $DbCorruptedDatabaseCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbCorruptedDatabaseCopyWith(DbCorruptedDatabase value, $Res Function(DbCorruptedDatabase) _then) = _$DbCorruptedDatabaseCopyWithImpl;
@useResult
$Res call({
 String? message, Object? cause
});




}
/// @nodoc
class _$DbCorruptedDatabaseCopyWithImpl<$Res>
    implements $DbCorruptedDatabaseCopyWith<$Res> {
  _$DbCorruptedDatabaseCopyWithImpl(this._self, this._then);

  final DbCorruptedDatabase _self;
  final $Res Function(DbCorruptedDatabase) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? cause = freezed,}) {
  return _then(DbCorruptedDatabase(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class DbAccessDenied implements DbError {
  const DbAccessDenied({this.message, this.cause});
  

 final  String? message;
 final  Object? cause;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbAccessDeniedCopyWith<DbAccessDenied> get copyWith => _$DbAccessDeniedCopyWithImpl<DbAccessDenied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbAccessDenied&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'DbError.accessDenied(message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class $DbAccessDeniedCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbAccessDeniedCopyWith(DbAccessDenied value, $Res Function(DbAccessDenied) _then) = _$DbAccessDeniedCopyWithImpl;
@useResult
$Res call({
 String? message, Object? cause
});




}
/// @nodoc
class _$DbAccessDeniedCopyWithImpl<$Res>
    implements $DbAccessDeniedCopyWith<$Res> {
  _$DbAccessDeniedCopyWithImpl(this._self, this._then);

  final DbAccessDenied _self;
  final $Res Function(DbAccessDenied) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? cause = freezed,}) {
  return _then(DbAccessDenied(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class DbWriteFailed implements DbError {
  const DbWriteFailed({this.reason, this.cause});
  

 final  String? reason;
 final  Object? cause;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbWriteFailedCopyWith<DbWriteFailed> get copyWith => _$DbWriteFailedCopyWithImpl<DbWriteFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbWriteFailed&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,reason,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'DbError.writeFailed(reason: $reason, cause: $cause)';
}


}

/// @nodoc
abstract mixin class $DbWriteFailedCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbWriteFailedCopyWith(DbWriteFailed value, $Res Function(DbWriteFailed) _then) = _$DbWriteFailedCopyWithImpl;
@useResult
$Res call({
 String? reason, Object? cause
});




}
/// @nodoc
class _$DbWriteFailedCopyWithImpl<$Res>
    implements $DbWriteFailedCopyWith<$Res> {
  _$DbWriteFailedCopyWithImpl(this._self, this._then);

  final DbWriteFailed _self;
  final $Res Function(DbWriteFailed) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = freezed,Object? cause = freezed,}) {
  return _then(DbWriteFailed(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class DbReadFailed implements DbError {
  const DbReadFailed({this.reason, this.cause});
  

 final  String? reason;
 final  Object? cause;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbReadFailedCopyWith<DbReadFailed> get copyWith => _$DbReadFailedCopyWithImpl<DbReadFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbReadFailed&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,reason,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'DbError.readFailed(reason: $reason, cause: $cause)';
}


}

/// @nodoc
abstract mixin class $DbReadFailedCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbReadFailedCopyWith(DbReadFailed value, $Res Function(DbReadFailed) _then) = _$DbReadFailedCopyWithImpl;
@useResult
$Res call({
 String? reason, Object? cause
});




}
/// @nodoc
class _$DbReadFailedCopyWithImpl<$Res>
    implements $DbReadFailedCopyWith<$Res> {
  _$DbReadFailedCopyWithImpl(this._self, this._then);

  final DbReadFailed _self;
  final $Res Function(DbReadFailed) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = freezed,Object? cause = freezed,}) {
  return _then(DbReadFailed(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class DbNotFound implements DbError {
  const DbNotFound({this.entity});
  

 final  String? entity;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbNotFoundCopyWith<DbNotFound> get copyWith => _$DbNotFoundCopyWithImpl<DbNotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbNotFound&&(identical(other.entity, entity) || other.entity == entity));
}


@override
int get hashCode => Object.hash(runtimeType,entity);

@override
String toString() {
  return 'DbError.notFound(entity: $entity)';
}


}

/// @nodoc
abstract mixin class $DbNotFoundCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbNotFoundCopyWith(DbNotFound value, $Res Function(DbNotFound) _then) = _$DbNotFoundCopyWithImpl;
@useResult
$Res call({
 String? entity
});




}
/// @nodoc
class _$DbNotFoundCopyWithImpl<$Res>
    implements $DbNotFoundCopyWith<$Res> {
  _$DbNotFoundCopyWithImpl(this._self, this._then);

  final DbNotFound _self;
  final $Res Function(DbNotFound) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? entity = freezed,}) {
  return _then(DbNotFound(
entity: freezed == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DbConflict implements DbError {
  const DbConflict({this.reason});
  

 final  String? reason;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbConflictCopyWith<DbConflict> get copyWith => _$DbConflictCopyWithImpl<DbConflict>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbConflict&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'DbError.conflict(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $DbConflictCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbConflictCopyWith(DbConflict value, $Res Function(DbConflict) _then) = _$DbConflictCopyWithImpl;
@useResult
$Res call({
 String? reason
});




}
/// @nodoc
class _$DbConflictCopyWithImpl<$Res>
    implements $DbConflictCopyWith<$Res> {
  _$DbConflictCopyWithImpl(this._self, this._then);

  final DbConflict _self;
  final $Res Function(DbConflict) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = freezed,}) {
  return _then(DbConflict(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DbUnknown implements DbError {
  const DbUnknown({this.message, this.cause});
  

 final  String? message;
 final  Object? cause;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbUnknownCopyWith<DbUnknown> get copyWith => _$DbUnknownCopyWithImpl<DbUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbUnknown&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'DbError.unknown(message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class $DbUnknownCopyWith<$Res> implements $DbErrorCopyWith<$Res> {
  factory $DbUnknownCopyWith(DbUnknown value, $Res Function(DbUnknown) _then) = _$DbUnknownCopyWithImpl;
@useResult
$Res call({
 String? message, Object? cause
});




}
/// @nodoc
class _$DbUnknownCopyWithImpl<$Res>
    implements $DbUnknownCopyWith<$Res> {
  _$DbUnknownCopyWithImpl(this._self, this._then);

  final DbUnknown _self;
  final $Res Function(DbUnknown) _then;

/// Create a copy of DbError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? cause = freezed,}) {
  return _then(DbUnknown(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

// dart format on
