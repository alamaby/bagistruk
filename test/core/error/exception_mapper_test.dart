import 'dart:async';
import 'dart:io';

import 'package:bagistruk/core/error/exception_mapper.dart';
import 'package:bagistruk/core/error/failure.dart';
import 'package:bagistruk/core/error/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('guardAsync', () {
    test('happy path returns success', () async {
      final result = await guardAsync(() async => 42);
      expect(result, isA<Success<int>>());
      expect((result as Success<int>).data, 42);
    });

    test('PostgrestException maps to Failure.server', () async {
      final result = await guardAsync(() async {
        throw PostgrestException(message: 'rls violation', code: '42501');
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).code, 42501);
      expect(failure.message, contains('rls violation'));
    });

    test('PostgrestException with null code maps to server', () async {
      final result = await guardAsync(() async {
        throw PostgrestException(message: 'error');
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect(failure, isA<ServerFailure>());
    });

    test('AuthException maps to Failure.auth', () async {
      final result = await guardAsync(() async {
        throw AuthException('not authenticated');
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect(failure, isA<AuthFailure>());
      expect((failure as AuthFailure).message, 'not authenticated');
    });

    test('FunctionException maps to Failure.server', () async {
      final result = await guardAsync(() async {
        throw FunctionException(status: 502, details: 'bad gateway');
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).code, 502);
      expect(failure.message, contains('bad gateway'));
    });

    test('FunctionException with null details uses fallback message', () async {
      final result = await guardAsync(() async {
        throw FunctionException(status: 500);
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect((failure as ServerFailure).message, 'Edge function error');
    });

    test('SocketException maps to Failure.network', () async {
      final result = await guardAsync(() async {
        throw SocketException('offline');
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).message, 'offline');
    });

    test('TimeoutException with message maps to Failure.network', () async {
      final result = await guardAsync(() async {
        throw TimeoutException('slow');
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).message, 'slow');
    });

    test('TimeoutException without message uses fallback', () async {
      final result = await guardAsync(() async {
        throw TimeoutException(null);
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect((failure as NetworkFailure).message, 'Request timed out');
    });

    test('FormatException maps to Failure.parsing', () async {
      final result = await guardAsync(() async {
        throw FormatException('bad json');
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect(failure, isA<ParsingFailure>());
      expect((failure as ParsingFailure).message, 'bad json');
    });

    test('generic Exception maps to Failure.unknown', () async {
      final result = await guardAsync(() async {
        throw Exception('boom');
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect(failure, isA<UnknownFailure>());
    });

    test('generic Error maps to Failure.unknown', () async {
      final result = await guardAsync(() async {
        // ignore: only_throw_errors
        throw StateError('unexpected');
      });
      expect(result, isA<ResultFailure<int>>());
      final failure = (result as ResultFailure<int>).failure;
      expect(failure, isA<UnknownFailure>());
    });
  });
}
