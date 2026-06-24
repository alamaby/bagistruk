import 'package:bagistruk/domain/entities/assignment.dart';
import 'package:bagistruk/domain/entities/bill.dart';
import 'package:bagistruk/domain/entities/item.dart';
import 'package:bagistruk/domain/entities/participant.dart';
import 'package:bagistruk/presentation/bills/providers/bill_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BillDetailState.paidCount', () {
    test('no participants returns 0', () {
      final state = BillDetailState(
        bill: _bill(),
        items: [],
        participants: [],
        assignments: [],
      );
      expect(state.paidCount, 0);
    });

    test('all unpaid returns 0', () {
      final state = BillDetailState(
        bill: _bill(),
        items: [],
        participants: [
          const Participant(id: 'p1', billId: 'b', name: 'A'),
          const Participant(id: 'p2', billId: 'b', name: 'B'),
        ],
        assignments: [],
      );
      expect(state.paidCount, 0);
    });

    test('counts only paid participants', () {
      final state = BillDetailState(
        bill: _bill(),
        items: [],
        participants: [
          const Participant(id: 'p1', billId: 'b', name: 'A'),
          Participant(id: 'p2', billId: 'b', name: 'B', isPaid: true),
          const Participant(id: 'p3', billId: 'b', name: 'C'),
        ],
        assignments: [],
      );
      expect(state.paidCount, 1);
    });
  });

  group('BillDetailState.calculateTotals', () {
    test('no participants returns empty list', () {
      final state = BillDetailState(
        bill: _bill(),
        items: [
          const Item(id: 'i1', billId: 'b', name: 'A', price: 10, qty: 1),
        ],
        participants: [],
        assignments: [],
      );
      expect(state.calculateTotals(), isEmpty);
    });

    test('single participant with full bill', () {
      final state = BillDetailState(
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
      final state = BillDetailState(
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

    test('tax and service proportional to item share', () {
      final state = BillDetailState(
        bill: _bill(totalAmount: 120, tax: 10, service: 0),
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
      // p1: 80 subtotal (80%) → tax 8, service 0
      // p2: 20 subtotal (20%) → tax 2, service 0
      final totals = state.calculateTotals();
      expect(totals[0].tax, 8);
      expect(totals[1].tax, 2);
    });

    test('rounding drift absorbed by last participant with positive total', () {
      final state = BillDetailState(
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
      // p1: 70, p2: 70. tax 5 each. totals 75+75=150, drift=1.
      final totals = state.calculateTotals();
      expect(totals[1].total, 76);
    });

    test('unassigned items avoid forced reconcile to bill total', () {
      final state = BillDetailState(
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
      final totals = state.calculateTotals();
      expect(totals.single.total, 50);
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
