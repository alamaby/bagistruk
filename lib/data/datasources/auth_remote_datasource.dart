import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/env.dart';
import '../../domain/entities/auth_snapshot.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);
  final SupabaseClient _client;
  static Future<void>? _googleInitFuture;

  GoTrueClient get _auth => _client.auth;

  String? get currentUserId => _auth.currentUser?.id;

  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  Stream<String?> watchUserId() =>
      _auth.onAuthStateChange.map((s) => s.session?.user.id);

  Stream<AuthSnapshot> watchAuthState() => _auth.onAuthStateChange.map((s) {
    final user = s.session?.user;
    return AuthSnapshot(
      userId: user?.id,
      isAnonymous: user?.isAnonymous ?? false,
    );
  });

  Future<String> signInAnonymously() async {
    final res = await _auth.signInAnonymously();
    final user = res.user;
    if (user == null) {
      throw const AuthException('Anonymous sign-in returned no user');
    }
    return user.id;
  }

  /// Returns the current user id if a session exists, otherwise creates an
  /// anonymous one. Idempotent — safe to call before any auth-gated action.
  /// Used in lieu of an eager bootstrap sign-in so persisted sessions
  /// (anonymous or email) are not overwritten on cold start.
  Future<String> ensureSignedIn() async {
    final existing = _auth.currentUser?.id;
    if (existing != null) return existing;
    return signInAnonymously();
  }

  /// Promotes the current anon user. Supabase preserves `auth.uid()` when
  /// linking, so any rows owned by the anon user remain accessible after.
  Future<void> linkEmail({
    required String email,
    required String password,
  }) async {
    await _auth.updateUser(UserAttributes(email: email, password: password));
  }

  /// Same uid-preserving upgrade as [linkEmail] — exposed under a name that
  /// matches the Register screen's intent.
  Future<void> signUp({required String email, required String password}) =>
      linkEmail(email: email, password: password);

  /// Logs into an existing account. If the previous session was anonymous,
  /// reassigns its rows to the new uid via `migrate_anon_data` RPC so the
  /// user does not lose work in progress.
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final oldUid = _auth.currentUser?.id;
    final wasAnon = _auth.currentUser?.isAnonymous ?? false;
    await _auth.signInWithPassword(email: email, password: password);
    final newUid = _auth.currentUser?.id;
    if (wasAnon && oldUid != null && newUid != null && oldUid != newUid) {
      await _client.rpc<void>(
        'migrate_anon_data',
        params: {'p_old_uid': oldUid},
      );
    }
  }

  /// Native Google Sign-In bridged into Supabase via the Google ID token.
  /// If the app had an anonymous session, any in-progress bills are migrated
  /// to the Google-backed Supabase user after the new session is established.
  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      throw const AuthException(
        'Google sign-in web flow is not enabled in this app build',
      );
    }

    final oldUid = _auth.currentUser?.id;
    final wasAnon = _auth.currentUser?.isAnonymous ?? false;

    final GoogleSignInAccount googleUser;
    try {
      await _ensureGoogleInitialized();
      googleUser = await GoogleSignIn.instance.authenticate();
    } on StateError catch (e) {
      throw AuthException(e.message);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('Google sign-in dibatalkan');
      }
      final description = e.description;
      throw AuthException(
        description == null || description.isEmpty
            ? 'Google sign-in gagal: ${e.code.name}'
            : description,
      );
    }

    final idToken = googleUser.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const AuthException('Google sign-in returned no ID token');
    }

    await _auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );

    final newUid = _auth.currentUser?.id;
    if (wasAnon && oldUid != null && newUid != null && oldUid != newUid) {
      await _client.rpc<void>(
        'migrate_anon_data',
        params: {'p_old_uid': oldUid},
      );
    }
  }

  /// Resends the email-change confirmation. Used after [signUp] / [linkEmail]
  /// when the user wants another copy of the verification link.
  Future<void> resendEmailChange({required String email}) =>
      _auth.resend(type: OtpType.emailChange, email: email);

  Future<void> signOut() async {
    await _auth.signOut();
    if (_googleInitFuture == null) return;
    try {
      await _googleInitFuture;
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Supabase sign-out is the source of truth; local Google cleanup is best-effort.
    }
  }

  /// Triggers a password reset email for [email]. The link in the email opens
  /// the Supabase recovery flow; the app's router catches `type=recovery`
  /// fragments and lands the user on a real route.
  Future<void> resetPasswordForEmail(String email) =>
      _auth.resetPasswordForEmail(email);

  Future<void> _ensureGoogleInitialized() {
    return _googleInitFuture ??= GoogleSignIn.instance.initialize(
      clientId: switch (defaultTargetPlatform) {
        TargetPlatform.iOS || TargetPlatform.macOS => Env.googleIosClientId,
        _ => null,
      },
      serverClientId: Env.googleWebClientId,
    );
  }
}
