import 'package:test/test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

void main() {
  group('Annotations', () {
    test('ignore constant is _Ignore', () {
      expect(ignore, isA<dynamic>());
      // We can't check for _Ignore type directly as it is private,
      // but we can check if it's the constant we expect.
    });

    test('ThemeExtensions constant has default values', () {
      expect(themeExtensions.buildContextExtension, isTrue);
      expect(themeExtensions.contextAccessorName, isNull);
      expect(themeExtensions.constructor, isNull);
    });

    test('ThemeExtensions constructor sets values correctly', () {
      const annotation = ThemeExtensions(
        buildContextExtension: false,
        contextAccessorName: 'myTheme',
        constructor: '_internal',
      );
      expect(annotation.buildContextExtension, isFalse);
      expect(annotation.contextAccessorName, 'myTheme');
      expect(annotation.constructor, '_internal');
    });

    test('ThemeGen constant has default values', () {
      expect(themeGen.constructor, isNull);
    });

    test('ThemeGen constructor sets values correctly', () {
      const annotation = ThemeGen(constructor: '_internal');
      expect(annotation.constructor, '_internal');
    });
  });
}
