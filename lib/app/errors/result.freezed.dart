// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Result<T,E> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Result<T, E>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Result<$T, $E>()';
}


}

/// @nodoc
class $ResultCopyWith<T,E,$Res>  {
$ResultCopyWith(Result<T, E> _, $Res Function(Result<T, E>) __);
}


/// Adds pattern-matching-related methods to [Result].
extension ResultPatterns<T,E> on Result<T, E> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Success<T, E> value)?  success,TResult Function( Failure<T, E> value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Success() when success != null:
return success(_that);case Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Success<T, E> value)  success,required TResult Function( Failure<T, E> value)  failure,}){
final _that = this;
switch (_that) {
case Success():
return success(_that);case Failure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Success<T, E> value)?  success,TResult? Function( Failure<T, E> value)?  failure,}){
final _that = this;
switch (_that) {
case Success() when success != null:
return success(_that);case Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( T value)?  success,TResult Function( E error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Success() when success != null:
return success(_that.value);case Failure() when failure != null:
return failure(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( T value)  success,required TResult Function( E error)  failure,}) {final _that = this;
switch (_that) {
case Success():
return success(_that.value);case Failure():
return failure(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( T value)?  success,TResult? Function( E error)?  failure,}) {final _that = this;
switch (_that) {
case Success() when success != null:
return success(_that.value);case Failure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class Success<T,E> implements Result<T, E> {
  const Success(this.value);
  

 final  T value;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessCopyWith<T, E, Success<T, E>> get copyWith => _$SuccessCopyWithImpl<T, E, Success<T, E>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Success<T, E>&&const DeepCollectionEquality().equals(other.value, value));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'Result<$T, $E>.success(value: $value)';
}


}

/// @nodoc
abstract mixin class $SuccessCopyWith<T,E,$Res> implements $ResultCopyWith<T, E, $Res> {
  factory $SuccessCopyWith(Success<T, E> value, $Res Function(Success<T, E>) _then) = _$SuccessCopyWithImpl;
@useResult
$Res call({
 T value
});




}
/// @nodoc
class _$SuccessCopyWithImpl<T,E,$Res>
    implements $SuccessCopyWith<T, E, $Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success<T, E> _self;
  final $Res Function(Success<T, E>) _then;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = freezed,}) {
  return _then(Success<T, E>(
freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class Failure<T,E> implements Result<T, E> {
  const Failure(this.error);
  

 final  E error;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureCopyWith<T, E, Failure<T, E>> get copyWith => _$FailureCopyWithImpl<T, E, Failure<T, E>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure<T, E>&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'Result<$T, $E>.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $FailureCopyWith<T,E,$Res> implements $ResultCopyWith<T, E, $Res> {
  factory $FailureCopyWith(Failure<T, E> value, $Res Function(Failure<T, E>) _then) = _$FailureCopyWithImpl;
@useResult
$Res call({
 E error
});




}
/// @nodoc
class _$FailureCopyWithImpl<T,E,$Res>
    implements $FailureCopyWith<T, E, $Res> {
  _$FailureCopyWithImpl(this._self, this._then);

  final Failure<T, E> _self;
  final $Res Function(Failure<T, E>) _then;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(Failure<T, E>(
freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as E,
  ));
}


}

// dart format on
