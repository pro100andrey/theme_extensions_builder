import 'package:test/test.dart';

import '../fixtures/lookup_theme.dart';

void main() {
  const a = LookupTheme(
    curve: Curve(0),
    settings: Settings(1),
    optionalSettings: Settings(1),
    flags: Flags(1),
    clamped: Clamped(1),
    unrelated: Unrelated(1),
    mode: Mode(1),
    pair: Pair(1),
    strict: Strict(1),
    box: Box(1),
    special: Special(1),
    soft: Soft(1),
    fade: Fade(1),
    ratio: Ratio(1),
    counter: Counter(1),
    narrowed: 1,
  );

  const b = LookupTheme(
    curve: Curve(10),
    settings: Settings(2),
    optionalSettings: Settings(2),
    flags: Flags(2),
    clamped: Clamped(2),
    unrelated: Unrelated(2),
    mode: Mode(2),
    pair: Pair(2),
    strict: Strict(2),
    box: Box(2),
    special: Special(2),
    soft: Soft(3),
    fade: Fade(2),
    ratio: Ratio(2),
    counter: Counter(2),
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
      expect(LookupTheme.lerp(a, b, 0.4)!.mode, same(a.mode));
      expect(LookupTheme.lerp(a, b, 0.4)!.pair, same(a.pair));
      expect(a.merge(b).unrelated, same(b.unrelated));
      expect(a.merge(b).strict, same(b.strict));
      expect(a.merge(b).counter, same(b.counter));
    });

    test('a generic type resolves its methods through the instantiation', () {
      // Box.lerp returns `other`, which the t < 0.5 fallback would not do
      // at 0.4.
      expect(LookupTheme.lerp(a, b, 0.4)!.box, same(b.box));
    });

    test('an inherited lerp returning a supertype is cast back', () {
      // Animatable.lerp also returns `other`, so the fallback would hand back
      // a.special here. The cast is what keeps the result a Special.
      final lerped = LookupTheme.lerp(a, b, 0.4)!.special;

      expect(lerped, same(b.special));
      expect(lerped, isA<Special>());
      expect(a.merge(b).special, isA<Special>());
    });

    test('an instance lerp with an optional result is null checked', () {
      expect(LookupTheme.lerp(a, b, 0.5)!.soft.value, 2);
    });

    test('a lerp returning an unrelated type is ignored', () {
      expect(LookupTheme.lerp(a, b, 0.4)!.fade, same(a.fade));
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
        mode: Mode(1),
        pair: Pair(1),
        strict: Strict(1),
        box: Box(1),
        special: Special(1),
        soft: Soft(1),
        fade: Fade(1),
        ratio: Ratio(1),
        counter: Counter(1),
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
