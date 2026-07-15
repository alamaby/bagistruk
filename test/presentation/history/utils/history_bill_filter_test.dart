import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/domain/entities/bill.dart';
import '../../../../lib/domain/entities/bill_payment_status.dart';
import '../../../../lib/presentation/history/utils/history_bill_filter.dart';
import '../../../../lib/presentation/history/providers/history_filter_state.dart';

void main() {
  final now = DateTime(2026, 7, 15);

  Bill _bill({
    required String id,
    required String title,
    double amount = 10000,
    String currency = 'IDR',
    List<bool> statuses = const [],
    DateTime? createdAt,
  }) =>
      Bill(
        id: id,
        title: title,
        totalAmount: amount,
        currencyCode: currency,
        participantPaymentStatuses: statuses,
        createdAt: createdAt ?? now,
      );

  group('applyHistoryFilter', () {
    test('returns same list when no filters active', () {
      final bills = [
        _bill(id: '1', title: 'A'),
        _bill(id: '2', title: 'B'),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(),
      );
      expect(result.length, 2);
    });

    test('does not mutate input list', () {
      final bills = [
        _bill(id: '1', title: 'B'),
        _bill(id: '2', title: 'A'),
      ];
      final original = bills.toList();
      applyHistoryFilter(bills, const HistoryFilterState(sort: HistorySort.titleAsc));
      expect(bills.first.id, original.first.id);
    });

    test('filters by payment status', () {
      final bills = [
        _bill(id: '1', title: 'Unpaid', statuses: [false]),
        _bill(id: '2', title: 'Settled', statuses: [true]),
        _bill(id: '3', title: 'Partial', statuses: [true, false]),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(
          paymentStatus: BillPaymentStatus.settled,
        ),
      );
      expect(result.length, 1);
      expect(result.first.id, '2');
    });

    test('filters by currency', () {
      final bills = [
        _bill(id: '1', title: 'IDR', currency: 'IDR'),
        _bill(id: '2', title: 'USD', currency: 'USD'),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(currencyCode: 'USD'),
      );
      expect(result.length, 1);
      expect(result.first.id, '2');
    });

    test('filters by both status and currency', () {
      final bills = [
        _bill(id: '1', title: 'A', currency: 'IDR', statuses: [false]),
        _bill(id: '2', title: 'B', currency: 'USD', statuses: [false]),
        _bill(id: '3', title: 'C', currency: 'IDR', statuses: [true]),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(
          paymentStatus: BillPaymentStatus.unpaid,
          currencyCode: 'IDR',
        ),
      );
      expect(result.length, 1);
      expect(result.first.id, '1');
    });

    test('sorts newest first', () {
      final bills = [
        _bill(id: '1', title: 'Old', createdAt: now.subtract(const Duration(days: 2))),
        _bill(id: '2', title: 'New', createdAt: now),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(sort: HistorySort.newest),
      );
      expect(result.first.id, '2');
    });

    test('sorts oldest first', () {
      final bills = [
        _bill(id: '1', title: 'Old', createdAt: now.subtract(const Duration(days: 2))),
        _bill(id: '2', title: 'New', createdAt: now),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(sort: HistorySort.oldest),
      );
      expect(result.first.id, '1');
    });

    test('sorts by title ascending', () {
      final bills = [
        _bill(id: '1', title: 'Zebra'),
        _bill(id: '2', title: 'Apple'),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(sort: HistorySort.titleAsc),
      );
      expect(result.first.id, '2');
    });

    test('sorts by amount descending', () {
      final bills = [
        _bill(id: '1', title: 'Small', amount: 1000),
        _bill(id: '2', title: 'Big', amount: 99999),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(sort: HistorySort.amountDesc),
      );
      expect(result.first.id, '2');
    });

    test('sorts by amount ascending', () {
      final bills = [
        _bill(id: '1', title: 'Small', amount: 1000),
        _bill(id: '2', title: 'Big', amount: 99999),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(sort: HistorySort.amountAsc),
      );
      expect(result.first.id, '1');
    });

    test('tie-breaker uses createdAt desc', () {
      final bills = [
        _bill(id: '1', title: 'Same', createdAt: now.subtract(const Duration(days: 1))),
        _bill(id: '2', title: 'Same', createdAt: now),
      ];
      final result = applyHistoryFilter(
        bills,
        const HistoryFilterState(sort: HistorySort.titleAsc),
      );
      expect(result.first.id, '2');
    });
  });

  group('nominalSortAvailable', () {
    test('returns true when currency filter active', () {
      final bills = [
        _bill(id: '1', title: 'A', currency: 'IDR'),
        _bill(id: '2', title: 'B', currency: 'USD'),
      ];
      final result = nominalSortAvailable(
        bills,
        const HistoryFilterState(currencyCode: 'IDR'),
      );
      expect(result, true);
    });

    test('returns true when all bills have same currency', () {
      final bills = [
        _bill(id: '1', title: 'A', currency: 'IDR'),
        _bill(id: '2', title: 'B', currency: 'IDR'),
      ];
      final result = nominalSortAvailable(
        bills,
        const HistoryFilterState(),
      );
      expect(result, true);
    });

    test('returns false when multiple currencies and no filter', () {
      final bills = [
        _bill(id: '1', title: 'A', currency: 'IDR'),
        _bill(id: '2', title: 'B', currency: 'USD'),
      ];
      final result = nominalSortAvailable(
        bills,
        const HistoryFilterState(),
      );
      expect(result, false);
    });

    test('returns true for empty list', () {
      final result = nominalSortAvailable(
        [],
        const HistoryFilterState(),
      );
      expect(result, true);
    });
  });
}
