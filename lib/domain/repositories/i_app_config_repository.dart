import '../../core/error/result.dart';
import '../entities/app_config.dart';

/// Reads runtime app configuration (legal document versions, future feature
/// flags) from the `app_config` table. The implementation is expected to
/// memoize the result for the lifetime of a single app session; callers can
/// [invalidate] the cache when they know the server state may have changed
/// (e.g. after a manual settings refresh).
abstract interface class IAppConfigRepository {
  Future<Result<AppConfig>> getConfig();

  /// Clears the in-memory cache. The next [getConfig] call re-reads the
  /// `app_config` table.
  void invalidate();
}
