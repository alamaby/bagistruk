import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/saved_participant.dart';

part 'saved_participant_dto.freezed.dart';
part 'saved_participant_dto.g.dart';

/// Wire format for the [SavedParticipant] entity. Maps to/from the
/// `public.list_suggested_participants()` RPC and the
/// SharedPreferences JSON cache.
@freezed
abstract class SavedParticipantDto with _$SavedParticipantDto {
  const SavedParticipantDto._();

  const factory SavedParticipantDto({
    required String name,
    @Default('') String phone,
    @JsonKey(name: 'use_count') @Default(1) int useCount,
    @JsonKey(name: 'last_used_at') required DateTime lastUsedAt,
  }) = _SavedParticipantDto;

  factory SavedParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$SavedParticipantDtoFromJson(json);

  factory SavedParticipantDto.fromEntity(SavedParticipant p) =>
      SavedParticipantDto(
        name: p.name,
        phone: p.phone,
        useCount: p.useCount,
        lastUsedAt: p.lastUsedAt,
      );

  SavedParticipant toEntity() => SavedParticipant(
    name: name,
    phone: phone,
    useCount: useCount,
    lastUsedAt: lastUsedAt,
  );
}
