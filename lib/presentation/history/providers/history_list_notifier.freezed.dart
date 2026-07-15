// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_list_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryListState {

 List<HistoryBill> get items; HistoryCursor? get nextCursor; HistorySummary? get summary; bool get hasMore; bool get isLoadingInitial; bool get isLoadingMore; Failure? get initialFailure; Failure? get loadMoreFailure;
/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryListStateCopyWith<HistoryListState> get copyWith => _$HistoryListStateCopyWithImpl<HistoryListState>(this as HistoryListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryListState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingInitial, isLoadingInitial) || other.isLoadingInitial == isLoadingInitial)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.initialFailure, initialFailure) || other.initialFailure == initialFailure)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,summary,hasMore,isLoadingInitial,isLoadingMore,initialFailure,loadMoreFailure);

@override
String toString() {
  return 'HistoryListState(items: $items, nextCursor: $nextCursor, summary: $summary, hasMore: $hasMore, isLoadingInitial: $isLoadingInitial, isLoadingMore: $isLoadingMore, initialFailure: $initialFailure, loadMoreFailure: $loadMoreFailure)';
}


}

/// @nodoc
abstract mixin class $HistoryListStateCopyWith<$Res>  {
  factory $HistoryListStateCopyWith(HistoryListState value, $Res Function(HistoryListState) _then) = _$HistoryListStateCopyWithImpl;
@useResult
$Res call({
 List<HistoryBill> items, HistoryCursor? nextCursor, HistorySummary? summary, bool hasMore, bool isLoadingInitial, bool isLoadingMore, Failure? initialFailure, Failure? loadMoreFailure
});


$HistoryCursorCopyWith<$Res>? get nextCursor;$HistorySummaryCopyWith<$Res>? get summary;$FailureCopyWith<$Res>? get initialFailure;$FailureCopyWith<$Res>? get loadMoreFailure;

}
/// @nodoc
class _$HistoryListStateCopyWithImpl<$Res>
    implements $HistoryListStateCopyWith<$Res> {
  _$HistoryListStateCopyWithImpl(this._self, this._then);

  final HistoryListState _self;
  final $Res Function(HistoryListState) _then;

/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,Object? summary = freezed,Object? hasMore = null,Object? isLoadingInitial = null,Object? isLoadingMore = null,Object? initialFailure = freezed,Object? loadMoreFailure = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<HistoryBill>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as HistoryCursor?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as HistorySummary?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingInitial: null == isLoadingInitial ? _self.isLoadingInitial : isLoadingInitial // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,initialFailure: freezed == initialFailure ? _self.initialFailure : initialFailure // ignore: cast_nullable_to_non_nullable
as Failure?,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of HistoryListState
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
}/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistorySummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $HistorySummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get initialFailure {
    if (_self.initialFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.initialFailure!, (value) {
    return _then(_self.copyWith(initialFailure: value));
  });
}/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get loadMoreFailure {
    if (_self.loadMoreFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.loadMoreFailure!, (value) {
    return _then(_self.copyWith(loadMoreFailure: value));
  });
}
}


/// Adds pattern-matching-related methods to [HistoryListState].
extension HistoryListStatePatterns on HistoryListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryListState value)  $default,){
final _that = this;
switch (_that) {
case _HistoryListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryListState value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HistoryBill> items,  HistoryCursor? nextCursor,  HistorySummary? summary,  bool hasMore,  bool isLoadingInitial,  bool isLoadingMore,  Failure? initialFailure,  Failure? loadMoreFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryListState() when $default != null:
return $default(_that.items,_that.nextCursor,_that.summary,_that.hasMore,_that.isLoadingInitial,_that.isLoadingMore,_that.initialFailure,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HistoryBill> items,  HistoryCursor? nextCursor,  HistorySummary? summary,  bool hasMore,  bool isLoadingInitial,  bool isLoadingMore,  Failure? initialFailure,  Failure? loadMoreFailure)  $default,) {final _that = this;
switch (_that) {
case _HistoryListState():
return $default(_that.items,_that.nextCursor,_that.summary,_that.hasMore,_that.isLoadingInitial,_that.isLoadingMore,_that.initialFailure,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HistoryBill> items,  HistoryCursor? nextCursor,  HistorySummary? summary,  bool hasMore,  bool isLoadingInitial,  bool isLoadingMore,  Failure? initialFailure,  Failure? loadMoreFailure)?  $default,) {final _that = this;
switch (_that) {
case _HistoryListState() when $default != null:
return $default(_that.items,_that.nextCursor,_that.summary,_that.hasMore,_that.isLoadingInitial,_that.isLoadingMore,_that.initialFailure,_that.loadMoreFailure);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryListState extends HistoryListState {
  const _HistoryListState({final  List<HistoryBill> items = const [], this.nextCursor, this.summary, this.hasMore = false, this.isLoadingInitial = false, this.isLoadingMore = false, this.initialFailure, this.loadMoreFailure}): _items = items,super._();
  

 final  List<HistoryBill> _items;
@override@JsonKey() List<HistoryBill> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  HistoryCursor? nextCursor;
@override final  HistorySummary? summary;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool isLoadingInitial;
@override@JsonKey() final  bool isLoadingMore;
@override final  Failure? initialFailure;
@override final  Failure? loadMoreFailure;

/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryListStateCopyWith<_HistoryListState> get copyWith => __$HistoryListStateCopyWithImpl<_HistoryListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryListState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingInitial, isLoadingInitial) || other.isLoadingInitial == isLoadingInitial)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.initialFailure, initialFailure) || other.initialFailure == initialFailure)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,summary,hasMore,isLoadingInitial,isLoadingMore,initialFailure,loadMoreFailure);

@override
String toString() {
  return 'HistoryListState(items: $items, nextCursor: $nextCursor, summary: $summary, hasMore: $hasMore, isLoadingInitial: $isLoadingInitial, isLoadingMore: $isLoadingMore, initialFailure: $initialFailure, loadMoreFailure: $loadMoreFailure)';
}


}

/// @nodoc
abstract mixin class _$HistoryListStateCopyWith<$Res> implements $HistoryListStateCopyWith<$Res> {
  factory _$HistoryListStateCopyWith(_HistoryListState value, $Res Function(_HistoryListState) _then) = __$HistoryListStateCopyWithImpl;
@override @useResult
$Res call({
 List<HistoryBill> items, HistoryCursor? nextCursor, HistorySummary? summary, bool hasMore, bool isLoadingInitial, bool isLoadingMore, Failure? initialFailure, Failure? loadMoreFailure
});


@override $HistoryCursorCopyWith<$Res>? get nextCursor;@override $HistorySummaryCopyWith<$Res>? get summary;@override $FailureCopyWith<$Res>? get initialFailure;@override $FailureCopyWith<$Res>? get loadMoreFailure;

}
/// @nodoc
class __$HistoryListStateCopyWithImpl<$Res>
    implements _$HistoryListStateCopyWith<$Res> {
  __$HistoryListStateCopyWithImpl(this._self, this._then);

  final _HistoryListState _self;
  final $Res Function(_HistoryListState) _then;

/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? summary = freezed,Object? hasMore = null,Object? isLoadingInitial = null,Object? isLoadingMore = null,Object? initialFailure = freezed,Object? loadMoreFailure = freezed,}) {
  return _then(_HistoryListState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<HistoryBill>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as HistoryCursor?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as HistorySummary?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingInitial: null == isLoadingInitial ? _self.isLoadingInitial : isLoadingInitial // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,initialFailure: freezed == initialFailure ? _self.initialFailure : initialFailure // ignore: cast_nullable_to_non_nullable
as Failure?,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of HistoryListState
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
}/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistorySummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $HistorySummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get initialFailure {
    if (_self.initialFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.initialFailure!, (value) {
    return _then(_self.copyWith(initialFailure: value));
  });
}/// Create a copy of HistoryListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get loadMoreFailure {
    if (_self.loadMoreFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.loadMoreFailure!, (value) {
    return _then(_self.copyWith(loadMoreFailure: value));
  });
}
}

// dart format on
