import 'dart:async';

import '../../core/error/exception_mapper.dart';
import '../../core/error/result.dart';
import '../../domain/entities/app_config.dart';
import '../../domain/repositories/i_app_config_repository.dart';
import '../datasources/app_config_remote_datasource.dart';

class AppConfigRepositoryImpl implements IAppConfigRepository {
  AppConfigRepositoryImpl(this._ds);
  final AppConfigRemoteDataSource _ds;

  AppConfig? _cache;
  // Coalesces concurrent reads into a single network call so callers that
  // subscribe to the notifier during cold start do not all hit PostgREST.
  Future<AppConfig>? _inflight;

  @override
  Future<Result<AppConfig>> getConfig() => guardAsync(() async {
    final cached = _cache;
    if (cached != null) return cached;
    final inflight = _inflight;
    if (inflight != null) return inflight;
    final future = _fetch();
    _inflight = future;
    try {
      return await future;
    } finally {
      _inflight = null;
    }
  });

  @override
  void invalidate() {
    _cache = null;
    _inflight = null;
  }

  Future<AppConfig> _fetch() async {
    final rows = await _ds.readAll();
    final cfg = AppConfig.fromRows(rows);
    _cache = cfg;
    return cfg;
  }
}
