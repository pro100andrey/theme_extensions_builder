import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/common/fields_visitor_config.dart';

void main() {
  group('FieldsVisitorConfig', () {
    test('default config looks up merge methods', () {
      const config = FieldsVisitorConfig();

      expect(config.includeMergeLookup, isTrue);
    });

    test('merge lookup can be disabled', () {
      const config = FieldsVisitorConfig(includeMergeLookup: false);

      expect(config.includeMergeLookup, isFalse);
    });

    test('equality works correctly', () {
      const config1 = FieldsVisitorConfig();
      const config2 = FieldsVisitorConfig();
      const config3 = FieldsVisitorConfig(includeMergeLookup: false);

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });

    test('equal configs have equal hashCodes', () {
      const config1 = FieldsVisitorConfig();
      const config2 = FieldsVisitorConfig();
      const config3 = FieldsVisitorConfig(includeMergeLookup: false);

      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1.hashCode, isNot(equals(config3.hashCode)));
    });

    test('toString provides readable output', () {
      const config = FieldsVisitorConfig(includeMergeLookup: false);

      expect(
        config.toString(),
        'FieldsVisitorConfig(includeMergeLookup: false)',
      );
    });
  });
}
