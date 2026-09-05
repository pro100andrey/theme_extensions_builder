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

const _curveWarning =
    'The `lerp` method of Curve has an unsupported signature, so the field '
    '`curve` is left out of `lerp`.';

const _flagsWarning =
    'The `merge` method of Flags has an unsupported signature, so the field '
    '`flags` is left out of `merge`.';

const _clampedWarning =
    'The `lerp` method of Clamped has an unsupported signature, so the field '
    '`clamped` is left out of `lerp`.';

const _unrelatedWarning =
    'The `merge` method of Unrelated has an unsupported signature, so the '
    'field `unrelated` is left out of `merge`.';

const _modeWarning =
    'The `lerp` method of Mode has an unsupported signature, so the field '
    '`mode` is left out of `lerp`.';

const _pairWarning =
    'The `lerp` method of Pair has an unsupported signature, so the field '
    '`pair` is left out of `lerp`.';

const _strictWarning =
    'The `merge` method of Strict has an unsupported signature, so the field '
    '`strict` is left out of `merge`.';

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
    required super.narrowed,
  });

  final Curve curve;
  final Settings settings;
  final Settings? optionalSettings;
  final Flags flags;
  final Clamped clamped;
  final Unrelated unrelated;
  final Mode mode;
  final Pair pair;
  final Strict strict;

  @override
  bool get canMerge => true;

  static LookupTheme? lerp(LookupTheme? a, LookupTheme? b, double t) =>
      _$LookupTheme.lerp(a, b, t);
}
