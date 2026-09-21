import 'dart:async';

import 'package:bagistruk/data/datasources/bill_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// `SupabaseClient.rpc<T>` mengembalikan `PostgrestFilterBuilder<T>` — bukan
// `Future` polos — sehingga `MockSupabaseClient` hasil @GenerateMocks tidak
// bisa di-stub untuk RPC ini: `thenAnswer((_) async => [...])` akan gagal
// cast `Future as PostgrestFilterBuilder` di kode mock yang di-generate.
// Plan (Detail M3, pitfalls) mengizinkan alternatif ini: fake manual yang
// override `rpc` langsung, tanpa mengubah kode produksi.

/// Hasil RPC palsu: berperilaku seperti [PostgrestFilterBuilder] yang sudah
/// selesai dieksekusi dan resolve ke [_value] saat di-await. Hanya kontrak
/// [Future] yang di-override; sisanya ditangani [Fake.noSuchMethod] (tidak
/// pernah dipanggil kode produksi yang diuji).
class _FakeRpcResult<T> extends Fake implements PostgrestFilterBuilder<T> {
  _FakeRpcResult(this._value);

  final T _value;

  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue,
      {Function? onError,}) {
    return Future.value(_value).then(onValue, onError: onError);
  }

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) {
    return Future.value(_value).catchError(onError, test: test);
  }

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) {
    return Future.value(_value).timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) {
    return Future.value(_value).whenComplete(action);
  }

  @override
  Stream<T> asStream() => Stream.value(_value);
}

/// [SupabaseClient] palsu yang merekam panggilan [rpc] dan mengembalikan
/// respons terprogram per nama fungsi — tanpa HTTP sungguhan.
class FakeSupabaseClient extends Fake implements SupabaseClient {
  FakeSupabaseClient({required this.respond});

  final List<dynamic> Function(String fn) respond;

  String? lastFn;
  Map<String, dynamic>? lastParams;

  @override
  PostgrestFilterBuilder<T> rpc<T>(
    String fn, {
    Map<String, dynamic>? params,
    dynamic get = false,
  }) {
    lastFn = fn;
    lastParams = params;
    return _FakeRpcResult<T>(respond(fn) as T);
  }
}

void main() {
  late FakeSupabaseClient fakeClient;
  late BillRemoteDataSource ds;

  // Tiap test mendaftarkan responsnya sendiri via `respond`.
  void useResponse(List<dynamic> rows) {
    fakeClient = FakeSupabaseClient(respond: (_) => rows);
    ds = BillRemoteDataSource(fakeClient);
  }

  test('TABLE shape List 3 kolom → Map row pertama', () async {
    useResponse(<dynamic>[
      <String, dynamic>{
        'token_id': 'token-uuid-1',
        'expires_at': '2026-09-28T00:00:00Z',
        'revoked_count': 0,
      },
    ]);

    final row = await ds.createShareToken(
      billId: 'bill-1',
      tokenHash: 'a' * 64,
    );

    expect(row['token_id'], 'token-uuid-1');
    expect(row['revoked_count'], 0);
    expect(fakeClient.lastFn, 'create_bill_share_token');
    expect(
      fakeClient.lastParams,
      <String, dynamic>{'p_bill_id': 'bill-1', 'p_token_hash': 'a' * 64},
    );
  });

  test('List kosong → FormatException', () async {
    useResponse(<dynamic>[]);

    expect(
      () => ds.createShareToken(billId: 'bill-1', tokenHash: 'a' * 64),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          'empty create response',
        ),
      ),
    );
  });

  test('server lama 2 kolom (tanpa revoked_count) tetap parse', () async {
    useResponse(<dynamic>[
      <String, dynamic>{
        'token_id': 'token-uuid-2',
        'expires_at': '2026-09-28T00:00:00Z',
      },
    ]);

    final row = await ds.createShareToken(
      billId: 'bill-1',
      tokenHash: 'a' * 64,
    );

    expect(row['token_id'], 'token-uuid-2');
    expect(row.containsKey('revoked_count'), isFalse);
    // Repo layer default revokedCount 0 sudah di-cover
    // bill_repository_impl.dart:126 — tidak perlu diassert di sini.
  });
}
