import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_participant.freezed.dart';

/// Cross-bill participant library entry. One row per (user, lower(name), phone)
/// tuple on the server; mirrored to a local SharedPreferences cache for
/// offline-first suggestions.
@freezed
abstract class SavedParticipant with _$SavedParticipant {
  const factory SavedParticipant({
    required String name,

    /// Normalised phone (digits-only, country code prefixed when possible).
    /// Empty string when participant has no phone.
    @Default('') String phone,
    @Default(1) int useCount,
    required DateTime lastUsedAt,
  }) = _SavedParticipant;
}
