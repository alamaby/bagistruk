import '../../../domain/entities/bill.dart';
import '../providers/history_filter_notifier.dart';

/// Pure functions for filtering and sorting bill lists on the client.
///
/// Designed to be unit-testable with no Flutter dependency.

/// Returns the filtered and sorted list. Input list is NOT mutated.
List<Bill> applyHistoryFilter(
  List<Bill> bills,
  HistoryFilterState filter,
) {
  var result = bills;

  if (filter.paymentStatus != null) {
    result = result.where((b) => b.paymentStatus == filter.paymentStatus).toList(growable: false);
  }

  if (filter.currencyCode != null) {
    result = result.where((b) => b.currencyCode == filter.currencyCode).toList(growable: false);
  }

  result = result.toList(growable: false)..sort((a, b) => _compare(a, b, filter.sort));
  return result;
}

/// Whether nominal (amount) sort options are meaningful given the current
/// filter state and bill data. Nominal sort only makes sense when the result
/// set has at most one currency, or a currency filter is active.
bool nominalSortAvailable(
  List<Bill> bills,
  HistoryFilterState filter,
) {
  if (filter.currencyCode != null) return true;
  final currencies = bills.map((b) => b.currencyCode).toSet();
  return currencies.length <= 1;
}

int _compare(Bill a, Bill b, HistorySort sort) {
  final cmp = switch (sort) {
    HistorySort.newest => b.createdAt.compareTo(a.createdAt),
    HistorySort.oldest => a.createdAt.compareTo(b.createdAt),
    HistorySort.titleAsc => _compareTitle(a.title, b.title),
    HistorySort.amountDesc => a.totalAmount.compareTo(b.totalAmount).sign * -1,
    HistorySort.amountAsc => a.totalAmount.compareTo(b.totalAmount).sign,
  };
  if (cmp != 0) return cmp;
  return b.createdAt.compareTo(a.createdAt);
}

int _compareTitle(String a, String b) {
  return a.toLowerCase().compareTo(b.toLowerCase());
}
