import '../../core/error/result.dart';
import '../entities/saved_participant.dart';

/// Cross-bill participant library: per-user autocomplete suggestions.
abstract interface class ISavedParticipantRepository {
  /// Returns top-[limit] suggestions ranked by use_count + recency.
  Future<Result<List<SavedParticipant>>> listSuggestions({int limit = 8});

  /// Atomic upsert that increments use_count and refreshes last_used_at
  /// for the (lower(name), phone) tuple.
  Future<Result<void>> bump({required String name, required String phone});
}
