import 'package:test/test.dart';
import 'package:theme_extensions_builder_annotation/src/utils.dart';

void main() {
  group(r'lerpDouble$', () {
    test('returns a when a and b are equal', () {
      expect(lerpDouble$(1.0, 1.0, 0.5), 1.0);
    });

    test('returns a when a and b are both NaN', () {
      expect(lerpDouble$(double.nan, double.nan, 0.5), isNaN);
    });

    test('interpolates between two numbers', () {
      expect(lerpDouble$(0.0, 10.0, 0.5), 5.0);
      expect(lerpDouble$(0.0, 10.0, 0), 0.0);
      expect(lerpDouble$(0.0, 10.0, 1), 10.0);
    });

    test('handles nulls as 0.0', () {
      expect(lerpDouble$(null, 10.0, 0.5), 5.0);
      expect(lerpDouble$(10.0, null, 0.5), 5.0);
      expect(lerpDouble$(null, null, 0.5), isNull);
    });

    test('throws assertion error for non-finite values', () {
      expect(
        () => lerpDouble$(double.infinity, 10.0, 0.5),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => lerpDouble$(10.0, double.infinity, 0.5),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => lerpDouble$(10.0, 20.0, double.infinity),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group(r'lerpDuration$', () {
    test('returns a when a and b are equal', () {
      const duration = Duration(seconds: 1);
      expect(lerpDuration$(duration, duration, 0.5), duration);
    });

    test('interpolates between two durations', () {
      const a = Duration.zero;
      const b = Duration(seconds: 10);
      expect(lerpDuration$(a, b, 0.5), const Duration(seconds: 5));
      expect(lerpDuration$(a, b, 0), a);
      expect(lerpDuration$(a, b, 1), b);
    });

    test('handles nulls as Duration.zero', () {
      const b = Duration(seconds: 10);
      expect(lerpDuration$(null, b, 0.5), const Duration(seconds: 5));
      expect(lerpDuration$(b, null, 0.5), const Duration(seconds: 5));
      expect(lerpDuration$(null, null, 0.5), isNull);
    });

    test('throws assertion error for non-finite t', () {
      expect(
        () => lerpDuration$(
          Duration.zero,
          const Duration(seconds: 1),
          double.infinity,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
