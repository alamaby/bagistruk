import 'package:bagistruk/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme light surface', () {
    test('light theme uses pure white surface', () {
      expect(AppTheme.light.colorScheme.surface, const Color(0xFFFFFFFF));
    });

    test('dark theme does not use pure white surface', () {
      expect(AppTheme.dark.colorScheme.surface, isNot(const Color(0xFFFFFFFF)));
    });

    test('light theme preserves container contrast', () {
      final scheme = AppTheme.light.colorScheme;

      expect(
        scheme.surfaceContainer,
        isNot(scheme.surface),
        reason:
            'surfaceContainer should differ from white surface '
            'to preserve card/container hierarchy',
      );
    });
  });
}
