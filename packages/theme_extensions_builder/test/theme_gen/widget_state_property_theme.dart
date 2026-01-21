import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'widget_state_property_theme.g.theme.dart';

/// Empty Theme - testing edge case with no fields
@ShouldGenerateFile(
  'goldens/widget_state_property_theme.g.theme.dart',
  partOfCurrent: true,
)
@themeGen
final class WidgetStatePropertyTheme with _$WidgetStatePropertyTheme {
  const WidgetStatePropertyTheme();

  @override
  bool get canMerge => true;

  static WidgetStatePropertyTheme? lerp(
    WidgetStatePropertyTheme? a,
    WidgetStatePropertyTheme? b,
    double t,
  ) => _$WidgetStatePropertyTheme.lerp(a, b, t);
}
