import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin PostgREST wrapper for the `app_config` key/value table. The table is
/// read-only for client roles (RLS grants SELECT to anon and authenticated,
/// no policy grants writes), so this datasource exposes a single read.
class AppConfigRemoteDataSource {
  AppConfigRemoteDataSource(this._client);
  final SupabaseClient _client;

  static const _table = 'app_config';

  /// Returns every row in `app_config` as raw PostgREST maps. The repository
  /// layer is responsible for interpreting the keys it cares about.
  Future<List<Map<String, dynamic>>> readAll() async {
    final rows = await _client.from(_table).select('key,value');
    return List<Map<String, dynamic>>.from(rows as List);
  }
}
