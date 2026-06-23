import 'package:bagistruk/domain/entities/transfer_bank_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransferBankInfo.fromProfileRow', () {
    test('empty row returns null', () {
      expect(TransferBankInfo.fromProfileRow({}), isNull);
    });

    test('null values return null', () {
      expect(
        TransferBankInfo.fromProfileRow({
          'transfer_bank_name': null,
          'transfer_account_name': null,
          'transfer_account_number': null,
        }),
        isNull,
      );
    });

    test('bankName only returns null (not complete)', () {
      expect(
        TransferBankInfo.fromProfileRow({
          'transfer_bank_name': 'BCA',
        }),
        isNull,
      );
    });

    test('two of three fields returns null', () {
      expect(
        TransferBankInfo.fromProfileRow({
          'transfer_bank_name': 'BCA',
          'transfer_account_name': 'Andi',
        }),
        isNull,
      );
    });

    test('all three fields with whitespace only returns null', () {
      expect(
        TransferBankInfo.fromProfileRow({
          'transfer_bank_name': '   ',
          'transfer_account_name': '   ',
          'transfer_account_number': '   ',
        }),
        isNull,
      );
    });

    test('all three valid fields returns instance', () {
      final info = TransferBankInfo.fromProfileRow({
        'transfer_bank_name': 'BCA',
        'transfer_account_name': 'Andi',
        'transfer_account_number': '123456',
      });
      expect(info, isNotNull);
      expect(info!.isComplete, isTrue);
      expect(info.bankName, 'BCA');
      expect(info.accountName, 'Andi');
      expect(info.accountNumber, '123456');
    });

    test('whitespace trimmed in values', () {
      final info = TransferBankInfo.fromProfileRow({
        'transfer_bank_name': '  BCA  ',
        'transfer_account_name': '  Andi  ',
        'transfer_account_number': '  123456  ',
      });
      expect(info, isNotNull);
      expect(info!.bankName, 'BCA');
    });
  });

  group('TransferBankInfo.isComplete', () {
    test('empty bankName returns false', () {
      const info = TransferBankInfo(
        bankName: '',
        accountName: 'Andi',
        accountNumber: '123',
      );
      expect(info.isComplete, isFalse);
    });

    test('all valid returns true', () {
      const info = TransferBankInfo(
        bankName: 'BCA',
        accountName: 'Andi',
        accountNumber: '123',
      );
      expect(info.isComplete, isTrue);
    });

    test('whitespace only bankName returns false', () {
      const info = TransferBankInfo(
        bankName: '  ',
        accountName: 'Andi',
        accountNumber: '123',
      );
      expect(info.isComplete, isFalse);
    });
  });
}
