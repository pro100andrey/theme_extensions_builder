import 'package:test/test.dart';

import '../theme_extensions/empty_theme.dart';

void main() {
  group('EmptyTheme - with const constructor', () {
    test('can be instantiated', () {
      const theme = EmptyTheme();
      expect(theme, isA<EmptyTheme>());
    });

    test('canMerge returns true', () {
      const theme = EmptyTheme();
      expect(theme.canMerge, isTrue);
    });

    group('lerp', () {
      test('returns a when identical', () {
        const a = EmptyTheme();
        const b = EmptyTheme();
        final result = EmptyTheme.lerp(a, b, 0.5);
        expect(identical(result, a), isTrue);
      });

      test('returns null when both are null', () {
        final result = EmptyTheme.lerp(null, null, 0.5);
        expect(result, isNull);
      });

      test('returns null when a is null and t != 1.0', () {
        const b = EmptyTheme();
        final result = EmptyTheme.lerp(null, b, 0.5);
        expect(result, isNull);
      });

      test('returns b when a is null and t == 1.0', () {
        const b = EmptyTheme();
        final result = EmptyTheme.lerp(null, b, 1);
        expect(result, equals(b));
      });

      test('returns null when b is null and t != 0.0', () {
        const a = EmptyTheme();
        final result = EmptyTheme.lerp(a, null, 0.5);
        expect(result, isNull);
      });

      test('returns a when b is null and t == 0.0', () {
        const a = EmptyTheme();
        final result = EmptyTheme.lerp(a, null, 0);
        expect(result, equals(a));
      });

      test('returns new instance when both are not null', () {
        const a = EmptyTheme();
        const b = EmptyTheme();
        final result = EmptyTheme.lerp(a, b, 0.5);
        expect(result, isNotNull);
        expect(result, isA<EmptyTheme>());
      });

      test('lerp with various t values', () {
        const a = EmptyTheme();
        const b = EmptyTheme();

        expect(EmptyTheme.lerp(a, b, 0), isNotNull);
        expect(EmptyTheme.lerp(a, b, 0.25), isNotNull);
        expect(EmptyTheme.lerp(a, b, 0.5), isNotNull);
        expect(EmptyTheme.lerp(a, b, 0.75), isNotNull);
        expect(EmptyTheme.lerp(a, b, 1), isNotNull);
      });
    });

    group('copyWith', () {
      test('returns const instance', () {
        const theme = EmptyTheme();
        final copied = theme.copyWith();
        expect(copied, equals(theme));
      });

      test('preserves const constructor', () {
        const theme = EmptyTheme();
        final copied = theme.copyWith();
        expect(identical(copied, theme), isTrue);
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        const theme = EmptyTheme();
        final merged = theme.merge(null);
        expect(identical(merged, theme), isTrue);
      });

      test('returns this when identical', () {
        const theme = EmptyTheme();
        final merged = theme.merge(theme);
        expect(identical(merged, theme), isTrue);
      });

      test('returns merged instance when other can merge', () {
        const theme = EmptyTheme();
        const other = EmptyTheme();
        final merged = theme.merge(other);
        expect(merged, isA<EmptyTheme>());
      });
    });

    group('equality', () {
      test('two instances are equal', () {
        const theme1 = EmptyTheme();
        const theme2 = EmptyTheme();
        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
      });

      test('not equal to different type', () {
        const theme = EmptyTheme();
        expect(theme == Object(), isFalse);
      });
    });
  });

  group('EmptyThemeWithoutConstConstructor - without const constructor', () {
    test('can be instantiated', () {
      final theme = EmptyThemeWithoutConstConstructor();
      expect(theme, isA<EmptyThemeWithoutConstConstructor>());
    });

    test('canMerge returns true', () {
      final theme = EmptyThemeWithoutConstConstructor();
      expect(theme.canMerge, isTrue);
    });

    group('lerp', () {
      test('returns equal instance when lerping', () {
        final a = EmptyThemeWithoutConstConstructor();
        final b = EmptyThemeWithoutConstConstructor();
        final result = EmptyThemeWithoutConstConstructor.lerp(a, b, 0.5);
        expect(result, equals(a));
        expect(identical(a, b), isFalse);
        expect(identical(result, a), isFalse);
        expect(identical(result, b), isFalse);
        expect(result, isA<EmptyThemeWithoutConstConstructor>());
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
        expect(identical(result, b), isTrue);
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
        expect(identical(result, a), isTrue);
      });

      test('returns new instance when both are not null', () {
        final a = EmptyThemeWithoutConstConstructor();
        final b = EmptyThemeWithoutConstConstructor();
        final result = EmptyThemeWithoutConstConstructor.lerp(a, b, 0.5);
        expect(result, isNotNull);
        expect(identical(a, b), isFalse);
        expect(identical(result, a), isFalse);
        expect(identical(result, b), isFalse);
        expect(result, isA<EmptyThemeWithoutConstConstructor>());
      });

      test('lerp with various t values', () {
        final a = EmptyThemeWithoutConstConstructor();
        final b = EmptyThemeWithoutConstConstructor();

        expect(EmptyThemeWithoutConstConstructor.lerp(a, b, 0), isNotNull);
        expect(EmptyThemeWithoutConstConstructor.lerp(a, b, 0.25), isNotNull);
        expect(EmptyThemeWithoutConstConstructor.lerp(a, b, 0.5), isNotNull);
        expect(EmptyThemeWithoutConstConstructor.lerp(a, b, 0.75), isNotNull);
        expect(EmptyThemeWithoutConstConstructor.lerp(a, b, 1), isNotNull);
      });
    });

    group('copyWith', () {
      test('returns new instance', () {
        final theme = EmptyThemeWithoutConstConstructor();
        final copied = theme.copyWith();
        expect(copied, equals(theme));
        expect(identical(copied, theme), isFalse);
      });

      test('creates independent copy', () {
        final theme = EmptyThemeWithoutConstConstructor();
        final copied = theme.copyWith();
        expect(copied, isA<EmptyThemeWithoutConstConstructor>());
        expect(copied, isNot(same(theme)));
      });
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

    group('equality', () {
      test('two instances are equal', () {
        final theme1 = EmptyThemeWithoutConstConstructor();
        final theme2 = EmptyThemeWithoutConstConstructor();
        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
        expect(identical(theme1, theme2), isFalse);
      });

      test('not equal to different type', () {
        final theme = EmptyThemeWithoutConstConstructor();
        expect(theme == Object(), isFalse);
      });

      test('not equal to EmptyTheme', () {
        final theme = EmptyThemeWithoutConstConstructor();
        const otherTheme = EmptyTheme();
        // ignore: unrelated_type_equality_checks
        expect(theme == otherTheme, isFalse);
      });
    });
  });
}
