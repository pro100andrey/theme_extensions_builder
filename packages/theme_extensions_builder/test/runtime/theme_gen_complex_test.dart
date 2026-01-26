import 'package:test/test.dart';

import '../theme_gen/complex_theme.dart';
import '../theme_gen/empty_theme.dart';
import '../theme_gen/empty_theme_extension.dart';
import '../theme_gen/mock.dart';

void main() {
  group('ComplexTheme', () {
    late ComplexTheme themeA;
    late ComplexTheme themeB;

    setUp(() {
      themeA = const ComplexTheme(
        requiredInt: 10,
        requiredDouble: 1.5,
        requiredString: 'hello',
        requiredBool: true,
        requiredDuration: Duration(seconds: 5),
        requiredColor: Color(0xFF0000FF),
        requiredBorderSide: BorderSide(width: 2),
        requiredTheme: EmptyTheme(),
        requiredThemeExtension: EmptyThemeExtension(),
        optionalInt: 20,
        optionalDouble: 2.5,
        optionalString: 'world',
        optionalBool: false,
        optionalDuration: Duration(seconds: 10),
        optionalColor: Color(0xFFFF0000),
        optionalBorderSide: BorderSide(width: 3),
        optionalTheme: EmptyTheme(),
        optionalThemeExtension: EmptyThemeExtension(),
        optionalLerpableWithOptionalResult: LerpableWithOptionalResult(1),
        ignoredField: 'test',
      );

      themeB = const ComplexTheme(
        requiredInt: 30,
        requiredDouble: 3.5,
        requiredString: 'goodbye',
        requiredBool: false,
        requiredDuration: Duration(seconds: 15),
        requiredColor: Color(0xFF00FF00),
        requiredBorderSide: BorderSide(width: 4),
        requiredTheme: EmptyTheme(),
        requiredThemeExtension: EmptyThemeExtension(),
        optionalInt: 40,
        optionalDouble: 4.5,
        optionalString: 'universe',
        optionalBool: true,
        optionalDuration: Duration(seconds: 20),
        optionalColor: Color(0xFF00FFFF),
        optionalBorderSide: BorderSide(width: 5),
        optionalTheme: EmptyTheme(),
        optionalThemeExtension: EmptyThemeExtension(),
        optionalLerpableWithOptionalResult: LerpableWithOptionalResult(5),
        ignoredField: 'test2',
      );
    });

    test('can be instantiated', () {
      expect(themeA, isA<ComplexTheme>());
      expect(themeB, isA<ComplexTheme>());
    });

    test('canMerge returns true', () {
      expect(themeA.canMerge, isTrue);
      expect(themeB.canMerge, isTrue);
    });

    test('ignoredField is not in generated code', () {
      // The ignoredField should exist in the class but not affect generated
      // methods
      expect(themeA.ignoredField, equals('test'));
      expect(themeB.ignoredField, equals('test2'));
    });

    group('copyWith', () {
      test('returns same values when no parameters provided', () {
        final copied = themeA.copyWith();
        expect(copied.requiredInt, equals(themeA.requiredInt));
        expect(copied.requiredDouble, equals(themeA.requiredDouble));
        expect(copied.requiredString, equals(themeA.requiredString));
        expect(copied.requiredBool, equals(themeA.requiredBool));
        expect(copied.optionalInt, equals(themeA.optionalInt));
      });

      test('updates required int field', () {
        final copied = themeA.copyWith(requiredInt: 999);
        expect(copied.requiredInt, equals(999));
        expect(copied.requiredDouble, equals(themeA.requiredDouble));
      });

      test('updates required double field', () {
        final copied = themeA.copyWith(requiredDouble: 9.99);
        expect(copied.requiredDouble, equals(9.99));
        expect(copied.requiredInt, equals(themeA.requiredInt));
      });

      test('updates required String field', () {
        final copied = themeA.copyWith(requiredString: 'updated');
        expect(copied.requiredString, equals('updated'));
      });

      test('updates required bool field', () {
        final copied = themeA.copyWith(requiredBool: false);
        expect(copied.requiredBool, isFalse);
      });

      test('updates optional fields', () {
        final copied = themeA.copyWith(optionalInt: 100, optionalString: 'new');
        expect(copied.optionalInt, equals(100));
        expect(copied.optionalString, equals('new'));
      });

      test('updates Duration fields', () {
        final copied = themeA.copyWith(
          requiredDuration: const Duration(seconds: 30),
          optionalDuration: const Duration(seconds: 60),
        );
        expect(copied.requiredDuration, equals(const Duration(seconds: 30)));
        expect(copied.optionalDuration, equals(const Duration(seconds: 60)));
      });

      test('updates Color fields', () {
        const newColor = Color(0xFFFFFFFF);
        final copied = themeA.copyWith(requiredColor: newColor);
        expect(copied.requiredColor, equals(newColor));
      });

      test('updates BorderSide fields', () {
        const newBorder = BorderSide(width: 10);
        final copied = themeA.copyWith(requiredBorderSide: newBorder);
        expect(copied.requiredBorderSide, equals(newBorder));
      });

      test('updates custom theme fields', () {
        const newTheme = EmptyTheme();
        final copied = themeA.copyWith(requiredTheme: newTheme);
        expect(copied.requiredTheme, equals(newTheme));
      });

      test('preserves optional fields when not specified', () {
        final copied = themeA.copyWith(requiredInt: 999);
        expect(copied.optionalInt, equals(themeA.optionalInt));
        expect(copied.optionalString, equals(themeA.optionalString));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final merged = themeA.merge(null);
        expect(identical(merged, themeA), isTrue);
      });

      test('returns this when identical', () {
        final merged = themeA.merge(themeA);
        expect(identical(merged, themeA), isTrue);
      });

      test('merges with other theme', () {
        final merged = themeA.merge(themeB);
        expect(merged, isA<ComplexTheme>());
        // Merge should prefer values from 'other' (themeB)
        expect(merged.requiredInt, equals(themeB.requiredInt));
        expect(merged.requiredDouble, equals(themeB.requiredDouble));
        expect(merged.requiredString, equals(themeB.requiredString));
      });

      test('merges optional fields', () {
        final merged = themeA.merge(themeB);
        expect(merged.optionalInt, equals(themeB.optionalInt));
        expect(merged.optionalString, equals(themeB.optionalString));
      });

      test('merges nested themes', () {
        final merged = themeA.merge(themeB);
        expect(merged.requiredTheme, isA<EmptyTheme>());
        expect(merged.optionalTheme, isA<EmptyTheme>());
      });
    });

    group('lerp', () {
      test('returns a when identical', () {
        final result = ComplexTheme.lerp(themeA, themeA, 0.5);
        expect(identical(result, themeA), isTrue);
      });

      test('returns null when both are null', () {
        final result = ComplexTheme.lerp(null, null, 0.5);
        expect(result, isNull);
      });

      test('returns null when a is null and t != 1.0', () {
        final result = ComplexTheme.lerp(null, themeB, 0.5);
        expect(result, isNull);
      });

      test('returns b when a is null and t == 1.0', () {
        final result = ComplexTheme.lerp(null, themeB, 1);
        expect(result, equals(themeB));
      });

      test('returns null when b is null and t != 0.0', () {
        final result = ComplexTheme.lerp(themeA, null, 0.5);
        expect(result, isNull);
      });

      test('lerps optional values correctly at t=0.5', () {
        final result = ComplexTheme.lerp(themeA, themeB, 0.5);

        expect(result, isNotNull);
        expect(result!.optionalDouble, equals(3.5));
        expect(result.optionalDuration, equals(const Duration(seconds: 15)));
      });

      test('lerps instance lerp with optional result (nullable field)', () {
        // Test InstanceLerp(optionalResult: true) with nullable field
        final themeWithLerpable1 = themeA.copyWith(
          optionalLerpableWithOptionalResult: const LerpableWithOptionalResult(
            2,
          ),
        );
        final themeWithLerpable2 = themeB.copyWith(
          optionalLerpableWithOptionalResult: const LerpableWithOptionalResult(
            8,
          ),
        );

        final result = ComplexTheme.lerp(
          themeWithLerpable1,
          themeWithLerpable2,
          0.5,
        );

        expect(result, isNotNull);
        expect(result!.optionalLerpableWithOptionalResult, isNotNull);
        expect(
          result.optionalLerpableWithOptionalResult!.value,
          equals(5.0),
        );
      });

      test(
        'lerps instance lerp with optional result when first value is null',
        () {
          // Create themes where one has null for the lerpable field
          const themeWithNull = ComplexTheme(
            requiredInt: 10,
            requiredDouble: 1.5,
            requiredString: 'hello',
            requiredBool: true,
            requiredDuration: Duration(seconds: 5),
            requiredColor: Color(0xFF0000FF),
            requiredBorderSide: BorderSide(width: 2),
            requiredTheme: EmptyTheme(),
            requiredThemeExtension: EmptyThemeExtension(),
            optionalInt: 20,
            optionalDouble: 2.5,
            optionalString: 'world',
            optionalBool: false,
            optionalDuration: Duration(seconds: 10),
            optionalColor: Color(0xFFFF0000),
            optionalBorderSide: BorderSide(width: 3),
            optionalTheme: EmptyTheme(),
            optionalThemeExtension: EmptyThemeExtension(),
            optionalLerpableWithOptionalResult: null,
          );

          const themeWithValue = ComplexTheme(
            requiredInt: 30,
            requiredDouble: 3.5,
            requiredString: 'goodbye',
            requiredBool: false,
            requiredDuration: Duration(seconds: 15),
            requiredColor: Color(0xFF00FF00),
            requiredBorderSide: BorderSide(width: 4),
            requiredTheme: EmptyTheme(),
            requiredThemeExtension: EmptyThemeExtension(),
            optionalInt: 40,
            optionalDouble: 4.5,
            optionalString: 'universe',
            optionalBool: true,
            optionalDuration: Duration(seconds: 20),
            optionalColor: Color(0xFF00FFFF),
            optionalBorderSide: BorderSide(width: 5),
            optionalTheme: EmptyTheme(),
            optionalThemeExtension: EmptyThemeExtension(),
            optionalLerpableWithOptionalResult: LerpableWithOptionalResult(8),
          );

          final result = ComplexTheme.lerp(themeWithNull, themeWithValue, 0.5);

          expect(result, isNotNull);
          // When lerp is called on null with ?.lerp, it returns null
          expect(result!.optionalLerpableWithOptionalResult, isNull);
        },
      );
    });

    group('equality', () {
      test('same values are equal', () {
        const theme1 = ComplexTheme(
          requiredInt: 10,
          requiredDouble: 1.5,
          requiredString: 'test',
          requiredBool: true,
          requiredDuration: Duration(seconds: 5),
          requiredColor: Color(0xFF0000FF),
          requiredBorderSide: BorderSide(width: 2),
          requiredTheme: EmptyTheme(),
          requiredThemeExtension: EmptyThemeExtension(),
          optionalInt: null,
          optionalDouble: null,
          optionalString: null,
          optionalBool: null,
          optionalDuration: null,
          optionalColor: null,
          optionalBorderSide: null,
          optionalTheme: null,
          optionalThemeExtension: null,
          optionalLerpableWithOptionalResult: null,
        );

        const theme2 = ComplexTheme(
          requiredInt: 10,
          requiredDouble: 1.5,
          requiredString: 'test',
          requiredBool: true,
          requiredDuration: Duration(seconds: 5),
          requiredColor: Color(0xFF0000FF),
          requiredBorderSide: BorderSide(width: 2),
          requiredTheme: EmptyTheme(),
          requiredThemeExtension: EmptyThemeExtension(),
          optionalInt: null,
          optionalDouble: null,
          optionalString: null,
          optionalBool: null,
          optionalDuration: null,
          optionalColor: null,
          optionalBorderSide: null,
          optionalTheme: null,
          optionalThemeExtension: null,
          optionalLerpableWithOptionalResult: null,
        );

        expect(theme1, equals(theme2));
        expect(theme1.hashCode, equals(theme2.hashCode));
      });

      test('different values are not equal', () {
        expect(themeA == themeB, isFalse);
        expect(themeA.hashCode == themeB.hashCode, isFalse);
      });

      test('not equal to different type', () {
        expect(themeA == Object(), isFalse);
      });

      test('different optional values affect equality', () {
        final theme1 = themeA.copyWith(optionalInt: 100);
        final theme2 = themeA.copyWith(optionalInt: 200);
        expect(theme1 == theme2, isFalse);
      });
    });
  });

  group('ComplexThemeInternal', () {
    test('can be instantiated with custom constructor', () {
      final theme = ComplexThemeInternal.defaults();
      expect(theme, isA<ComplexThemeInternal>());
      expect(theme.requiredInt, equals(0));
      expect(theme.requiredDouble, equals(0.0));
      expect(theme.requiredString, equals(''));
      expect(theme.requiredBool, isFalse);
      expect(theme.ignoredField, equals('defaults'));
    });

    test('canMerge returns true', () {
      final theme = ComplexThemeInternal.defaults();
      expect(theme.canMerge, isTrue);
    });

    test('lerp works with custom constructor', () {
      final themeA = ComplexThemeInternal.defaults();
      final themeB = ComplexThemeInternal.defaults();
      final result = ComplexThemeInternal.lerp(themeA, themeB, 0.5);
      expect(result, isNotNull);
      expect(result, isA<ComplexThemeInternal>());
    });

    test('copyWith works with custom constructor', () {
      final theme = ComplexThemeInternal.defaults();
      final copied = theme.copyWith(requiredInt: 42);
      expect(copied.requiredInt, equals(42));
      expect(copied.requiredDouble, equals(theme.requiredDouble));
    });

    test('merge works with custom constructor', () {
      final themeA = ComplexThemeInternal.defaults();
      final themeB = ComplexThemeInternal.defaults().copyWith(requiredInt: 100);
      final merged = themeA.merge(themeB);
      expect(merged.requiredInt, equals(100));
    });
  });
}
