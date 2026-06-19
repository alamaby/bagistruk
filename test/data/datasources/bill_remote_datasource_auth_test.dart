import 'package:bagistruk/core/error/result.dart';
import 'package:bagistruk/data/datasources/bill_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bill_remote_datasource_auth_test.mocks.dart';

@GenerateMocks([SupabaseClient, GoTrueClient, AuthResponse, User, Session])
void main() {
  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late BillRemoteDataSource ds;

  setUpAll(() {
    provideDummy<User?>(null);
    provideDummy<AuthResponse>(AuthResponse(user: null, session: null));
  });

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(mockClient.auth).thenReturn(mockAuth);
    ds = BillRemoteDataSource(mockClient);
  });

  group('BillRemoteDataSource.authEnsureSignedIn', () {
    test('valid session (accessToken + user.id) → returns user id, no '
        'signInAnonymously call', () async {
      final user = User(
        id: 'user-123',
        appMetadata: const {},
        userMetadata: const {},
        aud: 'authenticated',
        createdAt: DateTime(2026).toIso8601String(),
      );
      final session = Session(
        accessToken: 'valid-jwt-token',
        tokenType: 'bearer',
        user: user,
      );
      when(mockAuth.currentSession).thenReturn(session);

      final res = await ds.authEnsureSignedIn();

      expect(res, isA<Result<String>>());
      final data = (res as dynamic).data as String;
      expect(data, 'user-123');
      verifyNever(mockAuth.signInAnonymously());
    });

    test('currentUser present but currentSession is null → falls back to '
        'signInAnonymously (RLS-safe)', () async {
      // Race condition: currentUser may have a value but the session/JWT
      // is already gone. The old code would early-return on currentUser.id,
      // but the new request would have no Bearer token and RLS would 42501.
      final user = User(
        id: 'user-stale',
        appMetadata: const {},
        userMetadata: const {},
        aud: 'authenticated',
        createdAt: DateTime(2026).toIso8601String(),
      );
      when(mockAuth.currentSession).thenReturn(null);
      when(mockAuth.currentUser).thenReturn(user);
      when(mockAuth.signInAnonymously()).thenAnswer(
        (_) async => AuthResponse(
          user: User(
            id: 'user-fresh',
            appMetadata: const {},
            userMetadata: const {},
            aud: 'authenticated',
            createdAt: DateTime(2026).toIso8601String(),
          ),
          session: null,
        ),
      );

      final res = await ds.authEnsureSignedIn();

      expect(res, isA<Result<String>>());
      final data = (res as dynamic).data as String;
      expect(data, 'user-fresh');
      verify(mockAuth.signInAnonymously()).called(1);
    });

    test('no currentSession at all → signs in anonymously', () async {
      when(mockAuth.currentSession).thenReturn(null);
      when(mockAuth.currentUser).thenReturn(null);
      when(mockAuth.signInAnonymously()).thenAnswer(
        (_) async => AuthResponse(
          user: User(
            id: 'user-anon',
            appMetadata: const {},
            userMetadata: const {},
            aud: 'authenticated',
            createdAt: DateTime(2026).toIso8601String(),
          ),
          session: null,
        ),
      );

      final res = await ds.authEnsureSignedIn();

      expect(res, isA<Result<String>>());
      final data = (res as dynamic).data as String;
      expect(data, 'user-anon');
      verify(mockAuth.signInAnonymously()).called(1);
    });

    test('session present but accessToken is empty → falls back to '
        'signInAnonymously', () async {
      final user = User(
        id: 'user-no-token',
        appMetadata: const {},
        userMetadata: const {},
        aud: 'authenticated',
        createdAt: DateTime(2026).toIso8601String(),
      );
      final session = Session(accessToken: '', tokenType: 'bearer', user: user);
      when(mockAuth.currentSession).thenReturn(session);
      when(mockAuth.signInAnonymously()).thenAnswer(
        (_) async => AuthResponse(
          user: User(
            id: 'user-anon-2',
            appMetadata: const {},
            userMetadata: const {},
            aud: 'authenticated',
            createdAt: DateTime(2026).toIso8601String(),
          ),
          session: null,
        ),
      );

      final res = await ds.authEnsureSignedIn();

      expect(res, isA<Result<String>>());
      final data = (res as dynamic).data as String;
      expect(data, 'user-anon-2');
      verify(mockAuth.signInAnonymously()).called(1);
    });
  });
}
