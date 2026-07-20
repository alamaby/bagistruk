import '../entities/assignment.dart';
import '../entities/item.dart';
import 'money.dart';

/// Pure domain service. No Flutter, no Supabase, no Riverpod imports — so it
/// stays trivially unit-testable and can be reused on a server (e.g. inside an
/// Edge Function audit) without modification.
class BillCalculator {
  const BillCalculator();

  /// Returns `participantId -> amountOwed`, rounded to [currencyCode]'s
  /// smallest payable unit (whole rupiah for IDR, cents for USD).
  ///
  /// Algorithm — proportional distribution of tax+service:
  ///   1. Split each item's [Item.subtotal] across its [Assignment]s by weight.
  ///   2. Sum into a per-participant subtotal.
  ///   3. Allocate (tax+service) by each participant's share of the grand
  ///      subtotal, NOT equally. Why: if Alice spent \$50 and Bob spent \$10,
  ///      splitting a \$6 service charge 50/50 would make Bob pay 30% service
  ///      on his order while Alice pays 6%. Proportional keeps the percentage
  ///      uniform across diners.
  ///   4. Round to the currency's minor unit and reconcile any residual to the
  ///      largest payer so Σ(owed) == subtotal + tax + service exactly.
  Map<String, double> distributeProportionally({
    required List<Item> items,
    required List<Assignment> assignments,
    required double tax,
    required double service,
    String currencyCode = 'IDR',
  }) {
    if (assignments.isEmpty) return const {};

    final itemsById = {for (final i in items) i.id: i};
    final weightByItem = <String, double>{};
    for (final a in assignments) {
      weightByItem.update(
        a.itemId,
        (w) => w + a.shareWeight,
        ifAbsent: () => a.shareWeight,
      );
    }

    final subtotalByParticipant = <String, double>{};
    for (final a in assignments) {
      final item = itemsById[a.itemId];
      if (item == null) continue;
      final totalWeight = weightByItem[a.itemId]!;
      if (totalWeight == 0) continue;
      final share = item.subtotal * (a.shareWeight / totalWeight);
      subtotalByParticipant.update(
        a.participantId,
        (v) => v + share,
        ifAbsent: () => share,
      );
    }

    final grandSubtotal = subtotalByParticipant.values.fold<double>(
      0,
      (a, b) => a + b,
    );
    if (grandSubtotal == 0) return const {};

    final extras = tax + service;
    final owed = <String, double>{};
    subtotalByParticipant.forEach((pid, sub) {
      final raw = sub + (sub / grandSubtotal) * extras;
      owed[pid] = Money.roundToCurrency(raw, currencyCode);
    });

    _reconcileResidual(
      owed,
      Money.roundToCurrency(grandSubtotal + extras, currencyCode),
      currencyCode,
    );
    return owed;
  }

  /// Push the rounding residual onto the largest payer. Keeps the receipt
  /// math reconciled to the currency's minor unit without distorting smaller
  /// balances.
  static void _reconcileResidual(
    Map<String, double> owed,
    double expected,
    String currencyCode,
  ) {
    final actual = owed.values.fold<double>(0, (a, b) => a + b);
    final residual = Money.roundToCurrency(expected - actual, currencyCode);
    if (residual == 0 || owed.isEmpty) return;
    final topPayer = owed.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
    owed[topPayer] = Money.roundToCurrency(
      owed[topPayer]! + residual,
      currencyCode,
    );
  }
}
