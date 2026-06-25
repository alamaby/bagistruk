// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_participant_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavedParticipantDto {

 String get name; String get phone;@JsonKey(name: 'use_count') int get useCount;@JsonKey(name: 'last_used_at') DateTime get lastUsedAt;
/// Create a copy of SavedParticipantDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedParticipantDtoCopyWith<SavedParticipantDto> get copyWith => _$SavedParticipantDtoCopyWithImpl<SavedParticipantDto>(this as SavedParticipantDto, _$identity);

  /// Serializes this SavedParticipantDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedParticipantDto&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.useCount, useCount) || other.useCount == useCount)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,phone,useCount,lastUsedAt);

@override
String toString() {
  return 'SavedParticipantDto(name: $name, phone: $phone, useCount: $useCount, lastUsedAt: $lastUsedAt)';
}


}

/// @nodoc
abstract mixin class $SavedParticipantDtoCopyWith<$Res>  {
  factory $SavedParticipantDtoCopyWith(SavedParticipantDto value, $Res Function(SavedParticipantDto) _then) = _$SavedParticipantDtoCopyWithImpl;
@useResult
$Res call({
 String name, String phone,@JsonKey(name: 'use_count') int useCount,@JsonKey(name: 'last_used_at') DateTime lastUsedAt
});




}
/// @nodoc
class _$SavedParticipantDtoCopyWithImpl<$Res>
    implements $SavedParticipantDtoCopyWith<$Res> {
  _$SavedParticipantDtoCopyWithImpl(this._self, this._then);

  final SavedParticipantDto _self;
  final $Res Function(SavedParticipantDto) _then;

/// Create a copy of SavedParticipantDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? phone = null,Object? useCount = null,Object? lastUsedAt = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,lastUsedAt: null == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedParticipantDto].
extension SavedParticipantDtoPatterns on SavedParticipantDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedParticipantDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedParticipantDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedParticipantDto value)  $default,){
final _that = this;
switch (_that) {
case _SavedParticipantDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedParticipantDto value)?  $default,){
final _that = this;
switch (_that) {
case _SavedParticipantDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String phone, @JsonKey(name: 'use_count')  int useCount, @JsonKey(name: 'last_used_at')  DateTime lastUsedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedParticipantDto() when $default != null:
return $default(_that.name,_that.phone,_that.useCount,_that.lastUsedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String phone, @JsonKey(name: 'use_count')  int useCount, @JsonKey(name: 'last_used_at')  DateTime lastUsedAt)  $default,) {final _that = this;
switch (_that) {
case _SavedParticipantDto():
return $default(_that.name,_that.phone,_that.useCount,_that.lastUsedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String phone, @JsonKey(name: 'use_count')  int useCount, @JsonKey(name: 'last_used_at')  DateTime lastUsedAt)?  $default,) {final _that = this;
switch (_that) {
case _SavedParticipantDto() when $default != null:
return $default(_that.name,_that.phone,_that.useCount,_that.lastUsedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedParticipantDto extends SavedParticipantDto {
  const _SavedParticipantDto({required this.name, this.phone = '', @JsonKey(name: 'use_count') this.useCount = 1, @JsonKey(name: 'last_used_at') required this.lastUsedAt}): super._();
  factory _SavedParticipantDto.fromJson(Map<String, dynamic> json) => _$SavedParticipantDtoFromJson(json);

@override final  String name;
@override@JsonKey() final  String phone;
@override@JsonKey(name: 'use_count') final  int useCount;
@override@JsonKey(name: 'last_used_at') final  DateTime lastUsedAt;

/// Create a copy of SavedParticipantDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedParticipantDtoCopyWith<_SavedParticipantDto> get copyWith => __$SavedParticipantDtoCopyWithImpl<_SavedParticipantDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedParticipantDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedParticipantDto&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.useCount, useCount) || other.useCount == useCount)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,phone,useCount,lastUsedAt);

@override
String toString() {
  return 'SavedParticipantDto(name: $name, phone: $phone, useCount: $useCount, lastUsedAt: $lastUsedAt)';
}


}

/// @nodoc
abstract mixin class _$SavedParticipantDtoCopyWith<$Res> implements $SavedParticipantDtoCopyWith<$Res> {
  factory _$SavedParticipantDtoCopyWith(_SavedParticipantDto value, $Res Function(_SavedParticipantDto) _then) = __$SavedParticipantDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String phone,@JsonKey(name: 'use_count') int useCount,@JsonKey(name: 'last_used_at') DateTime lastUsedAt
});




}
/// @nodoc
class __$SavedParticipantDtoCopyWithImpl<$Res>
    implements _$SavedParticipantDtoCopyWith<$Res> {
  __$SavedParticipantDtoCopyWithImpl(this._self, this._then);

  final _SavedParticipantDto _self;
  final $Res Function(_SavedParticipantDto) _then;

/// Create a copy of SavedParticipantDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? phone = null,Object? useCount = null,Object? lastUsedAt = null,}) {
  return _then(_SavedParticipantDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,lastUsedAt: null == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
