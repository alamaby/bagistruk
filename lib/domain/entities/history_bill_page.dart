import 'package:freezed_annotation/freezed_annotation.dart';

import 'history_bill.dart';
import 'history_cursor.dart';

part 'history_bill_page.freezed.dart';

@freezed
abstract class HistoryBillPage with _$HistoryBillPage {
  const factory HistoryBillPage({
    required List<HistoryBill> bills,
    required bool hasMore,
    HistoryCursor? nextCursor,
  }) = _HistoryBillPage;
}
