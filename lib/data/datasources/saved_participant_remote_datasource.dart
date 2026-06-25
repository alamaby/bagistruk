import 'package:supabase_flutter/supabase_flutter.dart';

import '../dtos/saved_participant_dto.dart';

/// Thin PostgREST + RPC wrapper for the per-user participant library.
/// No error handling here — exceptions bubble up to be translated centrally
/// by [guardAsync] in the repository layer.
class SavedParticipantRemoteDataSource {
  SavedParticipantRemoteDataSource(this._client);

  final SupabaseClient _client;

  /// Returns top-N saved participants ranked by 40% use_count + 60% recency
  /// (30-day decay). See `public.list_suggested_participants()`.
  Future<List<SavedParticipantDto>> listSuggestions({int limit = 8}) async {
    final rows = await _client.rpc<List<dynamic>>(
      'list_suggested_participants',
      params: {'p_limit': limit},
    );
    return rows
        .map(
          (r) =>
              SavedParticipantDto.fromJson(Map<String, dynamic>.from(r as Map)),
        )
        .toList(growable: false);
  }

  /// Atomic upsert that bumps `use_count` and refreshes `last_used_at` for
  /// the (user, lower(name), phone) tuple. Phone is normalised to an empty
  /// string when null so the server's UNIQUE constraint treats "no phone"
  /// entries consistently.
  Future<void> bump({required String name, required String phone}) async {
    await _client.rpc<void>(
      'bump_saved_participant',
      params: {'p_name': name, 'p_phone': phone},
    );
  }
}
