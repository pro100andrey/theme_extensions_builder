import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/common/fields_visitor_config.dart';

void main() {
  group('FieldsVisitorConfig', () {
    test('default config has all lookups enabled', () {
      const config = FieldsVisitorConfig();
      expect(config.includeLerpLookup, isTrue);
      expect(config.includeMergeLookup, isTrue);
    });

    test('custom config with both lookups disabled', () {
      const config = FieldsVisitorConfig(
        includeLerpLookup: false,
        includeMergeLookup: false,
      );
      expect(config.includeLerpLookup, isFalse);
      expect(config.includeMergeLookup, isFalse);
    });

    test('custom config with only lerp lookup enabled', () {
      const config = FieldsVisitorConfig(includeMergeLookup: false);
      expect(config.includeLerpLookup, isTrue);
      expect(config.includeMergeLookup, isFalse);
    });

    test('custom config with only merge lookup enabled', () {
      const config = FieldsVisitorConfig(includeLerpLookup: false);
      expect(config.includeLerpLookup, isFalse);
      expect(config.includeMergeLookup, isTrue);
    });

    test('equality works correctly', () {
      const config1 = FieldsVisitorConfig();
      const config2 = FieldsVisitorConfig();
      const config3 = FieldsVisitorConfig(
        includeLerpLookup: false,
        includeMergeLookup: false,
      );

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });

    test('hashCode is consistent for equal configs', () {
      const config1 = FieldsVisitorConfig();
      const config2 = FieldsVisitorConfig();
      const config3 = FieldsVisitorConfig();

      // Equal configs must have equal hashCodes
      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1.hashCode, equals(config3.hashCode));
    });

    test('hashCode is deterministic', () {
      const config = FieldsVisitorConfig(
        includeLerpLookup: false,
        includeMergeLookup: false,
      );

      // Same config should always return the same hashCode
      expect(config.hashCode, equals(config.hashCode));

      // Different instance with same values should have same hashCode
      const config2 = FieldsVisitorConfig(
        includeLerpLookup: false,
        includeMergeLookup: false,
      );
      expect(config.hashCode, equals(config2.hashCode));
    });

    test('toString provides readable output', () {
      const config = FieldsVisitorConfig(includeLerpLookup: false);

      final string = config.toString();
      expect(string, contains('FieldsVisitorConfig'));
      expect(string, contains('includeLerpLookup: false'));
      expect(string, contains('includeMergeLookup: true'));
    });
  });
}
