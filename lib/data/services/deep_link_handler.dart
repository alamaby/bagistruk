import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/app_logger.dart';

/// Listens for incoming deep links (email confirmation, password-reset
/// callbacks) and routes them to Supabase's `getSessionFromUrl()`.
///
/// This bridges the gap when the app is cold-started by a deep link — GoRouter
/// redirect alone cannot catch the initial URI because the router tree is not
/// yet mounted when `main()` runs.
class DeepLinkHandler {
  DeepLinkHandler._();
  static final DeepLinkHandler _instance = DeepLinkHandler._();
  static DeepLinkHandler get instance => _instance;

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// Process the initial link that cold-started the app (if any).
  Future<void> handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialAppLink();
      if (uri != null) {
        await _processUri(uri);
      }
    } catch (e) {
      AppLogger.warning('DeepLinkHandler: failed to process initial link: $e');
    }
  }

  /// Start listening for links arriving while the app is already running.
  void listen() {
    _sub?.cancel();
    _sub = _appLinks.uriLinkStream.listen(
      _processUri,
      onError: (e) => AppLogger.warning('DeepLinkHandler: stream error: $e'),
    );
  }

  Future<void> _processUri(Uri uri) async {
    final raw = uri.toString();
    final isSupabaseCallback =
        raw.contains('access_token=') ||
        raw.contains('refresh_token=') ||
        raw.contains('code=') ||
        raw.contains('type=signup') ||
        raw.contains('type=email_change') ||
        raw.contains('type=recovery') ||
        raw.contains('error_description=');
    if (!isSupabaseCallback) return;

    AppLogger.info('DeepLinkHandler: processing auth callback: $uri');
    try {
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
    } catch (e) {
      AppLogger.warning('DeepLinkHandler: getSessionFromUrl failed: $e');
    }
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
