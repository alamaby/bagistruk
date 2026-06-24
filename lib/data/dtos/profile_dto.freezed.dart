// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileDto {

 String get id;@JsonKey(name: 'display_name') String? get displayName;@JsonKey(name: 'default_currency') String get defaultCurrency;@JsonKey(name: 'language_pref') String get languagePref;@JsonKey(name: 'theme_pref') String get themePref;@JsonKey(name: 'marketing_email_opt_in') bool get marketingEmailOptIn;@JsonKey(name: 'marketing_email_opt_in_at') DateTime? get marketingEmailOptInAt;@JsonKey(name: 'marketing_email_opt_in_source') String? get marketingEmailOptInSource;@JsonKey(name: 'accepted_terms_at') DateTime? get acceptedTermsAt;@JsonKey(name: 'accepted_privacy_at') DateTime? get acceptedPrivacyAt;@JsonKey(name: 'accepted_terms_version') int? get acceptedTermsVersion;@JsonKey(name: 'accepted_privacy_version') int? get acceptedPrivacyVersion;@JsonKey(name: 'welcomed_at') DateTime? get welcomedAt;@JsonKey(name: 'is_adult') bool get isAdult;
/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDtoCopyWith<ProfileDto> get copyWith => _$ProfileDtoCopyWithImpl<ProfileDto>(this as ProfileDto, _$identity);

  /// Serializes this ProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDto&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.languagePref, languagePref) || other.languagePref == languagePref)&&(identical(other.themePref, themePref) || other.themePref == themePref)&&(identical(other.marketingEmailOptIn, marketingEmailOptIn) || other.marketingEmailOptIn == marketingEmailOptIn)&&(identical(other.marketingEmailOptInAt, marketingEmailOptInAt) || other.marketingEmailOptInAt == marketingEmailOptInAt)&&(identical(other.marketingEmailOptInSource, marketingEmailOptInSource) || other.marketingEmailOptInSource == marketingEmailOptInSource)&&(identical(other.acceptedTermsAt, acceptedTermsAt) || other.acceptedTermsAt == acceptedTermsAt)&&(identical(other.acceptedPrivacyAt, acceptedPrivacyAt) || other.acceptedPrivacyAt == acceptedPrivacyAt)&&(identical(other.acceptedTermsVersion, acceptedTermsVersion) || other.acceptedTermsVersion == acceptedTermsVersion)&&(identical(other.acceptedPrivacyVersion, acceptedPrivacyVersion) || other.acceptedPrivacyVersion == acceptedPrivacyVersion)&&(identical(other.welcomedAt, welcomedAt) || other.welcomedAt == welcomedAt)&&(identical(other.isAdult, isAdult) || other.isAdult == isAdult));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,defaultCurrency,languagePref,themePref,marketingEmailOptIn,marketingEmailOptInAt,marketingEmailOptInSource,acceptedTermsAt,acceptedPrivacyAt,acceptedTermsVersion,acceptedPrivacyVersion,welcomedAt,isAdult);

@override
String toString() {
  return 'ProfileDto(id: $id, displayName: $displayName, defaultCurrency: $defaultCurrency, languagePref: $languagePref, themePref: $themePref, marketingEmailOptIn: $marketingEmailOptIn, marketingEmailOptInAt: $marketingEmailOptInAt, marketingEmailOptInSource: $marketingEmailOptInSource, acceptedTermsAt: $acceptedTermsAt, acceptedPrivacyAt: $acceptedPrivacyAt, acceptedTermsVersion: $acceptedTermsVersion, acceptedPrivacyVersion: $acceptedPrivacyVersion, welcomedAt: $welcomedAt, isAdult: $isAdult)';
}


}

/// @nodoc
abstract mixin class $ProfileDtoCopyWith<$Res>  {
  factory $ProfileDtoCopyWith(ProfileDto value, $Res Function(ProfileDto) _then) = _$ProfileDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'default_currency') String defaultCurrency,@JsonKey(name: 'language_pref') String languagePref,@JsonKey(name: 'theme_pref') String themePref,@JsonKey(name: 'marketing_email_opt_in') bool marketingEmailOptIn,@JsonKey(name: 'marketing_email_opt_in_at') DateTime? marketingEmailOptInAt,@JsonKey(name: 'marketing_email_opt_in_source') String? marketingEmailOptInSource,@JsonKey(name: 'accepted_terms_at') DateTime? acceptedTermsAt,@JsonKey(name: 'accepted_privacy_at') DateTime? acceptedPrivacyAt,@JsonKey(name: 'accepted_terms_version') int? acceptedTermsVersion,@JsonKey(name: 'accepted_privacy_version') int? acceptedPrivacyVersion,@JsonKey(name: 'welcomed_at') DateTime? welcomedAt,@JsonKey(name: 'is_adult') bool isAdult
});




}
/// @nodoc
class _$ProfileDtoCopyWithImpl<$Res>
    implements $ProfileDtoCopyWith<$Res> {
  _$ProfileDtoCopyWithImpl(this._self, this._then);

  final ProfileDto _self;
  final $Res Function(ProfileDto) _then;

/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = freezed,Object? defaultCurrency = null,Object? languagePref = null,Object? themePref = null,Object? marketingEmailOptIn = null,Object? marketingEmailOptInAt = freezed,Object? marketingEmailOptInSource = freezed,Object? acceptedTermsAt = freezed,Object? acceptedPrivacyAt = freezed,Object? acceptedTermsVersion = freezed,Object? acceptedPrivacyVersion = freezed,Object? welcomedAt = freezed,Object? isAdult = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,languagePref: null == languagePref ? _self.languagePref : languagePref // ignore: cast_nullable_to_non_nullable
as String,themePref: null == themePref ? _self.themePref : themePref // ignore: cast_nullable_to_non_nullable
as String,marketingEmailOptIn: null == marketingEmailOptIn ? _self.marketingEmailOptIn : marketingEmailOptIn // ignore: cast_nullable_to_non_nullable
as bool,marketingEmailOptInAt: freezed == marketingEmailOptInAt ? _self.marketingEmailOptInAt : marketingEmailOptInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,marketingEmailOptInSource: freezed == marketingEmailOptInSource ? _self.marketingEmailOptInSource : marketingEmailOptInSource // ignore: cast_nullable_to_non_nullable
as String?,acceptedTermsAt: freezed == acceptedTermsAt ? _self.acceptedTermsAt : acceptedTermsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedPrivacyAt: freezed == acceptedPrivacyAt ? _self.acceptedPrivacyAt : acceptedPrivacyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedTermsVersion: freezed == acceptedTermsVersion ? _self.acceptedTermsVersion : acceptedTermsVersion // ignore: cast_nullable_to_non_nullable
as int?,acceptedPrivacyVersion: freezed == acceptedPrivacyVersion ? _self.acceptedPrivacyVersion : acceptedPrivacyVersion // ignore: cast_nullable_to_non_nullable
as int?,welcomedAt: freezed == welcomedAt ? _self.welcomedAt : welcomedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAdult: null == isAdult ? _self.isAdult : isAdult // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileDto].
extension ProfileDtoPatterns on ProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'default_currency')  String defaultCurrency, @JsonKey(name: 'language_pref')  String languagePref, @JsonKey(name: 'theme_pref')  String themePref, @JsonKey(name: 'marketing_email_opt_in')  bool marketingEmailOptIn, @JsonKey(name: 'marketing_email_opt_in_at')  DateTime? marketingEmailOptInAt, @JsonKey(name: 'marketing_email_opt_in_source')  String? marketingEmailOptInSource, @JsonKey(name: 'accepted_terms_at')  DateTime? acceptedTermsAt, @JsonKey(name: 'accepted_privacy_at')  DateTime? acceptedPrivacyAt, @JsonKey(name: 'accepted_terms_version')  int? acceptedTermsVersion, @JsonKey(name: 'accepted_privacy_version')  int? acceptedPrivacyVersion, @JsonKey(name: 'welcomed_at')  DateTime? welcomedAt, @JsonKey(name: 'is_adult')  bool isAdult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
return $default(_that.id,_that.displayName,_that.defaultCurrency,_that.languagePref,_that.themePref,_that.marketingEmailOptIn,_that.marketingEmailOptInAt,_that.marketingEmailOptInSource,_that.acceptedTermsAt,_that.acceptedPrivacyAt,_that.acceptedTermsVersion,_that.acceptedPrivacyVersion,_that.welcomedAt,_that.isAdult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'default_currency')  String defaultCurrency, @JsonKey(name: 'language_pref')  String languagePref, @JsonKey(name: 'theme_pref')  String themePref, @JsonKey(name: 'marketing_email_opt_in')  bool marketingEmailOptIn, @JsonKey(name: 'marketing_email_opt_in_at')  DateTime? marketingEmailOptInAt, @JsonKey(name: 'marketing_email_opt_in_source')  String? marketingEmailOptInSource, @JsonKey(name: 'accepted_terms_at')  DateTime? acceptedTermsAt, @JsonKey(name: 'accepted_privacy_at')  DateTime? acceptedPrivacyAt, @JsonKey(name: 'accepted_terms_version')  int? acceptedTermsVersion, @JsonKey(name: 'accepted_privacy_version')  int? acceptedPrivacyVersion, @JsonKey(name: 'welcomed_at')  DateTime? welcomedAt, @JsonKey(name: 'is_adult')  bool isAdult)  $default,) {final _that = this;
switch (_that) {
case _ProfileDto():
return $default(_that.id,_that.displayName,_that.defaultCurrency,_that.languagePref,_that.themePref,_that.marketingEmailOptIn,_that.marketingEmailOptInAt,_that.marketingEmailOptInSource,_that.acceptedTermsAt,_that.acceptedPrivacyAt,_that.acceptedTermsVersion,_that.acceptedPrivacyVersion,_that.welcomedAt,_that.isAdult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'default_currency')  String defaultCurrency, @JsonKey(name: 'language_pref')  String languagePref, @JsonKey(name: 'theme_pref')  String themePref, @JsonKey(name: 'marketing_email_opt_in')  bool marketingEmailOptIn, @JsonKey(name: 'marketing_email_opt_in_at')  DateTime? marketingEmailOptInAt, @JsonKey(name: 'marketing_email_opt_in_source')  String? marketingEmailOptInSource, @JsonKey(name: 'accepted_terms_at')  DateTime? acceptedTermsAt, @JsonKey(name: 'accepted_privacy_at')  DateTime? acceptedPrivacyAt, @JsonKey(name: 'accepted_terms_version')  int? acceptedTermsVersion, @JsonKey(name: 'accepted_privacy_version')  int? acceptedPrivacyVersion, @JsonKey(name: 'welcomed_at')  DateTime? welcomedAt, @JsonKey(name: 'is_adult')  bool isAdult)?  $default,) {final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
return $default(_that.id,_that.displayName,_that.defaultCurrency,_that.languagePref,_that.themePref,_that.marketingEmailOptIn,_that.marketingEmailOptInAt,_that.marketingEmailOptInSource,_that.acceptedTermsAt,_that.acceptedPrivacyAt,_that.acceptedTermsVersion,_that.acceptedPrivacyVersion,_that.welcomedAt,_that.isAdult);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileDto extends ProfileDto {
  const _ProfileDto({required this.id, @JsonKey(name: 'display_name') this.displayName, @JsonKey(name: 'default_currency') this.defaultCurrency = 'USD', @JsonKey(name: 'language_pref') this.languagePref = 'en', @JsonKey(name: 'theme_pref') this.themePref = 'system', @JsonKey(name: 'marketing_email_opt_in') this.marketingEmailOptIn = false, @JsonKey(name: 'marketing_email_opt_in_at') this.marketingEmailOptInAt, @JsonKey(name: 'marketing_email_opt_in_source') this.marketingEmailOptInSource, @JsonKey(name: 'accepted_terms_at') this.acceptedTermsAt, @JsonKey(name: 'accepted_privacy_at') this.acceptedPrivacyAt, @JsonKey(name: 'accepted_terms_version') this.acceptedTermsVersion, @JsonKey(name: 'accepted_privacy_version') this.acceptedPrivacyVersion, @JsonKey(name: 'welcomed_at') this.welcomedAt, @JsonKey(name: 'is_adult') this.isAdult = false}): super._();
  factory _ProfileDto.fromJson(Map<String, dynamic> json) => _$ProfileDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'display_name') final  String? displayName;
@override@JsonKey(name: 'default_currency') final  String defaultCurrency;
@override@JsonKey(name: 'language_pref') final  String languagePref;
@override@JsonKey(name: 'theme_pref') final  String themePref;
@override@JsonKey(name: 'marketing_email_opt_in') final  bool marketingEmailOptIn;
@override@JsonKey(name: 'marketing_email_opt_in_at') final  DateTime? marketingEmailOptInAt;
@override@JsonKey(name: 'marketing_email_opt_in_source') final  String? marketingEmailOptInSource;
@override@JsonKey(name: 'accepted_terms_at') final  DateTime? acceptedTermsAt;
@override@JsonKey(name: 'accepted_privacy_at') final  DateTime? acceptedPrivacyAt;
@override@JsonKey(name: 'accepted_terms_version') final  int? acceptedTermsVersion;
@override@JsonKey(name: 'accepted_privacy_version') final  int? acceptedPrivacyVersion;
@override@JsonKey(name: 'welcomed_at') final  DateTime? welcomedAt;
@override@JsonKey(name: 'is_adult') final  bool isAdult;

/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDtoCopyWith<_ProfileDto> get copyWith => __$ProfileDtoCopyWithImpl<_ProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileDto&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.languagePref, languagePref) || other.languagePref == languagePref)&&(identical(other.themePref, themePref) || other.themePref == themePref)&&(identical(other.marketingEmailOptIn, marketingEmailOptIn) || other.marketingEmailOptIn == marketingEmailOptIn)&&(identical(other.marketingEmailOptInAt, marketingEmailOptInAt) || other.marketingEmailOptInAt == marketingEmailOptInAt)&&(identical(other.marketingEmailOptInSource, marketingEmailOptInSource) || other.marketingEmailOptInSource == marketingEmailOptInSource)&&(identical(other.acceptedTermsAt, acceptedTermsAt) || other.acceptedTermsAt == acceptedTermsAt)&&(identical(other.acceptedPrivacyAt, acceptedPrivacyAt) || other.acceptedPrivacyAt == acceptedPrivacyAt)&&(identical(other.acceptedTermsVersion, acceptedTermsVersion) || other.acceptedTermsVersion == acceptedTermsVersion)&&(identical(other.acceptedPrivacyVersion, acceptedPrivacyVersion) || other.acceptedPrivacyVersion == acceptedPrivacyVersion)&&(identical(other.welcomedAt, welcomedAt) || other.welcomedAt == welcomedAt)&&(identical(other.isAdult, isAdult) || other.isAdult == isAdult));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,defaultCurrency,languagePref,themePref,marketingEmailOptIn,marketingEmailOptInAt,marketingEmailOptInSource,acceptedTermsAt,acceptedPrivacyAt,acceptedTermsVersion,acceptedPrivacyVersion,welcomedAt,isAdult);

@override
String toString() {
  return 'ProfileDto(id: $id, displayName: $displayName, defaultCurrency: $defaultCurrency, languagePref: $languagePref, themePref: $themePref, marketingEmailOptIn: $marketingEmailOptIn, marketingEmailOptInAt: $marketingEmailOptInAt, marketingEmailOptInSource: $marketingEmailOptInSource, acceptedTermsAt: $acceptedTermsAt, acceptedPrivacyAt: $acceptedPrivacyAt, acceptedTermsVersion: $acceptedTermsVersion, acceptedPrivacyVersion: $acceptedPrivacyVersion, welcomedAt: $welcomedAt, isAdult: $isAdult)';
}


}

/// @nodoc
abstract mixin class _$ProfileDtoCopyWith<$Res> implements $ProfileDtoCopyWith<$Res> {
  factory _$ProfileDtoCopyWith(_ProfileDto value, $Res Function(_ProfileDto) _then) = __$ProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'default_currency') String defaultCurrency,@JsonKey(name: 'language_pref') String languagePref,@JsonKey(name: 'theme_pref') String themePref,@JsonKey(name: 'marketing_email_opt_in') bool marketingEmailOptIn,@JsonKey(name: 'marketing_email_opt_in_at') DateTime? marketingEmailOptInAt,@JsonKey(name: 'marketing_email_opt_in_source') String? marketingEmailOptInSource,@JsonKey(name: 'accepted_terms_at') DateTime? acceptedTermsAt,@JsonKey(name: 'accepted_privacy_at') DateTime? acceptedPrivacyAt,@JsonKey(name: 'accepted_terms_version') int? acceptedTermsVersion,@JsonKey(name: 'accepted_privacy_version') int? acceptedPrivacyVersion,@JsonKey(name: 'welcomed_at') DateTime? welcomedAt,@JsonKey(name: 'is_adult') bool isAdult
});




}
/// @nodoc
class __$ProfileDtoCopyWithImpl<$Res>
    implements _$ProfileDtoCopyWith<$Res> {
  __$ProfileDtoCopyWithImpl(this._self, this._then);

  final _ProfileDto _self;
  final $Res Function(_ProfileDto) _then;

/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = freezed,Object? defaultCurrency = null,Object? languagePref = null,Object? themePref = null,Object? marketingEmailOptIn = null,Object? marketingEmailOptInAt = freezed,Object? marketingEmailOptInSource = freezed,Object? acceptedTermsAt = freezed,Object? acceptedPrivacyAt = freezed,Object? acceptedTermsVersion = freezed,Object? acceptedPrivacyVersion = freezed,Object? welcomedAt = freezed,Object? isAdult = null,}) {
  return _then(_ProfileDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,languagePref: null == languagePref ? _self.languagePref : languagePref // ignore: cast_nullable_to_non_nullable
as String,themePref: null == themePref ? _self.themePref : themePref // ignore: cast_nullable_to_non_nullable
as String,marketingEmailOptIn: null == marketingEmailOptIn ? _self.marketingEmailOptIn : marketingEmailOptIn // ignore: cast_nullable_to_non_nullable
as bool,marketingEmailOptInAt: freezed == marketingEmailOptInAt ? _self.marketingEmailOptInAt : marketingEmailOptInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,marketingEmailOptInSource: freezed == marketingEmailOptInSource ? _self.marketingEmailOptInSource : marketingEmailOptInSource // ignore: cast_nullable_to_non_nullable
as String?,acceptedTermsAt: freezed == acceptedTermsAt ? _self.acceptedTermsAt : acceptedTermsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedPrivacyAt: freezed == acceptedPrivacyAt ? _self.acceptedPrivacyAt : acceptedPrivacyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedTermsVersion: freezed == acceptedTermsVersion ? _self.acceptedTermsVersion : acceptedTermsVersion // ignore: cast_nullable_to_non_nullable
as int?,acceptedPrivacyVersion: freezed == acceptedPrivacyVersion ? _self.acceptedPrivacyVersion : acceptedPrivacyVersion // ignore: cast_nullable_to_non_nullable
as int?,welcomedAt: freezed == welcomedAt ? _self.welcomedAt : welcomedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAdult: null == isAdult ? _self.isAdult : isAdult // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
