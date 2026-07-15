// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_bill_page_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryBillPageDto {

 List<HistoryBillDto> get bills; HistoryCursorDto? get cursor;@JsonKey(name: 'has_more') bool get hasMore;
/// Create a copy of HistoryBillPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryBillPageDtoCopyWith<HistoryBillPageDto> get copyWith => _$HistoryBillPageDtoCopyWithImpl<HistoryBillPageDto>(this as HistoryBillPageDto, _$identity);

  /// Serializes this HistoryBillPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryBillPageDto&&const DeepCollectionEquality().equals(other.bills, bills)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bills),cursor,hasMore);

@override
String toString() {
  return 'HistoryBillPageDto(bills: $bills, cursor: $cursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $HistoryBillPageDtoCopyWith<$Res>  {
  factory $HistoryBillPageDtoCopyWith(HistoryBillPageDto value, $Res Function(HistoryBillPageDto) _then) = _$HistoryBillPageDtoCopyWithImpl;
@useResult
$Res call({
 List<HistoryBillDto> bills, HistoryCursorDto? cursor,@JsonKey(name: 'has_more') bool hasMore
});


$HistoryCursorDtoCopyWith<$Res>? get cursor;

}
/// @nodoc
class _$HistoryBillPageDtoCopyWithImpl<$Res>
    implements $HistoryBillPageDtoCopyWith<$Res> {
  _$HistoryBillPageDtoCopyWithImpl(this._self, this._then);

  final HistoryBillPageDto _self;
  final $Res Function(HistoryBillPageDto) _then;

/// Create a copy of HistoryBillPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bills = null,Object? cursor = freezed,Object? hasMore = null,}) {
  return _then(_self.copyWith(
bills: null == bills ? _self.bills : bills // ignore: cast_nullable_to_non_nullable
as List<HistoryBillDto>,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as HistoryCursorDto?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HistoryBillPageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistoryCursorDtoCopyWith<$Res>? get cursor {
    if (_self.cursor == null) {
    return null;
  }

  return $HistoryCursorDtoCopyWith<$Res>(_self.cursor!, (value) {
    return _then(_self.copyWith(cursor: value));
  });
}
}


/// Adds pattern-matching-related methods to [HistoryBillPageDto].
extension HistoryBillPageDtoPatterns on HistoryBillPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryBillPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryBillPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryBillPageDto value)  $default,){
final _that = this;
switch (_that) {
case _HistoryBillPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryBillPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryBillPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HistoryBillDto> bills,  HistoryCursorDto? cursor, @JsonKey(name: 'has_more')  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryBillPageDto() when $default != null:
return $default(_that.bills,_that.cursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HistoryBillDto> bills,  HistoryCursorDto? cursor, @JsonKey(name: 'has_more')  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _HistoryBillPageDto():
return $default(_that.bills,_that.cursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HistoryBillDto> bills,  HistoryCursorDto? cursor, @JsonKey(name: 'has_more')  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _HistoryBillPageDto() when $default != null:
return $default(_that.bills,_that.cursor,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryBillPageDto implements HistoryBillPageDto {
  const _HistoryBillPageDto({required final  List<HistoryBillDto> bills, this.cursor, @JsonKey(name: 'has_more') required this.hasMore}): _bills = bills;
  factory _HistoryBillPageDto.fromJson(Map<String, dynamic> json) => _$HistoryBillPageDtoFromJson(json);

 final  List<HistoryBillDto> _bills;
@override List<HistoryBillDto> get bills {
  if (_bills is EqualUnmodifiableListView) return _bills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bills);
}

@override final  HistoryCursorDto? cursor;
@override@JsonKey(name: 'has_more') final  bool hasMore;

/// Create a copy of HistoryBillPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryBillPageDtoCopyWith<_HistoryBillPageDto> get copyWith => __$HistoryBillPageDtoCopyWithImpl<_HistoryBillPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryBillPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryBillPageDto&&const DeepCollectionEquality().equals(other._bills, _bills)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bills),cursor,hasMore);

@override
String toString() {
  return 'HistoryBillPageDto(bills: $bills, cursor: $cursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$HistoryBillPageDtoCopyWith<$Res> implements $HistoryBillPageDtoCopyWith<$Res> {
  factory _$HistoryBillPageDtoCopyWith(_HistoryBillPageDto value, $Res Function(_HistoryBillPageDto) _then) = __$HistoryBillPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<HistoryBillDto> bills, HistoryCursorDto? cursor,@JsonKey(name: 'has_more') bool hasMore
});


@override $HistoryCursorDtoCopyWith<$Res>? get cursor;

}
/// @nodoc
class __$HistoryBillPageDtoCopyWithImpl<$Res>
    implements _$HistoryBillPageDtoCopyWith<$Res> {
  __$HistoryBillPageDtoCopyWithImpl(this._self, this._then);

  final _HistoryBillPageDto _self;
  final $Res Function(_HistoryBillPageDto) _then;

/// Create a copy of HistoryBillPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bills = null,Object? cursor = freezed,Object? hasMore = null,}) {
  return _then(_HistoryBillPageDto(
bills: null == bills ? _self._bills : bills // ignore: cast_nullable_to_non_nullable
as List<HistoryBillDto>,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as HistoryCursorDto?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HistoryBillPageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistoryCursorDtoCopyWith<$Res>? get cursor {
    if (_self.cursor == null) {
    return null;
  }

  return $HistoryCursorDtoCopyWith<$Res>(_self.cursor!, (value) {
    return _then(_self.copyWith(cursor: value));
  });
}
}

// dart format on
