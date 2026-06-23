import 'package:bagistruk/presentation/bills/widgets/participant_avatar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ParticipantAvatar.initialsFor', () {
    test('empty string returns ?', () {
      expect(ParticipantAvatar.initialsFor(''), '?');
    });

    test('whitespace only returns ?', () {
      expect(ParticipantAvatar.initialsFor('   '), '?');
    });

    test('single word returns first letter uppercase', () {
      expect(ParticipantAvatar.initialsFor('Alice'), 'A');
    });

    test('single lowercase word returns uppercase', () {
      expect(ParticipantAvatar.initialsFor('alice'), 'A');
    });

    test('two words returns first letters uppercase', () {
      expect(ParticipantAvatar.initialsFor('Alice Smith'), 'AS');
    });

    test('extra spaces collapsed', () {
      expect(ParticipantAvatar.initialsFor('  Alice  Smith  '), 'AS');
    });

    test('three words takes only first two', () {
      expect(ParticipantAvatar.initialsFor('Alice Smith Jr'), 'AS');
    });
  });

  group('ParticipantAvatar.colorFor', () {
    test('same id always returns same color', () {
      final c1 = ParticipantAvatar.colorFor('user-123');
      final c2 = ParticipantAvatar.colorFor('user-123');
      expect(c1, equals(c2));
    });

    test('different ids may return different colors', () {
      final colors = <int>{};
      for (var i = 0; i < 100; i++) {
        colors.add(ParticipantAvatar.colorFor('user-$i').toARGB32());
      }
      // At least some should differ (probability ~0 with 100 random ids)
      expect(colors.length, greaterThan(1));
    });

    test('empty id still returns valid color', () {
      final color = ParticipantAvatar.colorFor('');
      expect(color, isNotNull);
    });
  });
}
