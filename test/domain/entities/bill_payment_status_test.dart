import 'package:bagistruk/domain/entities/bill.dart';
import 'package:bagistruk/domain/entities/bill_payment_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Bill _bill({required List<bool> statuses}) => Bill(
    id: 'test',
    title: 'Test',
    totalAmount: 100000,
    isSettled: false,
    createdAt: DateTime(2026),
    participantPaymentStatuses: statuses,
  );

  group('paymentStatus', () {
    test('empty participants returns unassigned', () {
      expect(_bill(statuses: []).paymentStatus, BillPaymentStatus.unassigned);
    });

    test('all false returns unpaid', () {
      expect(
        _bill(statuses: [false, false]).paymentStatus,
        BillPaymentStatus.unpaid,
      );
    });

    test('mixed true/false returns partial', () {
      expect(
        _bill(statuses: [true, false]).paymentStatus,
        BillPaymentStatus.partial,
      );
      expect(
        _bill(statuses: [false, true]).paymentStatus,
        BillPaymentStatus.partial,
      );
    });

    test('all true returns settled', () {
      expect(
        _bill(statuses: [true, true]).paymentStatus,
        BillPaymentStatus.settled,
      );
    });

    test('single participant unpaid returns unpaid', () {
      expect(
        _bill(statuses: [false]).paymentStatus,
        BillPaymentStatus.unpaid,
      );
    });

    test('single participant paid returns settled', () {
      expect(
        _bill(statuses: [true]).paymentStatus,
        BillPaymentStatus.settled,
      );
    });

    test('isSettled flag ignored when computing payment status', () {
      final bill = Bill(
        id: 'test',
        title: 'Test',
        totalAmount: 100000,
        isSettled: true,
        createdAt: DateTime(2026),
        participantPaymentStatuses: [false],
      );
      expect(bill.paymentStatus, BillPaymentStatus.unpaid);
    });
  });

  group('isFinalStatus', () {
    test('settled is final', () {
      expect(BillPaymentStatus.settled.isFinalStatus, true);
    });

    test('other statuses are not final', () {
      expect(BillPaymentStatus.unassigned.isFinalStatus, false);
      expect(BillPaymentStatus.unpaid.isFinalStatus, false);
      expect(BillPaymentStatus.partial.isFinalStatus, false);
    });
  });
}
