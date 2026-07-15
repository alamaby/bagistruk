import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/history_cursor.dart';

part 'history_cursor_dto.freezed.dart';
part 'history_cursor_dto.g.dart';

@freezed
abstract class HistoryCursorDto with _$HistoryCursorDto {
  const factory HistoryCursorDto({
    @JsonKey(name: 'sort_value') required String sortValue,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required String id,
  }) = _HistoryCursorDto;

  factory HistoryCursorDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryCursorDtoFromJson(json);
}

extension HistoryCursorDtoX on HistoryCursorDto {
  HistoryCursor toEntity() => HistoryCursor(
    sortValue: sortValue,
    createdAt: createdAt,
    id: id,
  );
}
