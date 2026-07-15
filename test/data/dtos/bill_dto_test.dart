import 'package:flutter_test/flutter_test.dart';

import '../../../lib/data/dtos/bill_dto.dart';

void main() {
  group('fromJsonWithParticipants', () {
    Map<String, dynamic> _baseJson({
      required String id,
      List<Map<String, dynamic>>? participants,
    }) =>
        {
          'id': id,
          'title': 'Test',
          'total_amount': 10000.0,
          'currency_code': 'IDR',
          'tax_amount': 0.0,
          'service_charge': 0.0,
          'is_settled': false,
          'created_at': '2026-07-15T00:00:00Z',
          if (participants != null) 'participants': participants,
        };

    test('parses nested is_paid flags', () {
      final json = _baseJson(
        id: '1',
        participants: [
          {'is_paid': true},
          {'is_paid': false},
          {'is_paid': true},
        ],
      );
      final dto = BillDto.fromJsonWithParticipants(json);
      expect(dto.participantPaymentStatuses, [true, false, true]);
    });

    test('empty participants returns empty list', () {
      final json = _baseJson(id: '2', participants: []);
      final dto = BillDto.fromJsonWithParticipants(json);
      expect(dto.participantPaymentStatuses, isEmpty);
    });

    test('missing participants key returns empty list', () {
      final json = _baseJson(id: '3');
      final dto = BillDto.fromJsonWithParticipants(json);
      expect(dto.participantPaymentStatuses, isEmpty);
    });

    test('null participants returns empty list', () {
      final json = _baseJson(id: '4', participants: null);
      final dto = BillDto.fromJsonWithParticipants(json);
      expect(dto.participantPaymentStatuses, isEmpty);
    });

    test('malformed entry with missing is_paid treated as false', () {
      final json = _baseJson(
        id: '5',
        participants: [
          {'other': 'data'},
        ],
      );
      final dto = BillDto.fromJsonWithParticipants(json);
      expect(dto.participantPaymentStatuses, [false]);
    });

    test('non-bool is_paid treated as false', () {
      final json = _baseJson(
        id: '6',
        participants: [
          {'is_paid': 'yes'},
        ],
      );
      final dto = BillDto.fromJsonWithParticipants(json);
      expect(dto.participantPaymentStatuses, [false]);
    });

    test('toJson does not include participant summary', () {
      final json = _baseJson(
        id: '7',
        participants: [
          {'is_paid': true},
        ],
      );
      final dto = BillDto.fromJsonWithParticipants(json);
      final serialized = dto.toJson();
      expect(serialized, isNot(contains('participants')));
      expect(serialized, isNot(contains('participantPaymentStatuses')));
    });

    test('toEntity propagates participantPaymentStatuses', () {
      final json = _baseJson(
        id: '8',
        participants: [
          {'is_paid': true},
        ],
      );
      final dto = BillDto.fromJsonWithParticipants(json);
      final entity = dto.toEntity();
      expect(entity.participantPaymentStatuses, [true]);
    });
  });
}
