// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_cursor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryCursor {

 String get sortValue; DateTime get createdAt; String get id;
/// Create a copy of HistoryCursor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryCursorCopyWith<HistoryCursor> get copyWith => _$HistoryCursorCopyWithImpl<HistoryCursor>(this as HistoryCursor, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryCursor&&(identical(other.sortValue, sortValue) || other.sortValue == sortValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,sortValue,createdAt,id);

@override
String toString() {
  return 'HistoryCursor(sortValue: $sortValue, createdAt: $createdAt, id: $id)';
}


}

/// @nodoc
abstract mixin class $HistoryCursorCopyWith<$Res>  {
  factory $HistoryCursorCopyWith(HistoryCursor value, $Res Function(HistoryCursor) _then) = _$HistoryCursorCopyWithImpl;
@useResult
$Res call({
 String sortValue, DateTime createdAt, String id
});




}
/// @nodoc
class _$HistoryCursorCopyWithImpl<$Res>
    implements $HistoryCursorCopyWith<$Res> {
  _$HistoryCursorCopyWithImpl(this._self, this._then);

  final HistoryCursor _self;
  final $Res Function(HistoryCursor) _then;

/// Create a copy of HistoryCursor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sortValue = null,Object? createdAt = null,Object? id = null,}) {
  return _then(_self.copyWith(
sortValue: null == sortValue ? _self.sortValue : sortValue // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryCursor].
extension HistoryCursorPatterns on HistoryCursor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryCursor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryCursor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryCursor value)  $default,){
final _that = this;
switch (_that) {
case _HistoryCursor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryCursor value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryCursor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sortValue,  DateTime createdAt,  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryCursor() when $default != null:
return $default(_that.sortValue,_that.createdAt,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sortValue,  DateTime createdAt,  String id)  $default,) {final _that = this;
switch (_that) {
case _HistoryCursor():
return $default(_that.sortValue,_that.createdAt,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sortValue,  DateTime createdAt,  String id)?  $default,) {final _that = this;
switch (_that) {
case _HistoryCursor() when $default != null:
return $default(_that.sortValue,_that.createdAt,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryCursor implements HistoryCursor {
  const _HistoryCursor({required this.sortValue, required this.createdAt, required this.id});
  

@override final  String sortValue;
@override final  DateTime createdAt;
@override final  String id;

/// Create a copy of HistoryCursor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryCursorCopyWith<_HistoryCursor> get copyWith => __$HistoryCursorCopyWithImpl<_HistoryCursor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryCursor&&(identical(other.sortValue, sortValue) || other.sortValue == sortValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,sortValue,createdAt,id);

@override
String toString() {
  return 'HistoryCursor(sortValue: $sortValue, createdAt: $createdAt, id: $id)';
}


}

/// @nodoc
abstract mixin class _$HistoryCursorCopyWith<$Res> implements $HistoryCursorCopyWith<$Res> {
  factory _$HistoryCursorCopyWith(_HistoryCursor value, $Res Function(_HistoryCursor) _then) = __$HistoryCursorCopyWithImpl;
@override @useResult
$Res call({
 String sortValue, DateTime createdAt, String id
});




}
/// @nodoc
class __$HistoryCursorCopyWithImpl<$Res>
    implements _$HistoryCursorCopyWith<$Res> {
  __$HistoryCursorCopyWithImpl(this._self, this._then);

  final _HistoryCursor _self;
  final $Res Function(_HistoryCursor) _then;

/// Create a copy of HistoryCursor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sortValue = null,Object? createdAt = null,Object? id = null,}) {
  return _then(_HistoryCursor(
sortValue: null == sortValue ? _self.sortValue : sortValue // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
