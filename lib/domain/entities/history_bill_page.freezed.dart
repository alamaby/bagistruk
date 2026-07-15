// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_bill_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryBillPage {

 List<HistoryBill> get bills; bool get hasMore; HistoryCursor? get nextCursor;
/// Create a copy of HistoryBillPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryBillPageCopyWith<HistoryBillPage> get copyWith => _$HistoryBillPageCopyWithImpl<HistoryBillPage>(this as HistoryBillPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryBillPage&&const DeepCollectionEquality().equals(other.bills, bills)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bills),hasMore,nextCursor);

@override
String toString() {
  return 'HistoryBillPage(bills: $bills, hasMore: $hasMore, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $HistoryBillPageCopyWith<$Res>  {
  factory $HistoryBillPageCopyWith(HistoryBillPage value, $Res Function(HistoryBillPage) _then) = _$HistoryBillPageCopyWithImpl;
@useResult
$Res call({
 List<HistoryBill> bills, bool hasMore, HistoryCursor? nextCursor
});


$HistoryCursorCopyWith<$Res>? get nextCursor;

}
/// @nodoc
class _$HistoryBillPageCopyWithImpl<$Res>
    implements $HistoryBillPageCopyWith<$Res> {
  _$HistoryBillPageCopyWithImpl(this._self, this._then);

  final HistoryBillPage _self;
  final $Res Function(HistoryBillPage) _then;

/// Create a copy of HistoryBillPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bills = null,Object? hasMore = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
bills: null == bills ? _self.bills : bills // ignore: cast_nullable_to_non_nullable
as List<HistoryBill>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as HistoryCursor?,
  ));
}
/// Create a copy of HistoryBillPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistoryCursorCopyWith<$Res>? get nextCursor {
    if (_self.nextCursor == null) {
    return null;
  }

  return $HistoryCursorCopyWith<$Res>(_self.nextCursor!, (value) {
    return _then(_self.copyWith(nextCursor: value));
  });
}
}


/// Adds pattern-matching-related methods to [HistoryBillPage].
extension HistoryBillPagePatterns on HistoryBillPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryBillPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryBillPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryBillPage value)  $default,){
final _that = this;
switch (_that) {
case _HistoryBillPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryBillPage value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryBillPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HistoryBill> bills,  bool hasMore,  HistoryCursor? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryBillPage() when $default != null:
return $default(_that.bills,_that.hasMore,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HistoryBill> bills,  bool hasMore,  HistoryCursor? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _HistoryBillPage():
return $default(_that.bills,_that.hasMore,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HistoryBill> bills,  bool hasMore,  HistoryCursor? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _HistoryBillPage() when $default != null:
return $default(_that.bills,_that.hasMore,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryBillPage implements HistoryBillPage {
  const _HistoryBillPage({required final  List<HistoryBill> bills, required this.hasMore, this.nextCursor}): _bills = bills;
  

 final  List<HistoryBill> _bills;
@override List<HistoryBill> get bills {
  if (_bills is EqualUnmodifiableListView) return _bills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bills);
}

@override final  bool hasMore;
@override final  HistoryCursor? nextCursor;

/// Create a copy of HistoryBillPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryBillPageCopyWith<_HistoryBillPage> get copyWith => __$HistoryBillPageCopyWithImpl<_HistoryBillPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryBillPage&&const DeepCollectionEquality().equals(other._bills, _bills)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bills),hasMore,nextCursor);

@override
String toString() {
  return 'HistoryBillPage(bills: $bills, hasMore: $hasMore, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$HistoryBillPageCopyWith<$Res> implements $HistoryBillPageCopyWith<$Res> {
  factory _$HistoryBillPageCopyWith(_HistoryBillPage value, $Res Function(_HistoryBillPage) _then) = __$HistoryBillPageCopyWithImpl;
@override @useResult
$Res call({
 List<HistoryBill> bills, bool hasMore, HistoryCursor? nextCursor
});


@override $HistoryCursorCopyWith<$Res>? get nextCursor;

}
/// @nodoc
class __$HistoryBillPageCopyWithImpl<$Res>
    implements _$HistoryBillPageCopyWith<$Res> {
  __$HistoryBillPageCopyWithImpl(this._self, this._then);

  final _HistoryBillPage _self;
  final $Res Function(_HistoryBillPage) _then;

/// Create a copy of HistoryBillPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bills = null,Object? hasMore = null,Object? nextCursor = freezed,}) {
  return _then(_HistoryBillPage(
bills: null == bills ? _self._bills : bills // ignore: cast_nullable_to_non_nullable
as List<HistoryBill>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as HistoryCursor?,
  ));
}

/// Create a copy of HistoryBillPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistoryCursorCopyWith<$Res>? get nextCursor {
    if (_self.nextCursor == null) {
    return null;
  }

  return $HistoryCursorCopyWith<$Res>(_self.nextCursor!, (value) {
    return _then(_self.copyWith(nextCursor: value));
  });
}
}

// dart format on
