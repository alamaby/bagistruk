import 'package:bagistruk/domain/entities/assignment.dart';
import 'package:bagistruk/domain/entities/bill.dart';
import 'package:bagistruk/domain/entities/item.dart';
import 'package:bagistruk/domain/entities/participant.dart';
import 'package:bagistruk/l10n/generated/app_l10n_en.dart';
import 'package:bagistruk/presentation/bills/providers/split_notifier.dart';
import 'package:bagistruk/presentation/bills/utils/settlement_message_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  final l10n = AppL10nEn();
  final currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final bill = Bill(
    id: 'b1',
    title: 'Makan Siang',
    totalAmount: 150000,
    currencyCode: 'IDR',
    tax: 5000,
    service: 0,
    createdAt: DateTime(2026, 7, 15),
  );
  final item = Item(id: 'i1', billId: 'b1', name: 'Nasi Goreng', price: 50000);
  final participant = Participant(id: 'p1', billId: 'b1', name: 'Budi');
  final assignment = Assignment(id: 'a1', itemId: 'i1', participantId: 'p1');
  final state = SplitState(
    bill: bill,
    items: [item],
    participants: [participant],
    assignments: [assignment],
  );

  group('SettlementMessageBuilder', () {
    test('basic template includes promo footer', () {
      final message =
          SettlementMessageBuilder(
            state: state,
            currency: currency,
            l10n: l10n,
          ).build(
            template: SettlementMessageTemplate.basic,
            participantId: 'p1',
            includeWhatsappLink: false,
          );

      expect(message, contains('Made with BagiStruk'));
      expect(
        message,
        contains(
          'https://play.google.com/store/apps/details?id=com.alamaby.bagistruk',
        ),
      );
    });

    test('compactPlus template includes promo footer', () {
      final message =
          SettlementMessageBuilder(
            state: state,
            currency: currency,
            l10n: l10n,
          ).build(
            template: SettlementMessageTemplate.compactPlus,
            participantId: 'p1',
            includeWhatsappLink: false,
          );

      expect(message, contains('Made with BagiStruk'));
      expect(
        message,
        contains(
          'https://play.google.com/store/apps/details?id=com.alamaby.bagistruk',
        ),
      );
    });

    test('detailedPlus template includes promo footer', () {
      final message =
          SettlementMessageBuilder(
            state: state,
            currency: currency,
            l10n: l10n,
          ).build(
            template: SettlementMessageTemplate.detailedPlus,
            participantId: 'p1',
            includeWhatsappLink: false,
          );

      expect(message, contains('Made with BagiStruk'));
      expect(
        message,
        contains(
          'https://play.google.com/store/apps/details?id=com.alamaby.bagistruk',
        ),
      );
    });

    test('allPlus template includes promo footer', () {
      final message = SettlementMessageBuilder(
        state: state,
        currency: currency,
        l10n: l10n,
      ).build(template: SettlementMessageTemplate.allPlus);

      expect(message, contains('Made with BagiStruk'));
      expect(
        message,
        contains(
          'https://play.google.com/store/apps/details?id=com.alamaby.bagistruk',
        ),
      );
    });

    test('promo footer is the last line in the message', () {
      final message =
          SettlementMessageBuilder(
            state: state,
            currency: currency,
            l10n: l10n,
          ).build(
            template: SettlementMessageTemplate.basic,
            participantId: 'p1',
            includeWhatsappLink: false,
          );

      final lines = message.trimRight().split('\n');
      final lastLine = lines.last;
      expect(
        lastLine,
        'Made with BagiStruk. Try the app on Google Play: '
        'https://play.google.com/store/apps/details?id=com.alamaby.bagistruk',
      );
    });
  });
}
