import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/error/failure.dart';
import '../../core/error/result.dart';
import '../dtos/assignment_dto.dart';
import '../dtos/bill_dto.dart';
import '../dtos/item_dto.dart';
import '../dtos/participant_dto.dart';

class DeletedBillDto {
  const DeletedBillDto({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.currencyCode,
    required this.isSettled,
    required this.createdAt,
    required this.deletedAt,
    required this.deleteExpiresAt,
  });

  final String id;
  final String title;
  final double totalAmount;
  final String currencyCode;
  final bool isSettled;
  final DateTime createdAt;
  final DateTime deletedAt;
  final DateTime deleteExpiresAt;

  factory DeletedBillDto.fromJson(Map<String, dynamic> json) => DeletedBillDto(
    id: json['id'].toString(),
    title: json['title'].toString(),
    totalAmount: _readDouble(json['total_amount']),
    currencyCode: json['currency_code']?.toString() ?? 'IDR',
    isSettled: json['is_settled'] == true,
    createdAt: DateTime.parse(json['created_at'].toString()),
    deletedAt: DateTime.parse(json['deleted_at'].toString()),
    deleteExpiresAt: DateTime.parse(json['delete_expires_at'].toString()),
  );

  static double _readDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

/// Thin wrapper around PostgREST. No error handling here — exceptions bubble
/// up to be translated centrally by [guardAsync] in the repository layer.
class BillRemoteDataSource {
  BillRemoteDataSource(this._client);
  final SupabaseClient _client;

  static const _bills = 'bills';
  static const _items = 'items';
  static const _participants = 'participants';
  static const _assignments = 'item_assignments';

  /// Idempotent session guard. Returns the current user id if a session is
  /// attached, or signs in anonymously otherwise. Callers (notably
  /// [BillRepositoryImpl.createBill]) use this to prevent RLS 42501 on the
  /// first PostgREST request after a cold start where the in-memory session
  /// was lost but the local persisted session hasn't been re-attached yet.
  Future<Result<String>> authEnsureSignedIn() async {
    try {
      // Cek currentSession + accessToken, bukan hanya currentUser. Di beberapa
      // race condition (mis. sesi baru saja berakhir di background, atau
      // Supabase client emit `AuthStateChange` null session) `currentUser`
      // masih bisa berisi value non-null tapi JWT sudah tidak valid lagi.
      // PostgREST hanya percaya `Authorization: Bearer <access_token>` di
      // header — kalau tidak ada token valid, RLS menilai `auth.uid()` = NULL
      // dan menolak INSERT/UPDATE. Cek session + accessToken memastikan kita
      // selalu sign-in ulang sebelum request pertama setelah cold start.
      final session = _client.auth.currentSession;
      final existingToken = session?.accessToken;
      final existingUserId = session?.user.id;
      if (existingToken != null &&
          existingToken.isNotEmpty &&
          existingUserId != null) {
        return Result.success(existingUserId);
      }
      final res = await _client.auth.signInAnonymously();
      final user = res.user;
      if (user == null) {
        return const Result.failure(
          Failure.auth('Anonymous sign-in returned no user'),
        );
      }
      return Result.success(user.id);
    } on AuthException catch (e) {
      return Result.failure(Failure.auth(e.message));
    } catch (e, st) {
      return Result.failure(Failure.unknown(e, st));
    }
  }

  Future<List<BillDto>> listBills({DateTime? createdAfter}) async {
    var query = _client
        .from(_bills)
        .select('*, $_participants(is_paid)')
        .isFilter('deleted_at', null);
    if (createdAfter != null) {
      query = query.gte('created_at', createdAfter.toUtc().toIso8601String());
    }

    final rows = await query.order('created_at', ascending: false);
    return rows.map((r) => BillDto.fromJsonWithParticipants(r)).toList(growable: false);
  }

  Future<BillDto> getBill(String id) async {
    final row = await _client.from(_bills).select().eq('id', id).single();
    return BillDto.fromJson(row);
  }

  Future<BillDto> upsertBill(BillDto dto) async {
    final row = await _client
        .from(_bills)
        .upsert(dto.toJson())
        .select()
        .single();
    return BillDto.fromJson(row);
  }

  Future<void> deleteBill(String id) =>
      _client.rpc('soft_delete_bill', params: {'p_bill_id': id});

  Future<void> restoreDeletedBill(String id) =>
      _client.rpc('restore_deleted_bill', params: {'p_bill_id': id});

  Future<List<DeletedBillDto>> listDeletedBills() async {
    final rows = await _client
        .from(_bills)
        .select(
          'id,title,total_amount,currency_code,is_settled,created_at,deleted_at,delete_expires_at',
        )
        .not('deleted_at', 'is', null)
        .order('deleted_at', ascending: false);
    return rows.map((r) => DeletedBillDto.fromJson(r)).toList(growable: false);
  }

  Future<List<ItemDto>> listItems(String billId) async {
    final rows = await _client.from(_items).select().eq('bill_id', billId);
    return rows.map((r) => ItemDto.fromJson(r)).toList(growable: false);
  }

  Future<List<ItemDto>> upsertItems(List<ItemDto> items) async {
    if (items.isEmpty) return const [];
    final rows = await _client
        .from(_items)
        .upsert(items.map((i) => i.toJson()).toList())
        .select();
    return rows.map((r) => ItemDto.fromJson(r)).toList(growable: false);
  }

  Future<List<ParticipantDto>> listParticipants(String billId) async {
    final rows = await _client
        .from(_participants)
        .select()
        .eq('bill_id', billId);
    return rows.map((r) => ParticipantDto.fromJson(r)).toList(growable: false);
  }

  Future<ParticipantDto> upsertParticipant(ParticipantDto dto) async {
    final row = await _client
        .from(_participants)
        .upsert(dto.toJson())
        .select()
        .single();
    return ParticipantDto.fromJson(row);
  }

  Future<void> deleteParticipant(String participantId) =>
      _client.from(_participants).delete().eq('id', participantId);

  Future<List<AssignmentDto>> listAssignments(String billId) async {
    // Assignments are joined via items.bill_id; assumes a SQL view or a
    // nested select policy is in place. Fallback: per-item fetch from caller.
    final rows = await _client
        .from(_assignments)
        .select('*, items!inner(bill_id)')
        .eq('items.bill_id', billId);
    return rows.map((r) => AssignmentDto.fromJson(r)).toList(growable: false);
  }

  Future<List<AssignmentDto>> replaceAssignments(
    String billId,
    List<AssignmentDto> next,
  ) async {
    // Replacement strategy: delete-then-insert in one transactional RPC would
    // be ideal; for now we do it as two PostgREST calls — acceptable because
    // assignments only change inside a single editor session.
    final itemIds = await _client
        .from(_items)
        .select('id')
        .eq('bill_id', billId);
    final ids = itemIds.map((r) => r['id'] as String).toList();
    if (ids.isNotEmpty) {
      await _client.from(_assignments).delete().inFilter('item_id', ids);
    }
    if (next.isEmpty) return const [];
    final rows = await _client
        .from(_assignments)
        .insert(next.map((a) => a.toJson()).toList())
        .select();
    return rows.map((r) => AssignmentDto.fromJson(r)).toList(growable: false);
  }
}
