import 'package:test/test.dart';

import '../theme_extensions/empty_theme_extension.dart';

void main() {
  group('EmptyThemeExtension', () {
    test('can be instantiated', () {
      const theme = EmptyThemeExtension();
      expect(theme, isA<EmptyThemeExtension>());
    });

    group('lerp', () {
      test('returns a when identical', () {
        const a = EmptyThemeExtension();
        const b = EmptyThemeExtension();
        final result = a.lerp(b, 0.5);
        expect(identical(result, a), isTrue);
      });

      test('lerp with various t values', () {
        const a = EmptyThemeExtension();
        const b = EmptyThemeExtension();

        expect(a.lerp(b, 0), equals(a));
        expect(a.lerp(b, 0.5), equals(a));
        expect(a.lerp(b, 1), equals(a));
      });
    });

    group('copyWith', () {
      test('returns const instance', () {
        const theme = EmptyThemeExtension();
        final copied = theme.copyWith();
        expect(copied, equals(theme));
      });

      test('preserves const constructor', () {
        const theme = EmptyThemeExtension();
        final copied = theme.copyWith();
        expect(identical(copied, theme), isTrue);
      });
    });

    group('equality', () {
      test('two instances are equal', () {
        const theme1 = EmptyThemeExtension();
        const theme2 = EmptyThemeExtension();
        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
      });

      test('not equal to different type', () {
        const theme = EmptyThemeExtension();
        expect(theme == Object(), isFalse);
      });
    });
  });
}
