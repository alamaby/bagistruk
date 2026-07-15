// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistorySummary {

 int get totalBillCount; List<String> get availableCurrencies; List<OutstandingByCurrency> get outstanding;
/// Create a copy of HistorySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistorySummaryCopyWith<HistorySummary> get copyWith => _$HistorySummaryCopyWithImpl<HistorySummary>(this as HistorySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistorySummary&&(identical(other.totalBillCount, totalBillCount) || other.totalBillCount == totalBillCount)&&const DeepCollectionEquality().equals(other.availableCurrencies, availableCurrencies)&&const DeepCollectionEquality().equals(other.outstanding, outstanding));
}


@override
int get hashCode => Object.hash(runtimeType,totalBillCount,const DeepCollectionEquality().hash(availableCurrencies),const DeepCollectionEquality().hash(outstanding));

@override
String toString() {
  return 'HistorySummary(totalBillCount: $totalBillCount, availableCurrencies: $availableCurrencies, outstanding: $outstanding)';
}


}

/// @nodoc
abstract mixin class $HistorySummaryCopyWith<$Res>  {
  factory $HistorySummaryCopyWith(HistorySummary value, $Res Function(HistorySummary) _then) = _$HistorySummaryCopyWithImpl;
@useResult
$Res call({
 int totalBillCount, List<String> availableCurrencies, List<OutstandingByCurrency> outstanding
});




}
/// @nodoc
class _$HistorySummaryCopyWithImpl<$Res>
    implements $HistorySummaryCopyWith<$Res> {
  _$HistorySummaryCopyWithImpl(this._self, this._then);

  final HistorySummary _self;
  final $Res Function(HistorySummary) _then;

/// Create a copy of HistorySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBillCount = null,Object? availableCurrencies = null,Object? outstanding = null,}) {
  return _then(_self.copyWith(
totalBillCount: null == totalBillCount ? _self.totalBillCount : totalBillCount // ignore: cast_nullable_to_non_nullable
as int,availableCurrencies: null == availableCurrencies ? _self.availableCurrencies : availableCurrencies // ignore: cast_nullable_to_non_nullable
as List<String>,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as List<OutstandingByCurrency>,
  ));
}

}


/// Adds pattern-matching-related methods to [HistorySummary].
extension HistorySummaryPatterns on HistorySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistorySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistorySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistorySummary value)  $default,){
final _that = this;
switch (_that) {
case _HistorySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistorySummary value)?  $default,){
final _that = this;
switch (_that) {
case _HistorySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalBillCount,  List<String> availableCurrencies,  List<OutstandingByCurrency> outstanding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistorySummary() when $default != null:
return $default(_that.totalBillCount,_that.availableCurrencies,_that.outstanding);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalBillCount,  List<String> availableCurrencies,  List<OutstandingByCurrency> outstanding)  $default,) {final _that = this;
switch (_that) {
case _HistorySummary():
return $default(_that.totalBillCount,_that.availableCurrencies,_that.outstanding);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalBillCount,  List<String> availableCurrencies,  List<OutstandingByCurrency> outstanding)?  $default,) {final _that = this;
switch (_that) {
case _HistorySummary() when $default != null:
return $default(_that.totalBillCount,_that.availableCurrencies,_that.outstanding);case _:
  return null;

}
}

}

/// @nodoc


class _HistorySummary extends HistorySummary {
  const _HistorySummary({required this.totalBillCount, required final  List<String> availableCurrencies, required final  List<OutstandingByCurrency> outstanding}): _availableCurrencies = availableCurrencies,_outstanding = outstanding,super._();
  

@override final  int totalBillCount;
 final  List<String> _availableCurrencies;
@override List<String> get availableCurrencies {
  if (_availableCurrencies is EqualUnmodifiableListView) return _availableCurrencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableCurrencies);
}

 final  List<OutstandingByCurrency> _outstanding;
@override List<OutstandingByCurrency> get outstanding {
  if (_outstanding is EqualUnmodifiableListView) return _outstanding;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_outstanding);
}


/// Create a copy of HistorySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistorySummaryCopyWith<_HistorySummary> get copyWith => __$HistorySummaryCopyWithImpl<_HistorySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistorySummary&&(identical(other.totalBillCount, totalBillCount) || other.totalBillCount == totalBillCount)&&const DeepCollectionEquality().equals(other._availableCurrencies, _availableCurrencies)&&const DeepCollectionEquality().equals(other._outstanding, _outstanding));
}


@override
int get hashCode => Object.hash(runtimeType,totalBillCount,const DeepCollectionEquality().hash(_availableCurrencies),const DeepCollectionEquality().hash(_outstanding));

@override
String toString() {
  return 'HistorySummary(totalBillCount: $totalBillCount, availableCurrencies: $availableCurrencies, outstanding: $outstanding)';
}


}

/// @nodoc
abstract mixin class _$HistorySummaryCopyWith<$Res> implements $HistorySummaryCopyWith<$Res> {
  factory _$HistorySummaryCopyWith(_HistorySummary value, $Res Function(_HistorySummary) _then) = __$HistorySummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalBillCount, List<String> availableCurrencies, List<OutstandingByCurrency> outstanding
});




}
/// @nodoc
class __$HistorySummaryCopyWithImpl<$Res>
    implements _$HistorySummaryCopyWith<$Res> {
  __$HistorySummaryCopyWithImpl(this._self, this._then);

  final _HistorySummary _self;
  final $Res Function(_HistorySummary) _then;

/// Create a copy of HistorySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBillCount = null,Object? availableCurrencies = null,Object? outstanding = null,}) {
  return _then(_HistorySummary(
totalBillCount: null == totalBillCount ? _self.totalBillCount : totalBillCount // ignore: cast_nullable_to_non_nullable
as int,availableCurrencies: null == availableCurrencies ? _self._availableCurrencies : availableCurrencies // ignore: cast_nullable_to_non_nullable
as List<String>,outstanding: null == outstanding ? _self._outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as List<OutstandingByCurrency>,
  ));
}


}

/// @nodoc
mixin _$OutstandingByCurrency {

 String get currency; double get amount;
/// Create a copy of OutstandingByCurrency
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutstandingByCurrencyCopyWith<OutstandingByCurrency> get copyWith => _$OutstandingByCurrencyCopyWithImpl<OutstandingByCurrency>(this as OutstandingByCurrency, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutstandingByCurrency&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,currency,amount);

@override
String toString() {
  return 'OutstandingByCurrency(currency: $currency, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $OutstandingByCurrencyCopyWith<$Res>  {
  factory $OutstandingByCurrencyCopyWith(OutstandingByCurrency value, $Res Function(OutstandingByCurrency) _then) = _$OutstandingByCurrencyCopyWithImpl;
@useResult
$Res call({
 String currency, double amount
});




}
/// @nodoc
class _$OutstandingByCurrencyCopyWithImpl<$Res>
    implements $OutstandingByCurrencyCopyWith<$Res> {
  _$OutstandingByCurrencyCopyWithImpl(this._self, this._then);

  final OutstandingByCurrency _self;
  final $Res Function(OutstandingByCurrency) _then;

/// Create a copy of OutstandingByCurrency
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? amount = null,}) {
  return _then(_self.copyWith(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OutstandingByCurrency].
extension OutstandingByCurrencyPatterns on OutstandingByCurrency {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutstandingByCurrency value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutstandingByCurrency() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutstandingByCurrency value)  $default,){
final _that = this;
switch (_that) {
case _OutstandingByCurrency():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutstandingByCurrency value)?  $default,){
final _that = this;
switch (_that) {
case _OutstandingByCurrency() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currency,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutstandingByCurrency() when $default != null:
return $default(_that.currency,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currency,  double amount)  $default,) {final _that = this;
switch (_that) {
case _OutstandingByCurrency():
return $default(_that.currency,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currency,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _OutstandingByCurrency() when $default != null:
return $default(_that.currency,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _OutstandingByCurrency implements OutstandingByCurrency {
  const _OutstandingByCurrency({required this.currency, required this.amount});
  

@override final  String currency;
@override final  double amount;

/// Create a copy of OutstandingByCurrency
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutstandingByCurrencyCopyWith<_OutstandingByCurrency> get copyWith => __$OutstandingByCurrencyCopyWithImpl<_OutstandingByCurrency>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutstandingByCurrency&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,currency,amount);

@override
String toString() {
  return 'OutstandingByCurrency(currency: $currency, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$OutstandingByCurrencyCopyWith<$Res> implements $OutstandingByCurrencyCopyWith<$Res> {
  factory _$OutstandingByCurrencyCopyWith(_OutstandingByCurrency value, $Res Function(_OutstandingByCurrency) _then) = __$OutstandingByCurrencyCopyWithImpl;
@override @useResult
$Res call({
 String currency, double amount
});




}
/// @nodoc
class __$OutstandingByCurrencyCopyWithImpl<$Res>
    implements _$OutstandingByCurrencyCopyWith<$Res> {
  __$OutstandingByCurrencyCopyWithImpl(this._self, this._then);

  final _OutstandingByCurrency _self;
  final $Res Function(_OutstandingByCurrency) _then;

/// Create a copy of OutstandingByCurrency
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? amount = null,}) {
  return _then(_OutstandingByCurrency(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
