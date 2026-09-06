import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'flutter_stubs.dart';

part 'widget_state_property_theme.g.theme.dart';

const _fallback = 'switches over at t = 0.5 instead of being interpolated.';

const _labelWarning =
    'WidgetStateProperty<String?> cannot be interpolated: `String` has no '
    'static `String? lerp(String?, String?, double)` for '
    '`WidgetStateProperty.lerp` to call, so the field `label` $_fallback';

const _sideWarning =
    'WidgetStateProperty<BorderSide?> cannot be interpolated: `BorderSide` '
    'has no static `BorderSide? lerp(BorderSide?, BorderSide?, double)` for '
    '`WidgetStateProperty.lerp` to call, so the field `side` $_fallback';

const _nestedWarning =
    'WidgetStateProperty<WidgetStateProperty<Color>?> cannot be '
    'interpolated: `WidgetStateProperty<Color>` has no static '
    '`WidgetStateProperty<Color>? lerp(WidgetStateProperty<Color>?, '
    'WidgetStateProperty<Color>?, double)` for `WidgetStateProperty.lerp` to '
    'call, so the field `nested` $_fallback';

/// Theme covering the `WidgetStateProperty` shapes: `double` and `Duration`
/// generics have their own lerp functions, anything else needs a static
/// `lerp` on the generic that accepts nulls, and a generic without one is
/// reported once, whatever `lerp` it does declare.
@ShouldGenerateFile(
  'goldens/widget_state_property_theme.g.theme.dart',
  partOfCurrent: true,
  expectedLogItems: [_labelWarning, _sideWarning, _nestedWarning],
)
@themeGen
final class WidgetStatePropertyTheme with _$WidgetStatePropertyTheme {
  const WidgetStatePropertyTheme({
    required this.color,
    required this.width,
    required this.duration,
    required this.optionalColor,
    required this.optionalWidth,
    required this.optionalDuration,
    required this.label,
    required this.side,
    required this.nested,
  });

  final WidgetStateProperty<Color?> color;
  final WidgetStateProperty<double?> width;
  final WidgetStateProperty<Duration?> duration;

  final WidgetStateProperty<Color?>? optionalColor;
  final WidgetStateProperty<double?>? optionalWidth;
  final WidgetStateProperty<Duration?>? optionalDuration;

  /// `String` has no static lerp, so this one cannot be interpolated.
  final WidgetStateProperty<String?> label;

  /// `BorderSide.lerp` takes no nulls, so it cannot be passed on either.
  final WidgetStateProperty<BorderSide?> side;

  /// The inner generic is not nullable, which is a fallback here rather than
  /// the error it is on a field: the message would point at the wrong type.
  final WidgetStateProperty<WidgetStateProperty<Color>?> nested;

  @override
  bool get canMerge => true;

  static WidgetStatePropertyTheme? lerp(
    WidgetStatePropertyTheme? a,
    WidgetStatePropertyTheme? b,
    double t,
  ) => _$WidgetStatePropertyTheme.lerp(a, b, t);
}
