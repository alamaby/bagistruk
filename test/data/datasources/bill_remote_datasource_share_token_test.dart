import 'package:bagistruk/data/datasources/bill_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BillRemoteDataSource.parseShareTokenResponse', () {
    test('TABLE shape List 3 kolom → Map row pertama', () {
      final rows = <dynamic>[
        {
          'token_id': 'token-uuid-1',
          'expires_at': '2026-09-28T00:00:00Z',
          'revoked_count': 0,
        },
      ];

      final row = BillRemoteDataSource.parseShareTokenResponse(rows);

      expect(row['token_id'], 'token-uuid-1');
      expect(row['revoked_count'], 0);
      expect(row['expires_at'], '2026-09-28T00:00:00Z');
    });

    test('List kosong → FormatException', () {
      expect(
        () => BillRemoteDataSource.parseShareTokenResponse([]),
        throwsA(isA<FormatException>()),
      );
    });

    test('server lama 2 kolom (tanpa revoked_count) tetap parse', () {
      final rows = <dynamic>[
        {
          'token_id': 'token-uuid-2',
          'expires_at': '2026-09-28T00:00:00Z',
        },
      ];

      final row = BillRemoteDataSource.parseShareTokenResponse(rows);

      expect(row['token_id'], 'token-uuid-2');
      expect(row.containsKey('revoked_count'), isFalse);
      // Repo layer default revokedCount 0 sudah di-cover
      // bill_repository_impl.dart:126 — tidak perlu diassert di sini.
    });
  });
}
