import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../../core/format/phone_formatter.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/providers.dart';
import '../../../data/services/saved_participants_cache.dart';
import '../../../domain/entities/saved_participant.dart';
import '../../auth/providers/auth_providers.dart';

part 'saved_participants_notifier.g.dart';

/// Cross-bill participant library. Source of truth lives on the server
/// (`public.user_saved_participants`) and is mirrored to a local
/// SharedPreferences cache for offline-first suggestions.
///
/// Read path: `build()` returns the local cache immediately so the split
/// dialog can render chips before any network round trip. A fire-and-forget
/// refresh from the server runs in parallel and patches the cache + state
/// when it completes.
///
/// Write path: [bump] optimistically patches the cache + state, then fires
/// the server `bump_saved_participant` RPC. The local patch is optimistic
/// (best-effort UX); the server RPC is authoritative.
@Riverpod(keepAlive: true)
class SavedParticipantsNotifier extends _$SavedParticipantsNotifier {
  static const _suggestionLimit = 8;

  @override
  Future<List<SavedParticipant>> build() async {
    // Rebuild whenever the active session changes (anon ↔ email, sign-out,
    // etc.) so cached suggestions never leak across user boundaries.
    ref.watch(authStateProvider);
    final userId = ref.read(authRepositoryProvider).currentUserId;
    if (userId == null || userId.isEmpty) return const [];

    final cache = await ref.watch(savedParticipantsCacheProvider.future);
    final cached = await cache.readAll(userId);
    // Fire-and-forget server refresh; failures are silent (cached list is
    // still useful) and logged for observability.
    unawaited(_refreshFromServer(cache, userId));
    return cached;
  }

  Future<void> _refreshFromServer(
    SavedParticipantsCache cache,
    String userId,
  ) async {
    final repo = ref.read(savedParticipantRepositoryProvider);
    final res = await repo.listSuggestions(limit: _suggestionLimit);
    switch (res) {
      case Success(:final data):
        await cache.writeAll(userId, data);
        state = AsyncData(data);
      case ResultFailure(:final failure):
        AppLogger.error('SavedParticipantsNotifier: refresh failed', failure);
    }
  }

  /// Public refresh hook (e.g. called when the split screen mounts so a
  /// newly-edited bill's participants show up next time).
  Future<void> refresh() async {
    final userId = ref.read(authRepositoryProvider).currentUserId;
    if (userId == null || userId.isEmpty) return;
    final cache = await ref.read(savedParticipantsCacheProvider.future);
    await _refreshFromServer(cache, userId);
  }

  /// Increments use_count + last_used_at for the given (lower(name), phone)
  /// tuple. Phone is normalised via [PhoneFormatter.normalize]; null/short
  /// phones collapse to an empty string so the server UNIQUE constraint
  /// groups all "no-phone" entries under one bucket.
  Future<void> bump({required String name, required String? phone}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final userId = ref.read(authRepositoryProvider).currentUserId;
    if (userId == null || userId.isEmpty) return;
    final normalizedCandidate = PhoneFormatter.normalize(phone);
    final normalized =
        normalizedCandidate == null || normalizedCandidate.length < 6
        ? ''
        : normalizedCandidate;

    // Optimistic local patch: find existing entry, bump use_count + ts.
    final current = state.value ?? const <SavedParticipant>[];
    final now = DateTime.now().toUtc();
    final updated = [...current];
    final idx = updated.indexWhere(
      (p) =>
          p.name.toLowerCase() == trimmed.toLowerCase() &&
          p.phone == normalized,
    );
    if (idx >= 0) {
      updated[idx] = updated[idx].copyWith(
        useCount: updated[idx].useCount + 1,
        lastUsedAt: now,
      );
    } else {
      updated.add(
        SavedParticipant(
          name: trimmed,
          phone: normalized,
          useCount: 1,
          lastUsedAt: now,
        ),
      );
    }
    // Keep top-N only so the cache stays bounded.
    updated.sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
    final capped = updated.take(_suggestionLimit).toList(growable: false);
    state = AsyncData(capped);

    final cache = await ref.read(savedParticipantsCacheProvider.future);
    await cache.writeAll(userId, capped);

    // Server write — failures are non-fatal (cache is already patched).
    final repo = ref.read(savedParticipantRepositoryProvider);
    final res = await repo.bump(name: trimmed, phone: normalized);
    if (res is ResultFailure<void>) {
      AppLogger.error(
        'SavedParticipantsNotifier: server bump failed',
        res.failure,
      );
    }
  }
}
