// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfile {

 String get id; String? get displayName; String? get email; String get defaultCurrency; String get languagePref; String get themePref; bool get isAnonymous;// Marketing email opt-in (GDPR / CAN-SPAM). Defaults to FALSE; user must
// explicitly opt in via the register form, the post-login welcome, or
// the Settings toggle.
 bool get marketingEmailOptIn; DateTime? get marketingEmailOptInAt; String? get marketingEmailOptInSource;// Legal acceptance. Version fields let the router force re-acceptance
// when the corresponding document changes in `app_config`.
 DateTime? get acceptedTermsAt; DateTime? get acceptedPrivacyAt; int? get acceptedTermsVersion; int? get acceptedPrivacyVersion;// Post-login welcome gate. Set once when a non-anonymous user finishes
// the post-login welcome (Google sign-in flow). Email/password sign-up
// sets it directly after `signUp` so the welcome screen is skipped.
 DateTime? get welcomedAt;// User-declared age 18+ (or older if required by local law). Drives the
// AdMob `setTagForUnderAgeOfConsent` call so users below the age of
// consent only see non-personalized ads. Default FALSE so the app
// behaves conservatively until the user explicitly declares adult age
// during the legal acceptance flow.
 bool get isAdult;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.languagePref, languagePref) || other.languagePref == languagePref)&&(identical(other.themePref, themePref) || other.themePref == themePref)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.marketingEmailOptIn, marketingEmailOptIn) || other.marketingEmailOptIn == marketingEmailOptIn)&&(identical(other.marketingEmailOptInAt, marketingEmailOptInAt) || other.marketingEmailOptInAt == marketingEmailOptInAt)&&(identical(other.marketingEmailOptInSource, marketingEmailOptInSource) || other.marketingEmailOptInSource == marketingEmailOptInSource)&&(identical(other.acceptedTermsAt, acceptedTermsAt) || other.acceptedTermsAt == acceptedTermsAt)&&(identical(other.acceptedPrivacyAt, acceptedPrivacyAt) || other.acceptedPrivacyAt == acceptedPrivacyAt)&&(identical(other.acceptedTermsVersion, acceptedTermsVersion) || other.acceptedTermsVersion == acceptedTermsVersion)&&(identical(other.acceptedPrivacyVersion, acceptedPrivacyVersion) || other.acceptedPrivacyVersion == acceptedPrivacyVersion)&&(identical(other.welcomedAt, welcomedAt) || other.welcomedAt == welcomedAt)&&(identical(other.isAdult, isAdult) || other.isAdult == isAdult));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,email,defaultCurrency,languagePref,themePref,isAnonymous,marketingEmailOptIn,marketingEmailOptInAt,marketingEmailOptInSource,acceptedTermsAt,acceptedPrivacyAt,acceptedTermsVersion,acceptedPrivacyVersion,welcomedAt,isAdult);

@override
String toString() {
  return 'UserProfile(id: $id, displayName: $displayName, email: $email, defaultCurrency: $defaultCurrency, languagePref: $languagePref, themePref: $themePref, isAnonymous: $isAnonymous, marketingEmailOptIn: $marketingEmailOptIn, marketingEmailOptInAt: $marketingEmailOptInAt, marketingEmailOptInSource: $marketingEmailOptInSource, acceptedTermsAt: $acceptedTermsAt, acceptedPrivacyAt: $acceptedPrivacyAt, acceptedTermsVersion: $acceptedTermsVersion, acceptedPrivacyVersion: $acceptedPrivacyVersion, welcomedAt: $welcomedAt, isAdult: $isAdult)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String? displayName, String? email, String defaultCurrency, String languagePref, String themePref, bool isAnonymous, bool marketingEmailOptIn, DateTime? marketingEmailOptInAt, String? marketingEmailOptInSource, DateTime? acceptedTermsAt, DateTime? acceptedPrivacyAt, int? acceptedTermsVersion, int? acceptedPrivacyVersion, DateTime? welcomedAt, bool isAdult
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = freezed,Object? email = freezed,Object? defaultCurrency = null,Object? languagePref = null,Object? themePref = null,Object? isAnonymous = null,Object? marketingEmailOptIn = null,Object? marketingEmailOptInAt = freezed,Object? marketingEmailOptInSource = freezed,Object? acceptedTermsAt = freezed,Object? acceptedPrivacyAt = freezed,Object? acceptedTermsVersion = freezed,Object? acceptedPrivacyVersion = freezed,Object? welcomedAt = freezed,Object? isAdult = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,languagePref: null == languagePref ? _self.languagePref : languagePref // ignore: cast_nullable_to_non_nullable
as String,themePref: null == themePref ? _self.themePref : themePref // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,marketingEmailOptIn: null == marketingEmailOptIn ? _self.marketingEmailOptIn : marketingEmailOptIn // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? displayName,  String? email,  String defaultCurrency,  String languagePref,  String themePref,  bool isAnonymous,  bool marketingEmailOptIn,  DateTime? marketingEmailOptInAt,  String? marketingEmailOptInSource,  DateTime? acceptedTermsAt,  DateTime? acceptedPrivacyAt,  int? acceptedTermsVersion,  int? acceptedPrivacyVersion,  DateTime? welcomedAt,  bool isAdult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.email,_that.defaultCurrency,_that.languagePref,_that.themePref,_that.isAnonymous,_that.marketingEmailOptIn,_that.marketingEmailOptInAt,_that.marketingEmailOptInSource,_that.acceptedTermsAt,_that.acceptedPrivacyAt,_that.acceptedTermsVersion,_that.acceptedPrivacyVersion,_that.welcomedAt,_that.isAdult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? displayName,  String? email,  String defaultCurrency,  String languagePref,  String themePref,  bool isAnonymous,  bool marketingEmailOptIn,  DateTime? marketingEmailOptInAt,  String? marketingEmailOptInSource,  DateTime? acceptedTermsAt,  DateTime? acceptedPrivacyAt,  int? acceptedTermsVersion,  int? acceptedPrivacyVersion,  DateTime? welcomedAt,  bool isAdult)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.displayName,_that.email,_that.defaultCurrency,_that.languagePref,_that.themePref,_that.isAnonymous,_that.marketingEmailOptIn,_that.marketingEmailOptInAt,_that.marketingEmailOptInSource,_that.acceptedTermsAt,_that.acceptedPrivacyAt,_that.acceptedTermsVersion,_that.acceptedPrivacyVersion,_that.welcomedAt,_that.isAdult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? displayName,  String? email,  String defaultCurrency,  String languagePref,  String themePref,  bool isAnonymous,  bool marketingEmailOptIn,  DateTime? marketingEmailOptInAt,  String? marketingEmailOptInSource,  DateTime? acceptedTermsAt,  DateTime? acceptedPrivacyAt,  int? acceptedTermsVersion,  int? acceptedPrivacyVersion,  DateTime? welcomedAt,  bool isAdult)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.email,_that.defaultCurrency,_that.languagePref,_that.themePref,_that.isAnonymous,_that.marketingEmailOptIn,_that.marketingEmailOptInAt,_that.marketingEmailOptInSource,_that.acceptedTermsAt,_that.acceptedPrivacyAt,_that.acceptedTermsVersion,_that.acceptedPrivacyVersion,_that.welcomedAt,_that.isAdult);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, this.displayName, this.email, this.defaultCurrency = 'USD', this.languagePref = 'en', this.themePref = 'system', this.isAnonymous = false, this.marketingEmailOptIn = false, this.marketingEmailOptInAt, this.marketingEmailOptInSource, this.acceptedTermsAt, this.acceptedPrivacyAt, this.acceptedTermsVersion, this.acceptedPrivacyVersion, this.welcomedAt, this.isAdult = false});
  

@override final  String id;
@override final  String? displayName;
@override final  String? email;
@override@JsonKey() final  String defaultCurrency;
@override@JsonKey() final  String languagePref;
@override@JsonKey() final  String themePref;
@override@JsonKey() final  bool isAnonymous;
// Marketing email opt-in (GDPR / CAN-SPAM). Defaults to FALSE; user must
// explicitly opt in via the register form, the post-login welcome, or
// the Settings toggle.
@override@JsonKey() final  bool marketingEmailOptIn;
@override final  DateTime? marketingEmailOptInAt;
@override final  String? marketingEmailOptInSource;
// Legal acceptance. Version fields let the router force re-acceptance
// when the corresponding document changes in `app_config`.
@override final  DateTime? acceptedTermsAt;
@override final  DateTime? acceptedPrivacyAt;
@override final  int? acceptedTermsVersion;
@override final  int? acceptedPrivacyVersion;
// Post-login welcome gate. Set once when a non-anonymous user finishes
// the post-login welcome (Google sign-in flow). Email/password sign-up
// sets it directly after `signUp` so the welcome screen is skipped.
@override final  DateTime? welcomedAt;
// User-declared age 18+ (or older if required by local law). Drives the
// AdMob `setTagForUnderAgeOfConsent` call so users below the age of
// consent only see non-personalized ads. Default FALSE so the app
// behaves conservatively until the user explicitly declares adult age
// during the legal acceptance flow.
@override@JsonKey() final  bool isAdult;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.languagePref, languagePref) || other.languagePref == languagePref)&&(identical(other.themePref, themePref) || other.themePref == themePref)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.marketingEmailOptIn, marketingEmailOptIn) || other.marketingEmailOptIn == marketingEmailOptIn)&&(identical(other.marketingEmailOptInAt, marketingEmailOptInAt) || other.marketingEmailOptInAt == marketingEmailOptInAt)&&(identical(other.marketingEmailOptInSource, marketingEmailOptInSource) || other.marketingEmailOptInSource == marketingEmailOptInSource)&&(identical(other.acceptedTermsAt, acceptedTermsAt) || other.acceptedTermsAt == acceptedTermsAt)&&(identical(other.acceptedPrivacyAt, acceptedPrivacyAt) || other.acceptedPrivacyAt == acceptedPrivacyAt)&&(identical(other.acceptedTermsVersion, acceptedTermsVersion) || other.acceptedTermsVersion == acceptedTermsVersion)&&(identical(other.acceptedPrivacyVersion, acceptedPrivacyVersion) || other.acceptedPrivacyVersion == acceptedPrivacyVersion)&&(identical(other.welcomedAt, welcomedAt) || other.welcomedAt == welcomedAt)&&(identical(other.isAdult, isAdult) || other.isAdult == isAdult));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,email,defaultCurrency,languagePref,themePref,isAnonymous,marketingEmailOptIn,marketingEmailOptInAt,marketingEmailOptInSource,acceptedTermsAt,acceptedPrivacyAt,acceptedTermsVersion,acceptedPrivacyVersion,welcomedAt,isAdult);

@override
String toString() {
  return 'UserProfile(id: $id, displayName: $displayName, email: $email, defaultCurrency: $defaultCurrency, languagePref: $languagePref, themePref: $themePref, isAnonymous: $isAnonymous, marketingEmailOptIn: $marketingEmailOptIn, marketingEmailOptInAt: $marketingEmailOptInAt, marketingEmailOptInSource: $marketingEmailOptInSource, acceptedTermsAt: $acceptedTermsAt, acceptedPrivacyAt: $acceptedPrivacyAt, acceptedTermsVersion: $acceptedTermsVersion, acceptedPrivacyVersion: $acceptedPrivacyVersion, welcomedAt: $welcomedAt, isAdult: $isAdult)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String? displayName, String? email, String defaultCurrency, String languagePref, String themePref, bool isAnonymous, bool marketingEmailOptIn, DateTime? marketingEmailOptInAt, String? marketingEmailOptInSource, DateTime? acceptedTermsAt, DateTime? acceptedPrivacyAt, int? acceptedTermsVersion, int? acceptedPrivacyVersion, DateTime? welcomedAt, bool isAdult
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = freezed,Object? email = freezed,Object? defaultCurrency = null,Object? languagePref = null,Object? themePref = null,Object? isAnonymous = null,Object? marketingEmailOptIn = null,Object? marketingEmailOptInAt = freezed,Object? marketingEmailOptInSource = freezed,Object? acceptedTermsAt = freezed,Object? acceptedPrivacyAt = freezed,Object? acceptedTermsVersion = freezed,Object? acceptedPrivacyVersion = freezed,Object? welcomedAt = freezed,Object? isAdult = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,languagePref: null == languagePref ? _self.languagePref : languagePref // ignore: cast_nullable_to_non_nullable
as String,themePref: null == themePref ? _self.themePref : themePref // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,marketingEmailOptIn: null == marketingEmailOptIn ? _self.marketingEmailOptIn : marketingEmailOptIn // ignore: cast_nullable_to_non_nullable
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
