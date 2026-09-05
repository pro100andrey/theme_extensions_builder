import 'package:test/test.dart';

import '../theme_gen/lookup_theme.dart';

void main() {
  const a = LookupTheme(
    curve: Curve(0),
    settings: Settings(1),
    optionalSettings: Settings(1),
    flags: Flags(1),
    clamped: Clamped(1),
    unrelated: Unrelated(1),
    narrowed: 1,
  );

  const b = LookupTheme(
    curve: Curve(10),
    settings: Settings(2),
    optionalSettings: Settings(2),
    flags: Flags(2),
    clamped: Clamped(2),
    unrelated: Unrelated(2),
    narrowed: 2,
  );

  group('LookupTheme', () {
    test('a type with an unrelated lerp method falls back to a switch', () {
      expect(LookupTheme.lerp(a, b, 0.4)!.curve, same(a.curve));
      expect(LookupTheme.lerp(a, b, 0.6)!.curve, same(b.curve));
    });

    test('a type with an unrelated merge method takes the other value', () {
      expect(a.merge(b).flags, same(b.flags));
    });

    test('an instance merge method is called for both nullabilities', () {
      final merged = a.merge(b);

      expect(merged.settings.value, 3);
      expect(merged.optionalSettings!.value, 3);
    });

    test('an uncallable lerp or merge signature is ignored', () {
      expect(LookupTheme.lerp(a, b, 0.4)!.clamped, same(a.clamped));
      expect(a.merge(b).unrelated, same(b.unrelated));
    });

    test('a field narrowed by a superclass keeps the narrowed type', () {
      expect(a.copyWith(narrowed: 7).narrowed, 7);
    });

    test('a null field on either side skips the merge method', () {
      const withoutSettings = LookupTheme(
        curve: Curve(0),
        settings: Settings(1),
        optionalSettings: null,
        flags: Flags(1),
        clamped: Clamped(1),
        unrelated: Unrelated(1),
        narrowed: 1,
      );

      expect(
        withoutSettings.merge(b).optionalSettings,
        same(b.optionalSettings),
      );
      expect(
        a.merge(withoutSettings).optionalSettings,
        same(a.optionalSettings),
      );
    });
  });
}
