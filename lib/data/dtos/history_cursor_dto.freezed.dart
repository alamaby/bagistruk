// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_cursor_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryCursorDto {

@JsonKey(name: 'sort_value') String get sortValue;@JsonKey(name: 'created_at') DateTime get createdAt; String get id;
/// Create a copy of HistoryCursorDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryCursorDtoCopyWith<HistoryCursorDto> get copyWith => _$HistoryCursorDtoCopyWithImpl<HistoryCursorDto>(this as HistoryCursorDto, _$identity);

  /// Serializes this HistoryCursorDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryCursorDto&&(identical(other.sortValue, sortValue) || other.sortValue == sortValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sortValue,createdAt,id);

@override
String toString() {
  return 'HistoryCursorDto(sortValue: $sortValue, createdAt: $createdAt, id: $id)';
}


}

/// @nodoc
abstract mixin class $HistoryCursorDtoCopyWith<$Res>  {
  factory $HistoryCursorDtoCopyWith(HistoryCursorDto value, $Res Function(HistoryCursorDto) _then) = _$HistoryCursorDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'sort_value') String sortValue,@JsonKey(name: 'created_at') DateTime createdAt, String id
});




}
/// @nodoc
class _$HistoryCursorDtoCopyWithImpl<$Res>
    implements $HistoryCursorDtoCopyWith<$Res> {
  _$HistoryCursorDtoCopyWithImpl(this._self, this._then);

  final HistoryCursorDto _self;
  final $Res Function(HistoryCursorDto) _then;

/// Create a copy of HistoryCursorDto
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


/// Adds pattern-matching-related methods to [HistoryCursorDto].
extension HistoryCursorDtoPatterns on HistoryCursorDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryCursorDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryCursorDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryCursorDto value)  $default,){
final _that = this;
switch (_that) {
case _HistoryCursorDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryCursorDto value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryCursorDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'sort_value')  String sortValue, @JsonKey(name: 'created_at')  DateTime createdAt,  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryCursorDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'sort_value')  String sortValue, @JsonKey(name: 'created_at')  DateTime createdAt,  String id)  $default,) {final _that = this;
switch (_that) {
case _HistoryCursorDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'sort_value')  String sortValue, @JsonKey(name: 'created_at')  DateTime createdAt,  String id)?  $default,) {final _that = this;
switch (_that) {
case _HistoryCursorDto() when $default != null:
return $default(_that.sortValue,_that.createdAt,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryCursorDto implements HistoryCursorDto {
  const _HistoryCursorDto({@JsonKey(name: 'sort_value') required this.sortValue, @JsonKey(name: 'created_at') required this.createdAt, required this.id});
  factory _HistoryCursorDto.fromJson(Map<String, dynamic> json) => _$HistoryCursorDtoFromJson(json);

@override@JsonKey(name: 'sort_value') final  String sortValue;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override final  String id;

/// Create a copy of HistoryCursorDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryCursorDtoCopyWith<_HistoryCursorDto> get copyWith => __$HistoryCursorDtoCopyWithImpl<_HistoryCursorDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryCursorDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryCursorDto&&(identical(other.sortValue, sortValue) || other.sortValue == sortValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sortValue,createdAt,id);

@override
String toString() {
  return 'HistoryCursorDto(sortValue: $sortValue, createdAt: $createdAt, id: $id)';
}


}

/// @nodoc
abstract mixin class _$HistoryCursorDtoCopyWith<$Res> implements $HistoryCursorDtoCopyWith<$Res> {
  factory _$HistoryCursorDtoCopyWith(_HistoryCursorDto value, $Res Function(_HistoryCursorDto) _then) = __$HistoryCursorDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'sort_value') String sortValue,@JsonKey(name: 'created_at') DateTime createdAt, String id
});




}
/// @nodoc
class __$HistoryCursorDtoCopyWithImpl<$Res>
    implements _$HistoryCursorDtoCopyWith<$Res> {
  __$HistoryCursorDtoCopyWithImpl(this._self, this._then);

  final _HistoryCursorDto _self;
  final $Res Function(_HistoryCursorDto) _then;

/// Create a copy of HistoryCursorDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sortValue = null,Object? createdAt = null,Object? id = null,}) {
  return _then(_HistoryCursorDto(
sortValue: null == sortValue ? _self.sortValue : sortValue // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
