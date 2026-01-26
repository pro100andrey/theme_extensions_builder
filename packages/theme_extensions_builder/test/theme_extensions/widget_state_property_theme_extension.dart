import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'mock.dart';

part 'widget_state_property_theme_extension.g.theme.dart';

/// Empty ThemeExtension - testing edge case with no fields
@ShouldGenerateFile(
  'goldens/widget_state_property_theme_extension.g.theme.dart',
  partOfCurrent: true,
)
@themeExtensions
final class WidgetStatePropertyThemeExtension
    extends ThemeExtension<WidgetStatePropertyThemeExtension>
    with _$WidgetStatePropertyThemeExtension {
  const WidgetStatePropertyThemeExtension({
    required this.fontSize,
    required this.color,
    required this.animationDuration,

    this.optionalFontSize,
    this.optionalColor,
    this.optionalAnimationDuration,
  });

  final WidgetStateProperty<double?> fontSize;
  final WidgetStateProperty<Color?> color;
  final WidgetStateProperty<Duration?> animationDuration;

  final WidgetStateProperty<double?>? optionalFontSize;
  final WidgetStateProperty<Color?>? optionalColor;
  final WidgetStateProperty<Duration?>? optionalAnimationDuration;
}
