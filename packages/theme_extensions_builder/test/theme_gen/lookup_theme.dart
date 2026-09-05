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

/// Theme whose field types are inspected by method lookup rather than by an
/// annotation: only [Settings] offers a signature the generator can call.
@ShouldGenerateFile('goldens/lookup_theme.g.theme.dart', partOfCurrent: true)
@themeGen
final class LookupTheme extends Middle with _$LookupTheme {
  const LookupTheme({
    required this.curve,
    required this.settings,
    required this.optionalSettings,
    required this.flags,
    required this.clamped,
    required this.unrelated,
    required super.narrowed,
  });

  final Curve curve;
  final Settings settings;
  final Settings? optionalSettings;
  final Flags flags;
  final Clamped clamped;
  final Unrelated unrelated;

  @override
  bool get canMerge => true;

  static LookupTheme? lerp(LookupTheme? a, LookupTheme? b, double t) =>
      _$LookupTheme.lerp(a, b, t);
}
