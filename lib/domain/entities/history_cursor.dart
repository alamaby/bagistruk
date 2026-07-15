import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_cursor.freezed.dart';

@freezed
abstract class HistoryCursor with _$HistoryCursor {
  const factory HistoryCursor({
    required String sortValue,
    required DateTime createdAt,
    required String id,
  }) = _HistoryCursor;
}
