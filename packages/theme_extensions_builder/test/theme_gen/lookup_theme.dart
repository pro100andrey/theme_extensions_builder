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

/// Theme whose field types are inspected by method lookup rather than by an
/// annotation: only [Settings] offers a signature the generator can call.
@ShouldGenerateFile('goldens/lookup_theme.g.theme.dart', partOfCurrent: true)
@themeGen
final class LookupTheme with _$LookupTheme {
  const LookupTheme({
    required this.curve,
    required this.settings,
    required this.optionalSettings,
    required this.flags,
  });

  final Curve curve;
  final Settings settings;
  final Settings? optionalSettings;
  final Flags flags;

  @override
  bool get canMerge => true;

  static LookupTheme? lerp(LookupTheme? a, LookupTheme? b, double t) =>
      _$LookupTheme.lerp(a, b, t);
}
