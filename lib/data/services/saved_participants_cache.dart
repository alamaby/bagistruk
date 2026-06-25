import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/saved_participant.dart';
import '../dtos/saved_participant_dto.dart';

/// Offline-first JSON cache for the cross-bill participant library.
///
/// Stores the most recent top-N suggestions returned by
/// `public.list_suggested_participants()` so the split screen can render
/// suggestion chips instantly before the network round trip completes.
/// Failures are surfaced as empty list so the caller falls back gracefully
/// (no suggestions is acceptable for a brand-new user).
class SavedParticipantsCache {
  SavedParticipantsCache._(this._prefs);

  static const _keyPrefix = 'saved_participants_cache_v1';

  final SharedPreferences _prefs;

  static Future<SavedParticipantsCache> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SavedParticipantsCache._(prefs);
  }

  Future<List<SavedParticipant>> readAll(String userId) async {
    final raw = _prefs.getString(_key(userId));
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (json) =>
                SavedParticipantDto.fromJson(Map<String, dynamic>.from(json)),
          )
          .map((d) => d.toEntity())
          .toList(growable: false);
    } catch (_) {
      // Corrupt cache (e.g. schema change between app versions) — wipe and
      // start fresh so the next write populates a clean entry.
      await _prefs.remove(_key(userId));
      return const [];
    }
  }

  Future<void> writeAll(
    String userId,
    List<SavedParticipant> participants,
  ) async {
    final encoded = jsonEncode(
      participants
          .map(SavedParticipantDto.fromEntity)
          .map((d) => d.toJson())
          .toList(growable: false),
    );
    await _prefs.setString(_key(userId), encoded);
  }

  Future<void> clear(String userId) => _prefs.remove(_key(userId));

  static String _key(String userId) => '$_keyPrefix:$userId';
}
