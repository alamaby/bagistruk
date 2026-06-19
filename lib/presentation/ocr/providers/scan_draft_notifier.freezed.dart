// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_draft_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScanDraftState {

 List<XFile> get images;
/// Create a copy of ScanDraftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanDraftStateCopyWith<ScanDraftState> get copyWith => _$ScanDraftStateCopyWithImpl<ScanDraftState>(this as ScanDraftState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanDraftState&&const DeepCollectionEquality().equals(other.images, images));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'ScanDraftState(images: $images)';
}


}

/// @nodoc
abstract mixin class $ScanDraftStateCopyWith<$Res>  {
  factory $ScanDraftStateCopyWith(ScanDraftState value, $Res Function(ScanDraftState) _then) = _$ScanDraftStateCopyWithImpl;
@useResult
$Res call({
 List<XFile> images
});




}
/// @nodoc
class _$ScanDraftStateCopyWithImpl<$Res>
    implements $ScanDraftStateCopyWith<$Res> {
  _$ScanDraftStateCopyWithImpl(this._self, this._then);

  final ScanDraftState _self;
  final $Res Function(ScanDraftState) _then;

/// Create a copy of ScanDraftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? images = null,}) {
  return _then(_self.copyWith(
images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<XFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanDraftState].
extension ScanDraftStatePatterns on ScanDraftState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanDraftState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanDraftState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanDraftState value)  $default,){
final _that = this;
switch (_that) {
case _ScanDraftState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanDraftState value)?  $default,){
final _that = this;
switch (_that) {
case _ScanDraftState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<XFile> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanDraftState() when $default != null:
return $default(_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<XFile> images)  $default,) {final _that = this;
switch (_that) {
case _ScanDraftState():
return $default(_that.images);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<XFile> images)?  $default,) {final _that = this;
switch (_that) {
case _ScanDraftState() when $default != null:
return $default(_that.images);case _:
  return null;

}
}

}

/// @nodoc


class _ScanDraftState implements ScanDraftState {
  const _ScanDraftState({required final  List<XFile> images}): _images = images;
  

 final  List<XFile> _images;
@override List<XFile> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of ScanDraftState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanDraftStateCopyWith<_ScanDraftState> get copyWith => __$ScanDraftStateCopyWithImpl<_ScanDraftState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanDraftState&&const DeepCollectionEquality().equals(other._images, _images));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'ScanDraftState(images: $images)';
}


}

/// @nodoc
abstract mixin class _$ScanDraftStateCopyWith<$Res> implements $ScanDraftStateCopyWith<$Res> {
  factory _$ScanDraftStateCopyWith(_ScanDraftState value, $Res Function(_ScanDraftState) _then) = __$ScanDraftStateCopyWithImpl;
@override @useResult
$Res call({
 List<XFile> images
});




}
/// @nodoc
class __$ScanDraftStateCopyWithImpl<$Res>
    implements _$ScanDraftStateCopyWith<$Res> {
  __$ScanDraftStateCopyWithImpl(this._self, this._then);

  final _ScanDraftState _self;
  final $Res Function(_ScanDraftState) _then;

/// Create a copy of ScanDraftState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? images = null,}) {
  return _then(_ScanDraftState(
images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<XFile>,
  ));
}


}

// dart format on
