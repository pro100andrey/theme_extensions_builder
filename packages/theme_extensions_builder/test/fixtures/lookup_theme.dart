import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'lookup_theme.g.theme.dart';

/// A plain class that happens to declare an unrelated `lerp` method.
class Curve {
  const Curve(this.value);

  final double value;

  double lerp(double t) => value * t;
}

/// A plain class with an instance `merge` method that also takes an
/// optional argument.
class Settings {
  const Settings(this.value);

  final int value;

  Settings merge(Settings other, {bool deep = false}) =>
      Settings(value + other.value);
}

/// A plain class that happens to declare an unrelated `merge` method.
class Flags {
  const Flags(this.value);

  final int value;

  int merge() => value;
}

/// A plain class whose `lerp` cannot be called with positional arguments only.
class Clamped {
  const Clamped(this.value);

  final double value;

  static Clamped? lerp(
    Clamped? a,
    Clamped? b,
    double t, {
    required bool clamp,
  }) => clamp ? a : b;
}

/// A plain class with a static `merge` that has nothing to do with the class.
class Unrelated {
  const Unrelated(this.value);

  final int value;

  static double merge(double a, double b) => a + b;
}

/// A plain class with a four parameter `lerp` whose last parameter is not a
/// lerp function.
class Mode {
  const Mode(this.value);

  final int value;

  static Mode? lerp(Mode? a, Mode? b, double t, int mode) => a;
}

/// A plain class with a `WidgetStateProperty` shaped `lerp` but no generic to
/// interpolate.
class Pair {
  const Pair(this.value);

  final int value;

  static Pair? lerp(
    Pair? a,
    Pair? b,
    double t,
    int? Function(int?, int?, double) lerpValue,
  ) => a;
}

/// A plain class whose `merge` cannot be called with positional arguments
/// only.
class Strict {
  const Strict(this.value);

  final int value;

  Strict merge(Strict other, {required bool deep}) => other;
}

/// Generic class whose `lerp` and `merge` are declared with the class' own
/// type parameter, so they only match once the type arguments are substituted.
class Box<T> {
  const Box(this.value);

  final T value;

  Box<T> lerp(Box<T> other, double t) => other;

  Box<T> merge(Box<T> other) => other;
}

/// Declares the `lerp` and `merge` that [Special] inherits, both returning
/// this supertype.
class Animatable {
  const Animatable(this.value);

  final int value;

  Animatable? lerp(Animatable other, double t) => other;

  Animatable merge(Animatable other) => other;
}

/// Uses the inherited `lerp` and `merge`, whose results have to be cast back.
class Special extends Animatable {
  const Special(super.value);
}

/// An instance `lerp` with an optional result on a type used non-nullably,
/// whose null the generated code has to check away.
class Soft {
  const Soft(this.value);

  final double value;

  Soft? lerp(Soft other, double t) => Soft(value + (other.value - value) * t);
}

/// A `lerp` returning something unrelated to the class it is declared on.
class Fade {
  const Fade(this.value);

  final double value;

  double? lerp(Fade? other, double t) => value;
}

/// A `merge` whose result cannot stand in for the class.
class Counter {
  const Counter(this.value);

  final int value;

  int merge(Counter other) => value + other.value;
}

/// A static `lerp` whose result cannot stand in for the class.
class Ratio {
  const Ratio(this.value);

  final double value;

  static double? lerp(Ratio? a, Ratio? b, double t) => a?.value;
}

/// Base class declaring a field that [LookupTheme]'s superclass narrows.
class Base {
  const Base({required this.narrowed});

  final num narrowed;
}

/// Narrows [Base.narrowed] to `int`, which is the declaration the generated
/// code has to use.
class Middle extends Base {
  const Middle({required this.narrowed}) : super(narrowed: narrowed);

  @override
  // Narrowing the inherited field is the point of this fixture.
  // ignore: overridden_fields
  final int narrowed;
}

const _lerpFallback = 'switches over at t = 0.5 instead of being interpolated.';

const _mergeFallback = 'is overwritten instead of being merged.';

const _curveWarning =
    'The `lerp` method of Curve has an unsupported signature, so the field '
    '`curve` $_lerpFallback';

const _flagsWarning =
    'The `merge` method of Flags has an unsupported signature, so the field '
    '`flags` $_mergeFallback';

const _clampedWarning =
    'The `lerp` method of Clamped has an unsupported signature, so the field '
    '`clamped` $_lerpFallback';

const _unrelatedWarning =
    'The `merge` method of Unrelated has an unsupported signature, so the '
    'field `unrelated` $_mergeFallback';

const _modeWarning =
    'The `lerp` method of Mode has an unsupported signature, so the field '
    '`mode` $_lerpFallback';

const _pairWarning =
    'The `lerp` method of Pair has an unsupported signature, so the field '
    '`pair` $_lerpFallback';

const _strictWarning =
    'The `merge` method of Strict has an unsupported signature, so the field '
    '`strict` $_mergeFallback';

const _fadeWarning =
    'The `lerp` method of Fade has an unsupported signature, so the field '
    '`fade` $_lerpFallback';

const _ratioWarning =
    'The `lerp` method of Ratio has an unsupported signature, so the field '
    '`ratio` $_lerpFallback';

const _counterWarning =
    'The `merge` method of Counter has an unsupported signature, so the field '
    '`counter` $_mergeFallback';

/// Theme whose field types are inspected by method lookup rather than by an
/// annotation: only [Settings] offers a signature the generator can call.
@ShouldGenerateFile(
  'goldens/lookup_theme.g.theme.dart',
  partOfCurrent: true,
  expectedLogItems: [
    _curveWarning,
    _flagsWarning,
    _clampedWarning,
    _unrelatedWarning,
    _modeWarning,
    _pairWarning,
    _strictWarning,
    _fadeWarning,
    _ratioWarning,
    _counterWarning,
  ],
)
@themeGen
final class LookupTheme extends Middle with _$LookupTheme {
  const LookupTheme({
    required this.curve,
    required this.settings,
    required this.optionalSettings,
    required this.flags,
    required this.clamped,
    required this.unrelated,
    required this.mode,
    required this.pair,
    required this.strict,
    required this.box,
    required this.special,
    required this.soft,
    required this.fade,
    required this.ratio,
    required this.counter,
    required super.narrowed,
  });

  /// Static fields are left out of the generated code, so they are not
  /// inspected either.
  static const unused = Curve(0);

  final Curve curve;
  final Settings settings;
  final Settings? optionalSettings;
  final Flags flags;
  final Clamped clamped;
  final Unrelated unrelated;
  final Mode mode;
  final Pair pair;
  final Strict strict;
  final Box<int> box;
  final Special? special;
  final Soft soft;
  final Fade? fade;
  final Ratio ratio;
  final Counter counter;

  @override
  bool get canMerge => true;

  static LookupTheme? lerp(LookupTheme? a, LookupTheme? b, double t) =>
      _$LookupTheme.lerp(a, b, t);
}
