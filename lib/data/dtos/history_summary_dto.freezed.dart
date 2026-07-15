// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistorySummaryDto {

@JsonKey(name: 'total_bill_count') int get totalBillCount;@JsonKey(name: 'available_currencies') List<String> get availableCurrencies;@JsonKey(name: 'outstanding_by_currency') List<OutstandingDto> get outstanding;
/// Create a copy of HistorySummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistorySummaryDtoCopyWith<HistorySummaryDto> get copyWith => _$HistorySummaryDtoCopyWithImpl<HistorySummaryDto>(this as HistorySummaryDto, _$identity);

  /// Serializes this HistorySummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistorySummaryDto&&(identical(other.totalBillCount, totalBillCount) || other.totalBillCount == totalBillCount)&&const DeepCollectionEquality().equals(other.availableCurrencies, availableCurrencies)&&const DeepCollectionEquality().equals(other.outstanding, outstanding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBillCount,const DeepCollectionEquality().hash(availableCurrencies),const DeepCollectionEquality().hash(outstanding));

@override
String toString() {
  return 'HistorySummaryDto(totalBillCount: $totalBillCount, availableCurrencies: $availableCurrencies, outstanding: $outstanding)';
}


}

/// @nodoc
abstract mixin class $HistorySummaryDtoCopyWith<$Res>  {
  factory $HistorySummaryDtoCopyWith(HistorySummaryDto value, $Res Function(HistorySummaryDto) _then) = _$HistorySummaryDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_bill_count') int totalBillCount,@JsonKey(name: 'available_currencies') List<String> availableCurrencies,@JsonKey(name: 'outstanding_by_currency') List<OutstandingDto> outstanding
});




}
/// @nodoc
class _$HistorySummaryDtoCopyWithImpl<$Res>
    implements $HistorySummaryDtoCopyWith<$Res> {
  _$HistorySummaryDtoCopyWithImpl(this._self, this._then);

  final HistorySummaryDto _self;
  final $Res Function(HistorySummaryDto) _then;

/// Create a copy of HistorySummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBillCount = null,Object? availableCurrencies = null,Object? outstanding = null,}) {
  return _then(_self.copyWith(
totalBillCount: null == totalBillCount ? _self.totalBillCount : totalBillCount // ignore: cast_nullable_to_non_nullable
as int,availableCurrencies: null == availableCurrencies ? _self.availableCurrencies : availableCurrencies // ignore: cast_nullable_to_non_nullable
as List<String>,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as List<OutstandingDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [HistorySummaryDto].
extension HistorySummaryDtoPatterns on HistorySummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistorySummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistorySummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistorySummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _HistorySummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistorySummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _HistorySummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_bill_count')  int totalBillCount, @JsonKey(name: 'available_currencies')  List<String> availableCurrencies, @JsonKey(name: 'outstanding_by_currency')  List<OutstandingDto> outstanding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistorySummaryDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_bill_count')  int totalBillCount, @JsonKey(name: 'available_currencies')  List<String> availableCurrencies, @JsonKey(name: 'outstanding_by_currency')  List<OutstandingDto> outstanding)  $default,) {final _that = this;
switch (_that) {
case _HistorySummaryDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_bill_count')  int totalBillCount, @JsonKey(name: 'available_currencies')  List<String> availableCurrencies, @JsonKey(name: 'outstanding_by_currency')  List<OutstandingDto> outstanding)?  $default,) {final _that = this;
switch (_that) {
case _HistorySummaryDto() when $default != null:
return $default(_that.totalBillCount,_that.availableCurrencies,_that.outstanding);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistorySummaryDto implements HistorySummaryDto {
  const _HistorySummaryDto({@JsonKey(name: 'total_bill_count') required this.totalBillCount, @JsonKey(name: 'available_currencies') required final  List<String> availableCurrencies, @JsonKey(name: 'outstanding_by_currency') required final  List<OutstandingDto> outstanding}): _availableCurrencies = availableCurrencies,_outstanding = outstanding;
  factory _HistorySummaryDto.fromJson(Map<String, dynamic> json) => _$HistorySummaryDtoFromJson(json);

@override@JsonKey(name: 'total_bill_count') final  int totalBillCount;
 final  List<String> _availableCurrencies;
@override@JsonKey(name: 'available_currencies') List<String> get availableCurrencies {
  if (_availableCurrencies is EqualUnmodifiableListView) return _availableCurrencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableCurrencies);
}

 final  List<OutstandingDto> _outstanding;
@override@JsonKey(name: 'outstanding_by_currency') List<OutstandingDto> get outstanding {
  if (_outstanding is EqualUnmodifiableListView) return _outstanding;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_outstanding);
}


/// Create a copy of HistorySummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistorySummaryDtoCopyWith<_HistorySummaryDto> get copyWith => __$HistorySummaryDtoCopyWithImpl<_HistorySummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistorySummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistorySummaryDto&&(identical(other.totalBillCount, totalBillCount) || other.totalBillCount == totalBillCount)&&const DeepCollectionEquality().equals(other._availableCurrencies, _availableCurrencies)&&const DeepCollectionEquality().equals(other._outstanding, _outstanding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBillCount,const DeepCollectionEquality().hash(_availableCurrencies),const DeepCollectionEquality().hash(_outstanding));

@override
String toString() {
  return 'HistorySummaryDto(totalBillCount: $totalBillCount, availableCurrencies: $availableCurrencies, outstanding: $outstanding)';
}


}

/// @nodoc
abstract mixin class _$HistorySummaryDtoCopyWith<$Res> implements $HistorySummaryDtoCopyWith<$Res> {
  factory _$HistorySummaryDtoCopyWith(_HistorySummaryDto value, $Res Function(_HistorySummaryDto) _then) = __$HistorySummaryDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_bill_count') int totalBillCount,@JsonKey(name: 'available_currencies') List<String> availableCurrencies,@JsonKey(name: 'outstanding_by_currency') List<OutstandingDto> outstanding
});




}
/// @nodoc
class __$HistorySummaryDtoCopyWithImpl<$Res>
    implements _$HistorySummaryDtoCopyWith<$Res> {
  __$HistorySummaryDtoCopyWithImpl(this._self, this._then);

  final _HistorySummaryDto _self;
  final $Res Function(_HistorySummaryDto) _then;

/// Create a copy of HistorySummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBillCount = null,Object? availableCurrencies = null,Object? outstanding = null,}) {
  return _then(_HistorySummaryDto(
totalBillCount: null == totalBillCount ? _self.totalBillCount : totalBillCount // ignore: cast_nullable_to_non_nullable
as int,availableCurrencies: null == availableCurrencies ? _self._availableCurrencies : availableCurrencies // ignore: cast_nullable_to_non_nullable
as List<String>,outstanding: null == outstanding ? _self._outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as List<OutstandingDto>,
  ));
}


}


/// @nodoc
mixin _$OutstandingDto {

 String get currency; double get amount;
/// Create a copy of OutstandingDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutstandingDtoCopyWith<OutstandingDto> get copyWith => _$OutstandingDtoCopyWithImpl<OutstandingDto>(this as OutstandingDto, _$identity);

  /// Serializes this OutstandingDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutstandingDto&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currency,amount);

@override
String toString() {
  return 'OutstandingDto(currency: $currency, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $OutstandingDtoCopyWith<$Res>  {
  factory $OutstandingDtoCopyWith(OutstandingDto value, $Res Function(OutstandingDto) _then) = _$OutstandingDtoCopyWithImpl;
@useResult
$Res call({
 String currency, double amount
});




}
/// @nodoc
class _$OutstandingDtoCopyWithImpl<$Res>
    implements $OutstandingDtoCopyWith<$Res> {
  _$OutstandingDtoCopyWithImpl(this._self, this._then);

  final OutstandingDto _self;
  final $Res Function(OutstandingDto) _then;

/// Create a copy of OutstandingDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? amount = null,}) {
  return _then(_self.copyWith(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OutstandingDto].
extension OutstandingDtoPatterns on OutstandingDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutstandingDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutstandingDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutstandingDto value)  $default,){
final _that = this;
switch (_that) {
case _OutstandingDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutstandingDto value)?  $default,){
final _that = this;
switch (_that) {
case _OutstandingDto() when $default != null:
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
case _OutstandingDto() when $default != null:
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
case _OutstandingDto():
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
case _OutstandingDto() when $default != null:
return $default(_that.currency,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OutstandingDto implements OutstandingDto {
  const _OutstandingDto({required this.currency, required this.amount});
  factory _OutstandingDto.fromJson(Map<String, dynamic> json) => _$OutstandingDtoFromJson(json);

@override final  String currency;
@override final  double amount;

/// Create a copy of OutstandingDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutstandingDtoCopyWith<_OutstandingDto> get copyWith => __$OutstandingDtoCopyWithImpl<_OutstandingDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutstandingDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutstandingDto&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currency,amount);

@override
String toString() {
  return 'OutstandingDto(currency: $currency, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$OutstandingDtoCopyWith<$Res> implements $OutstandingDtoCopyWith<$Res> {
  factory _$OutstandingDtoCopyWith(_OutstandingDto value, $Res Function(_OutstandingDto) _then) = __$OutstandingDtoCopyWithImpl;
@override @useResult
$Res call({
 String currency, double amount
});




}
/// @nodoc
class __$OutstandingDtoCopyWithImpl<$Res>
    implements _$OutstandingDtoCopyWith<$Res> {
  __$OutstandingDtoCopyWithImpl(this._self, this._then);

  final _OutstandingDto _self;
  final $Res Function(_OutstandingDto) _then;

/// Create a copy of OutstandingDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? amount = null,}) {
  return _then(_OutstandingDto(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
