import 'package:test/test.dart';

import 'theme_extensions/empty_theme.dart';

void main() {
  group('EmptyThemeWithConstConstructor', () {
    test('canMerge returns true', () {
      const theme = EmptyThemeWithConstConstructor();
      expect(theme.canMerge, isTrue);
    });

    group('lerp', () {
      test('returns a when identical', () {
        const a = EmptyThemeWithConstConstructor();
        const b = EmptyThemeWithConstConstructor();
        final result = EmptyThemeWithConstConstructor.lerp(a, b, 0.5);
        expect(identical(result, a), isTrue);
      });

      test('returns null when both are null', () {
        final result = EmptyThemeWithConstConstructor.lerp(null, null, 0.5);
        expect(result, isNull);
      });

      test('returns null when a is null and t != 1.0', () {
        const b = EmptyThemeWithConstConstructor();
        final result = EmptyThemeWithConstConstructor.lerp(null, b, 0.5);
        expect(result, isNull);
      });

      test('returns b when a is null and t == 1.0', () {
        const b = EmptyThemeWithConstConstructor();
        final result = EmptyThemeWithConstConstructor.lerp(null, b, 1);
        expect(result, equals(b));
      });

      test('returns null when b is null and t != 0.0', () {
        const a = EmptyThemeWithConstConstructor();
        final result = EmptyThemeWithConstConstructor.lerp(a, null, 0.5);
        expect(result, isNull);
      });

      test('returns a when b is null and t == 0.0', () {
        const a = EmptyThemeWithConstConstructor();
        final result = EmptyThemeWithConstConstructor.lerp(a, null, 0);
        expect(result, equals(a));
      });

      test('returns new instance when both are not null', () {
        const a = EmptyThemeWithConstConstructor();
        const b = EmptyThemeWithConstConstructor();
        final result = EmptyThemeWithConstConstructor.lerp(a, b, 0.5);
        expect(result, isNotNull);
        expect(result, isA<EmptyThemeWithConstConstructor>());
      });
    });

    test('copyWith returns const instance', () {
      const theme = EmptyThemeWithConstConstructor();
      final copied = theme.copyWith();
      expect(copied, equals(theme));
    });

    group('merge', () {
      test('returns this when other is null', () {
        const theme = EmptyThemeWithConstConstructor();
        final merged = theme.merge(null);
        expect(identical(merged, theme), isTrue);
      });

      test('returns this when identical', () {
        const theme = EmptyThemeWithConstConstructor();
        final merged = theme.merge(theme);
        expect(identical(merged, theme), isTrue);
      });

      test('returns merged instance when other can merge', () {
        const theme = EmptyThemeWithConstConstructor();
        const other = EmptyThemeWithConstConstructor();
        final merged = theme.merge(other);
        expect(merged, isA<EmptyThemeWithConstConstructor>());
      });
    });

    test('equality works correctly', () {
      const theme1 = EmptyThemeWithConstConstructor();
      const theme2 = EmptyThemeWithConstConstructor();
      expect(theme1, equals(theme2));
      expect(theme1.hashCode, equals(theme2.hashCode));
    });

    test('not equal to different type', () {
      const theme = EmptyThemeWithConstConstructor();
      expect(theme == Object(), isFalse);
    });
  });

  group('EmptyThemeWithoutConstConstructor', () {
    test('canMerge returns true', () {
      final theme = EmptyThemeWithoutConstConstructor();
      expect(theme.canMerge, isTrue);
    });

    group('lerp', () {
      test('returns a when identical', () {
        final a = EmptyThemeWithoutConstConstructor();
        final result = EmptyThemeWithoutConstConstructor.lerp(a, a, 0.5);
        expect(identical(result, a), isTrue);
      });

      test('returns null when both are null', () {
        final result = EmptyThemeWithoutConstConstructor.lerp(null, null, 0.5);
        expect(result, isNull);
      });

      test('returns null when a is null and t != 1.0', () {
        final b = EmptyThemeWithoutConstConstructor();
        final result = EmptyThemeWithoutConstConstructor.lerp(null, b, 0.5);
        expect(result, isNull);
      });

      test('returns b when a is null and t == 1.0', () {
        final b = EmptyThemeWithoutConstConstructor();
        final result = EmptyThemeWithoutConstConstructor.lerp(null, b, 1);
        expect(result, equals(b));
      });

      test('returns null when b is null and t != 0.0', () {
        final a = EmptyThemeWithoutConstConstructor();
        final result = EmptyThemeWithoutConstConstructor.lerp(a, null, 0.5);
        expect(result, isNull);
      });

      test('returns a when b is null and t == 0.0', () {
        final a = EmptyThemeWithoutConstConstructor();
        final result = EmptyThemeWithoutConstConstructor.lerp(a, null, 0);
        expect(result, equals(a));
      });

      test('returns new instance when both are not null', () {
        final a = EmptyThemeWithoutConstConstructor();
        final b = EmptyThemeWithoutConstConstructor();
        final result = EmptyThemeWithoutConstConstructor.lerp(a, b, 0.5);
        expect(result, isNotNull);
        expect(result, isA<EmptyThemeWithoutConstConstructor>());
      });
    });

    test('copyWith returns new instance', () {
      final theme = EmptyThemeWithoutConstConstructor();
      final copied = theme.copyWith();
      expect(copied, equals(theme));
      expect(identical(copied, theme), isFalse);
    });

    group('merge', () {
      test('returns this when other is null', () {
        final theme = EmptyThemeWithoutConstConstructor();
        final merged = theme.merge(null);
        expect(identical(merged, theme), isTrue);
      });

      test('returns this when identical', () {
        final theme = EmptyThemeWithoutConstConstructor();
        final merged = theme.merge(theme);
        expect(identical(merged, theme), isTrue);
      });

      test('returns merged instance when other can merge', () {
        final theme = EmptyThemeWithoutConstConstructor();
        final other = EmptyThemeWithoutConstConstructor();
        final merged = theme.merge(other);
        expect(merged, isA<EmptyThemeWithoutConstConstructor>());
      });
    });

    test('equality works correctly', () {
      final theme1 = EmptyThemeWithoutConstConstructor();
      final theme2 = EmptyThemeWithoutConstConstructor();
      expect(theme1, equals(theme2));
      expect(theme1.hashCode, equals(theme2.hashCode));
    });

    test('not equal to different type', () {
      final theme = EmptyThemeWithoutConstConstructor();
      expect(theme == Object(), isFalse);
    });
  });
}
