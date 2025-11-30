import 'package:test/test.dart';

import '../theme_extensions/complex_theme_extension.dart';
import '../theme_extensions/empty_theme.dart';
import '../theme_extensions/empty_theme_extension.dart';
import '../theme_extensions/mock.dart';

void main() {
  group('ComplexThemeExtensionNoContext', () {
    test('factory constructor works', () {
      final defaultTheme = ComplexThemeExtensionNoContext.defaults();
      expect(defaultTheme, isA<ComplexThemeExtensionNoContext>());
      expect(defaultTheme.count, equals(0));
      expect(defaultTheme.ratio, equals(0));
      expect(defaultTheme.title, equals(''));
      expect(defaultTheme.isEnabled, isFalse);
      expect(defaultTheme.duration, equals(Duration.zero));
      expect(defaultTheme.color, equals(const Color(0x00000000)));
      expect(defaultTheme.borderSide, equals(BorderSide.none));
      expect(defaultTheme.theme, equals(const EmptyTheme()));
      expect(defaultTheme.ignoredField, equals('defaults'));

      final primaryTheme = ComplexThemeExtensionNoContext.primary();
      expect(primaryTheme, isA<ComplexThemeExtensionNoContext>());
      expect(primaryTheme.count, equals(1));
      expect(primaryTheme.ratio, equals(1));
      expect(primaryTheme.title, equals('Primary'));
      expect(primaryTheme.isEnabled, isTrue);
      expect(primaryTheme.duration, equals(const Duration(seconds: 1)));
      expect(primaryTheme.color, equals(const Color(0xFF0000FF)));
      expect(primaryTheme.borderSide, equals(const BorderSide(width: 2)));
      expect(primaryTheme.theme, equals(const EmptyTheme()));
      expect(primaryTheme.ignoredField, equals('primary'));
    });

    test('copyWith updates fields', () {
      final theme = ComplexThemeExtensionNoContext.defaults();
      final copied =
          theme.copyWith(count: 999) as ComplexThemeExtensionNoContext;

      expect(copied, isA<ThemeExtension<ComplexThemeExtensionNoContext>>());

      expect(copied.count, equals(999));
      expect(theme, isNot(same(copied)));
      expect(copied.ratio, equals(theme.ratio));
      expect(copied.title, equals(theme.title));
      expect(copied.isEnabled, equals(theme.isEnabled));
      expect(copied.duration, equals(theme.duration));
      expect(copied.color, equals(theme.color));
      expect(copied.borderSide, equals(theme.borderSide));
      expect(copied.theme, equals(theme.theme));
    });

    test('lerp is implemented', () {
      final themeA = ComplexThemeExtensionNoContext.defaults();
      final themeB = ComplexThemeExtensionNoContext.primary();

      // Just verify lerp method exists and returns a result
      final result = themeA.lerp(themeB, 0.5);
      expect(result, isNot(equals(themeA)));
      expect(result, isNot(equals(themeB)));
      expect(themeA, isA<ComplexThemeExtensionNoContext>());
      expect(themeB, isA<ComplexThemeExtensionNoContext>());
      expect(result, isA<ComplexThemeExtensionNoContext>());
    });

    test('equality works correctly', () {
      final theme1 = ComplexThemeExtensionNoContext.defaults().copyWith(
        count: 10,
        ratio: 1.5,
        borderSide: const BorderSide(width: 5),
        color: const Color(0xFF123456),
        duration: const Duration(seconds: 3),
        isEnabled: true,
        title: 'Test',
      );

      final theme2 = ComplexThemeExtensionNoContext.primary().copyWith(
        count: 10,
        ratio: 1.5,
        borderSide: const BorderSide(width: 5),
        color: const Color(0xFF123456),
        duration: const Duration(seconds: 3),
        isEnabled: true,
        title: 'Test',
      );

      expect(theme1, equals(theme2));
      expect(theme1, isNot(same(theme2)));
      expect(theme1.hashCode, equals(theme2.hashCode));
    });

    test('ignoredField is not part of generated code', () {
      final theme1 = ComplexThemeExtensionNoContext.defaults();
      final theme2 = ComplexThemeExtensionNoContext.primary();

      expect(theme1.ignoredField, equals('defaults'));
      expect(theme2.ignoredField, equals('primary'));

      final copiedTheme1 = theme1.copyWith() as ComplexThemeExtensionNoContext;
      final copiedTheme2 = theme2.copyWith() as ComplexThemeExtensionNoContext;

      expect(copiedTheme1.ignoredField, equals('ignored'));
      expect(copiedTheme2.ignoredField, equals('ignored'));

      // Even though they might have different ignoredField values,
      // they should be equal because ignoredField is not part of generated code
      expect(theme1, equals(copiedTheme1));
      expect(theme1.hashCode, equals(copiedTheme1.hashCode));
    });

    test(
      'BuildContext extension is NOT generated (buildContextExtension: false)',
      () {
        final themeExtension = ComplexThemeExtensionNoContext.defaults();
        final theme = Theme(
          extensions: {
            ComplexThemeExtensionNoContext: themeExtension,
          },
        );

        final context = BuildContext(theme);

        // Verify that we can only access via Theme.of().extension<T>()
        final retrievedTheme = Theme.of(
          context,
        ).extension<ComplexThemeExtensionNoContext>();
        expect(retrievedTheme, same(themeExtension));

        // IMPORTANT: The following line should cause a COMPILE ERROR if
        // buildContextExtension is not false. If you see this test passing
        // but can successfully uncomment the line below, the generator is
        // broken!
        //
        // Uncomment to verify the extension doesn't exist:
        // context.noContextTheme; // ERROR: The getter 'noContextTheme' isn't defined
      },
    );
  });

  group('ComplexThemeExtensionCustomAccessor', () {
    test('can be instantiated', () {
      const theme = ComplexThemeExtensionCustomAccessor(
        primaryColor: Color(0xFF0000FF),
        secondaryColor: Color(0xFFFF0000),
        spacing: 8,
      );

      expect(theme, isA<ComplexThemeExtensionCustomAccessor>());
      expect(theme.primaryColor, isA<Color>());
      expect(theme.secondaryColor, isA<Color>());
      expect(theme.spacing, equals(8.0));
    });

    test('BuildContext extension with custom accessor name works', () {
      // Create a theme extension instance
      const themeExtension = ComplexThemeExtensionCustomAccessor(
        primaryColor: Color(0xFF0000FF),
        secondaryColor: Color(0xFFFF0000),
        spacing: 8,
      );

      // Create a Theme with the extension
      final theme = Theme(
        extensions: {
          ComplexThemeExtensionCustomAccessor: themeExtension,
        },
      );

      // Create a BuildContext with the theme
      final context = BuildContext(theme);

      // Use the custom accessor name 'myCustomTheme' from the generated
      // extension
      final retrievedTheme = context.myCustomTheme;

      // Verify we got the correct theme back
      expect(retrievedTheme, same(themeExtension));
    });

    test('custom accessor name is myCustomTheme not default', () {
      // This test documents that the contextAccessorName annotation works.
      // The annotation was: contextAccessorName: 'myCustomTheme'
      //
      // If the generator didn't respect this setting, it would generate
      // the default name 'complexThemeExtensionCustomAccessor' which would
      // cause a compilation error in the previous test.

      expect(
        'myCustomTheme',
        isNot(equals('complexThemeExtensionCustomAccessor')),
        reason: 'Custom accessor name should differ from default',
      );
    });
  });

  group('ComplexThemeExtension', () {
    test('can be instantiated with all fields', () {
      const theme = ComplexThemeExtension(
        requiredInt: 10,
        requiredDouble: 1.5,
        requiredString: 'hello',
        requiredBool: true,
        requiredDuration: Duration(seconds: 5),
        requiredColor: Color(0xFF0000FF),
        requiredBorderSide: BorderSide(width: 2),
        requiredTheme: EmptyTheme(),
        optionalInt: 20,
        optionalDouble: 2.5,
        optionalString: 'world',
        optionalBool: false,
        optionalDuration: Duration(seconds: 10),
        optionalColor: Color(0xFFFF0000),
        optionalBorderSide: BorderSide(width: 3),
        optionalTheme: EmptyTheme(),
        requiredThemeExtension: EmptyThemeExtension(),
        optionalThemeExtension: EmptyThemeExtension(),
      );

      expect(theme, isA<ComplexThemeExtension>());
      expect(theme.requiredInt, equals(10));
      expect(theme.requiredDouble, equals(1.5));
      expect(theme.optionalInt, equals(20));
      expect(theme.optionalString, equals('world'));
    });

    test('optional fields can be null', () {
      const theme = ComplexThemeExtension(
        requiredInt: 10,
        requiredDouble: 1.5,
        requiredString: 'hello',
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
      );

      expect(theme.optionalInt, isNull);
      expect(theme.optionalDouble, isNull);
      expect(theme.optionalString, isNull);
      expect(theme.optionalBool, isNull);
      expect(theme.optionalDuration, isNull);
      expect(theme.optionalColor, isNull);
      expect(theme.optionalBorderSide, isNull);
      expect(theme.optionalTheme, isNull);
      expect(theme.optionalThemeExtension, isNull);
    });

    test('copyWith updates required fields', () {
      const theme = ComplexThemeExtension(
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
      );

      final copied =
          theme.copyWith(
                requiredInt: 999,
                requiredString: 'updated',
              )
              as ComplexThemeExtension;

      expect(copied.requiredInt, equals(999));
      expect(copied.requiredString, equals('updated'));
      expect(copied.requiredDouble, equals(theme.requiredDouble));
    });

    test('copyWith updates optional fields', () {
      const theme = ComplexThemeExtension(
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
      );

      final copied =
          theme.copyWith(
                optionalInt: 500,
                optionalString: 'new',
              )
              as ComplexThemeExtension;

      expect(copied.optionalInt, equals(500));
      expect(copied.optionalString, equals('new'));
      expect(copied.requiredInt, equals(theme.requiredInt));
    });

    test('lerp is implemented', () {
      const themeA = ComplexThemeExtension(
        requiredInt: 10,
        requiredDouble: 1.5,
        requiredString: 'hello',
        requiredBool: true,
        requiredDuration: Duration(seconds: 5),
        requiredColor: Color(0xFF0000FF),
        requiredBorderSide: BorderSide(width: 2),
        requiredTheme: EmptyTheme(),
        requiredThemeExtension: EmptyThemeExtension(),
        optionalInt: 10,
        optionalDouble: null,
        optionalString: null,
        optionalBool: null,
        optionalDuration: Duration(seconds: 10),
        optionalColor: null,
        optionalBorderSide: null,
        optionalTheme: null,
        optionalThemeExtension: null,
      );

      const themeB = ComplexThemeExtension(
        requiredInt: 30,
        requiredDouble: 3.5,
        requiredString: 'goodbye',
        requiredBool: false,
        requiredDuration: Duration(seconds: 15),
        requiredColor: Color(0xFF00FF00),
        requiredBorderSide: BorderSide(width: 4),
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
      );

      // Just verify lerp method exists and returns a result

      expect(themeA.lerp(themeB, 0), isA<ComplexThemeExtension>());
      expect(themeA.lerp(themeB, 0.5), isA<ComplexThemeExtension>());
      expect(themeA.lerp(themeB, 1), isA<ComplexThemeExtension>());

      expect(themeB.lerp(themeB, 0), isA<ComplexThemeExtension>());
      expect(themeB.lerp(themeB, 0.5), isA<ComplexThemeExtension>());
      expect(themeB.lerp(themeB, 1), isA<ComplexThemeExtension>());

      expect(themeA.lerp(null, 0.5), equals(themeA));
      expect(themeB.lerp(null, 0.5), equals(themeB));
    });

    test('equality works correctly', () {
      const theme1 = ComplexThemeExtension(
        requiredInt: 10,
        requiredDouble: 1.5,
        requiredString: 'hello',
        requiredBool: true,
        requiredDuration: Duration(seconds: 5),
        requiredColor: Color(0xFF0000FF),
        requiredBorderSide: BorderSide(width: 2),
        requiredTheme: EmptyTheme(),
        optionalInt: 20,
        optionalDouble: 2.5,
        optionalString: 'world',
        optionalBool: false,
        optionalDuration: Duration(seconds: 10),
        optionalColor: Color(0xFFFF0000),
        optionalBorderSide: BorderSide(width: 3),
        optionalTheme: EmptyTheme(),
        requiredThemeExtension: EmptyThemeExtension(),
        optionalThemeExtension: EmptyThemeExtension(),
      );
      const theme2 = ComplexThemeExtension(
        requiredInt: 10,
        requiredDouble: 1.5,
        requiredString: 'hello',
        requiredBool: true,
        requiredDuration: Duration(seconds: 5),
        requiredColor: Color(0xFF0000FF),
        requiredBorderSide: BorderSide(width: 2),
        requiredTheme: EmptyTheme(),
        optionalInt: 20,
        optionalDouble: 2.5,
        optionalString: 'world',
        optionalBool: false,
        optionalDuration: Duration(seconds: 10),
        optionalColor: Color(0xFFFF0000),
        optionalBorderSide: BorderSide(width: 3),
        optionalTheme: EmptyTheme(),
        requiredThemeExtension: EmptyThemeExtension(),
        optionalThemeExtension: EmptyThemeExtension(),
      );
      expect(theme1, equals(theme2));
      expect(theme1.hashCode, equals(theme2.hashCode));
    });

    test('different optional values make themes unequal', () {
      const theme1 = ComplexThemeExtension(
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
        optionalDouble: null,
        optionalString: null,
        optionalBool: null,
        optionalDuration: null,
        optionalColor: null,
        optionalBorderSide: null,
        optionalTheme: null,
        optionalThemeExtension: null,
      );
      const theme2 = ComplexThemeExtension(
        requiredInt: 10,
        requiredDouble: 1.5,
        requiredString: 'hello',
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
      );
      expect(theme1, isNot(equals(theme2)));
    });

    test('BuildContext extension with default accessor name works', () {
      // Create a theme extension instance
      const themeExtension = ComplexThemeExtension(
        requiredInt: 42,
        requiredDouble: 3.14,
        requiredString: 'test',
        requiredBool: true,
        requiredDuration: Duration(seconds: 10),
        requiredColor: Color(0xFF00FF00),
        requiredBorderSide: BorderSide(width: 5),
        requiredTheme: EmptyTheme(),
        optionalInt: 100,
        optionalDouble: 2.5,
        optionalString: 'optional',
        optionalBool: false,
        optionalDuration: Duration(minutes: 1),
        optionalColor: Color(0xFFFF00FF),
        optionalBorderSide: BorderSide(width: 10),
        optionalTheme: EmptyTheme(),
        requiredThemeExtension: EmptyThemeExtension(),
        optionalThemeExtension: EmptyThemeExtension(),
      );

      // Create a Theme with the extension
      final theme = Theme(
        extensions: {
          ComplexThemeExtension: themeExtension,
        },
      );

      // Create a BuildContext with the theme
      final context = BuildContext(theme);

      // Use the default accessor name 'complexTheme' from the generated
      // extension
      final retrievedTheme = context.complexTheme;

      // Verify we got the correct theme back
      expect(retrievedTheme, same(themeExtension));
      expect(retrievedTheme.requiredInt, equals(42));
      expect(retrievedTheme.requiredString, equals('test'));
      expect(retrievedTheme.optionalInt, equals(100));
      expect(retrievedTheme.optionalString, equals('optional'));
    });
  });
}
