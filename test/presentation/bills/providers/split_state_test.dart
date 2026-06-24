import 'package:bagistruk/domain/entities/assignment.dart';
import 'package:bagistruk/domain/entities/bill.dart';
import 'package:bagistruk/domain/entities/item.dart';
import 'package:bagistruk/domain/entities/participant.dart';
import 'package:bagistruk/presentation/bills/providers/split_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SplitState.itemsSubtotal', () {
    test('empty items returns 0', () {
      final state = SplitState(
        bill: _bill(),
        items: [],
        participants: [],
        assignments: [],
      );
      expect(state.itemsSubtotal, 0);
    });

    test('sums price * qty for all items', () {
      final state = SplitState(
        bill: _bill(),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 10, qty: 2),
          const Item(id: 'i2', billId: 'b', name: 'B', price: 5, qty: 3),
        ],
        participants: [],
        assignments: [],
      );
      expect(state.itemsSubtotal, 35);
    });
  });

  group('SplitState.unassignedSubtotal', () {
    test('all items assigned returns 0', () {
      final state = SplitState(
        bill: _bill(),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 10, qty: 1),
        ],
        participants: [_participant('p1')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
        ],
      );
      expect(state.unassignedSubtotal, 0);
    });

    test('unassigned item counted in subtotal', () {
      final state = SplitState(
        bill: _bill(),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 10, qty: 1),
          const Item(id: 'i2', billId: 'b', name: 'B', price: 20, qty: 1),
        ],
        participants: [_participant('p1')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
        ],
      );
      expect(state.unassignedSubtotal, 20);
    });
  });

  group('SplitState.itemsForParticipant', () {
    test('empty list when participant has no assignments', () {
      final state = SplitState(
        bill: _bill(),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 10, qty: 1),
        ],
        participants: [_participant('p1'), _participant('p2')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
        ],
      );
      expect(state.itemsForParticipant('p2'), isEmpty);
    });

    test('single assignee gets full subtotal', () {
      final state = SplitState(
        bill: _bill(),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 100, qty: 2),
        ],
        participants: [_participant('p1')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
        ],
      );
      final shares = state.itemsForParticipant('p1');
      expect(shares.length, 1);
      expect(shares.single.share, 200);
      expect(shares.single.sharedWith, 1);
    });

    test('shared item splits evenly', () {
      final state = SplitState(
        bill: _bill(),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 90, qty: 1),
        ],
        participants: [_participant('p1'), _participant('p2')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
          const Assignment(id: 'a2', itemId: 'i1', participantId: 'p2'),
        ],
      );
      expect(state.itemsForParticipant('p1').single.share, 45);
      expect(state.itemsForParticipant('p2').single.share, 45);
    });

    test('sharedWith tracks number of assignees', () {
      final state = SplitState(
        bill: _bill(),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 60, qty: 1),
        ],
        participants: [
          _participant('p1'),
          _participant('p2'),
          _participant('p3'),
        ],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
          const Assignment(id: 'a2', itemId: 'i1', participantId: 'p2'),
          const Assignment(id: 'a3', itemId: 'i1', participantId: 'p3'),
        ],
      );
      expect(state.itemsForParticipant('p1').single.sharedWith, 3);
    });
  });

  group('SplitState.calculateTotals', () {
    test('no participants returns empty list', () {
      final state = SplitState(
        bill: _bill(),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 10, qty: 1),
        ],
        participants: [],
        assignments: [],
      );
      expect(state.calculateTotals(), isEmpty);
    });

    test('no assignments — all participants show 0 total', () {
      final state = SplitState(
        bill: _bill(totalAmount: 100, tax: 10, service: 5),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 100, qty: 1),
        ],
        participants: [_participant('p1'), _participant('p2')],
        assignments: [],
      );
      final totals = state.calculateTotals();
      for (final t in totals) {
        expect(t.subtotal, 0);
        expect(t.total, 0);
      }
    });

    test('single participant with full bill', () {
      final state = SplitState(
        bill: _bill(totalAmount: 115, tax: 10, service: 5),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 100, qty: 1),
        ],
        participants: [_participant('p1')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
        ],
      );
      final totals = state.calculateTotals();
      expect(totals.length, 1);
      expect(totals.single.subtotal, 100);
      expect(totals.single.tax, 10);
      expect(totals.single.service, 5);
      expect(totals.single.total, 115);
    });

    test('shared item even split', () {
      final state = SplitState(
        bill: _bill(totalAmount: 100, tax: 0, service: 0),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 100, qty: 1),
        ],
        participants: [_participant('p1'), _participant('p2')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
          const Assignment(id: 'a2', itemId: 'i1', participantId: 'p2'),
        ],
      );
      final totals = state.calculateTotals();
      expect(totals.length, 2);
      expect(totals[0].subtotal, 50);
      expect(totals[1].subtotal, 50);
    });

    test('tax and service distributed proportionally', () {
      final state = SplitState(
        bill: _bill(totalAmount: 180, tax: 20, service: 10),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'Wine', price: 80, qty: 1),
          const Item(id: 'i2', billId: 'b', name: 'Water', price: 20, qty: 1),
        ],
        participants: [_participant('p1'), _participant('p2')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
          const Assignment(id: 'a2', itemId: 'i2', participantId: 'p2'),
        ],
      );
      // p1: 80 subtotal (80%), p2: 20 subtotal (20%)
      // p1 tax: 20 * 0.8 = 16, service: 10 * 0.8 = 8
      // p2 tax: 20 * 0.2 = 4, service: 10 * 0.2 = 2
      // totals: p1=104, p2=26, sum=130. bill.totalAmount=180. drift=50 (unassigned)
      final totals = state.calculateTotals();
      expect(totals.length, 2);
      expect(totals[0].subtotal, 80);
      expect(totals[0].tax, 16);
      expect(totals[0].service, 8);
      expect(totals[1].subtotal, 20);
      expect(totals[1].tax, 4);
      expect(totals[1].service, 2);
    });

    test('rounding drift absorbed by last participant with positive total', () {
      final state = SplitState(
        bill: _bill(totalAmount: 151, tax: 10, service: 0),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 140, qty: 1),
        ],
        participants: [_participant('p1'), _participant('p2')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
          const Assignment(id: 'a2', itemId: 'i1', participantId: 'p2'),
        ],
      );
      // p1: 70, p2: 70. tax: 5 each. totals: 75, 75. sum=150, drift=1.
      final totals = state.calculateTotals();
      expect(totals[0].total, 75);
      expect(totals[1].total, 76); // absorbs the drift
    });

    test('unassigned subtotal does not force reconcile to bill total', () {
      // When every item is assigned (unassignedSubtotal ≈ 0), drift is absorbed.
      // Otherwise the bill total may legitimately differ.
      final state = SplitState(
        bill: _bill(totalAmount: 200, tax: 0, service: 0),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 50, qty: 1),
          const Item(id: 'i2', billId: 'b', name: 'B', price: 100, qty: 1),
        ],
        participants: [_participant('p1')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
        ],
      );
      // Only i1 is assigned (50), i2 is unassigned (100).
      final totals = state.calculateTotals();
      expect(totals.length, 1);
      expect(totals.single.total, 50);
    });

    test('multiple participants with mixed shared and exclusive items', () {
      final state = SplitState(
        bill: _bill(totalAmount: 300, tax: 0, service: 0),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'Pizza', price: 100, qty: 1),
          const Item(id: 'i2', billId: 'b', name: 'Pasta', price: 80, qty: 1),
          const Item(id: 'i3', billId: 'b', name: 'Salad', price: 60, qty: 1),
        ],
        participants: [_participant('p1'), _participant('p2')],
        assignments: [
          const Assignment(id: 'a1', itemId: 'i1', participantId: 'p1'),
          const Assignment(id: 'a2', itemId: 'i1', participantId: 'p2'),
          const Assignment(id: 'a3', itemId: 'i2', participantId: 'p1'),
          const Assignment(id: 'a4', itemId: 'i3', participantId: 'p2'),
        ],
      );
      final totals = state.calculateTotals();
      // p1: 100/2 + 80 = 130 subtotal
      // p2: 100/2 + 60 = 110 subtotal
      expect(totals[0].subtotal, 130);
      expect(totals[1].subtotal, 110);
    });
  });
}

Bill _bill({double totalAmount = 0, double tax = 0, double service = 0}) =>
    Bill(
      id: 'b',
      title: 'Test',
      totalAmount: totalAmount,
      currencyCode: 'IDR',
      tax: tax,
      service: service,
      createdAt: DateTime(2026),
    );

Participant _participant(String id) =>
    Participant(id: id, billId: 'b', name: id);
