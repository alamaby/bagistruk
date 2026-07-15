import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/history_bill_page.dart';
import 'history_bill_dto.dart';
import 'history_cursor_dto.dart';

part 'history_bill_page_dto.freezed.dart';
part 'history_bill_page_dto.g.dart';

@freezed
abstract class HistoryBillPageDto with _$HistoryBillPageDto {
  const factory HistoryBillPageDto({
    required List<HistoryBillDto> bills,
    HistoryCursorDto? cursor,
    @JsonKey(name: 'has_more') required bool hasMore,
  }) = _HistoryBillPageDto;

  factory HistoryBillPageDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryBillPageDtoFromJson(json);
}

extension HistoryBillPageDtoX on HistoryBillPageDto {
  HistoryBillPage toEntity() {
    final entities = bills.map((b) => b.toEntity()).toList(growable: false);
    return HistoryBillPage(
      bills: entities,
      hasMore: hasMore,
      nextCursor: cursor?.toEntity(),
    );
  }
}
