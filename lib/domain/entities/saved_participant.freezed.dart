// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedParticipant {

 String get name;/// Normalised phone (digits-only, country code prefixed when possible).
/// Empty string when participant has no phone.
 String get phone; int get useCount; DateTime get lastUsedAt;
/// Create a copy of SavedParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedParticipantCopyWith<SavedParticipant> get copyWith => _$SavedParticipantCopyWithImpl<SavedParticipant>(this as SavedParticipant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedParticipant&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.useCount, useCount) || other.useCount == useCount)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt));
}


@override
int get hashCode => Object.hash(runtimeType,name,phone,useCount,lastUsedAt);

@override
String toString() {
  return 'SavedParticipant(name: $name, phone: $phone, useCount: $useCount, lastUsedAt: $lastUsedAt)';
}


}

/// @nodoc
abstract mixin class $SavedParticipantCopyWith<$Res>  {
  factory $SavedParticipantCopyWith(SavedParticipant value, $Res Function(SavedParticipant) _then) = _$SavedParticipantCopyWithImpl;
@useResult
$Res call({
 String name, String phone, int useCount, DateTime lastUsedAt
});




}
/// @nodoc
class _$SavedParticipantCopyWithImpl<$Res>
    implements $SavedParticipantCopyWith<$Res> {
  _$SavedParticipantCopyWithImpl(this._self, this._then);

  final SavedParticipant _self;
  final $Res Function(SavedParticipant) _then;

/// Create a copy of SavedParticipant
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


/// Adds pattern-matching-related methods to [SavedParticipant].
extension SavedParticipantPatterns on SavedParticipant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedParticipant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedParticipant value)  $default,){
final _that = this;
switch (_that) {
case _SavedParticipant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _SavedParticipant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String phone,  int useCount,  DateTime lastUsedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedParticipant() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String phone,  int useCount,  DateTime lastUsedAt)  $default,) {final _that = this;
switch (_that) {
case _SavedParticipant():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String phone,  int useCount,  DateTime lastUsedAt)?  $default,) {final _that = this;
switch (_that) {
case _SavedParticipant() when $default != null:
return $default(_that.name,_that.phone,_that.useCount,_that.lastUsedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SavedParticipant implements SavedParticipant {
  const _SavedParticipant({required this.name, this.phone = '', this.useCount = 1, required this.lastUsedAt});
  

@override final  String name;
/// Normalised phone (digits-only, country code prefixed when possible).
/// Empty string when participant has no phone.
@override@JsonKey() final  String phone;
@override@JsonKey() final  int useCount;
@override final  DateTime lastUsedAt;

/// Create a copy of SavedParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedParticipantCopyWith<_SavedParticipant> get copyWith => __$SavedParticipantCopyWithImpl<_SavedParticipant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedParticipant&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.useCount, useCount) || other.useCount == useCount)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt));
}


@override
int get hashCode => Object.hash(runtimeType,name,phone,useCount,lastUsedAt);

@override
String toString() {
  return 'SavedParticipant(name: $name, phone: $phone, useCount: $useCount, lastUsedAt: $lastUsedAt)';
}


}

/// @nodoc
abstract mixin class _$SavedParticipantCopyWith<$Res> implements $SavedParticipantCopyWith<$Res> {
  factory _$SavedParticipantCopyWith(_SavedParticipant value, $Res Function(_SavedParticipant) _then) = __$SavedParticipantCopyWithImpl;
@override @useResult
$Res call({
 String name, String phone, int useCount, DateTime lastUsedAt
});




}
/// @nodoc
class __$SavedParticipantCopyWithImpl<$Res>
    implements _$SavedParticipantCopyWith<$Res> {
  __$SavedParticipantCopyWithImpl(this._self, this._then);

  final _SavedParticipant _self;
  final $Res Function(_SavedParticipant) _then;

/// Create a copy of SavedParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? phone = null,Object? useCount = null,Object? lastUsedAt = null,}) {
  return _then(_SavedParticipant(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,lastUsedAt: null == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
