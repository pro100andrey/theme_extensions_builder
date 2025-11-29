import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../theme_gen/empty_theme.dart';
import 'mock.dart';

part 'complex_theme_extension.g.theme.dart';

/// Complex ThemeExtension with all possible configurations:
/// - Required non-nullable fields
/// - Optional nullable fields
/// - Custom types (BorderSide, Duration, Color, custom themes)
/// - Fields with @ignore annotation
/// - Custom constructor name
/// - Disabled BuildContext extension
/// - Custom context accessor name
@ShouldGenerateFile(
  'goldens/complex_theme_extension.g.theme.dart',
  partOfCurrent: true,
)
@ThemeExtensions(
  buildContextExtension: false,
  constructor: '_internal',
)
final class ComplexThemeExtensionNoContext
    extends ThemeExtension<ComplexThemeExtensionNoContext>
    with _$ComplexThemeExtensionNoContext {
  const ComplexThemeExtensionNoContext._internal({
    required this.requiredInt,
    required this.requiredDouble,
    required this.requiredString,
    required this.requiredBool,
    required this.requiredDuration,
    required this.requiredColor,
    required this.requiredBorderSide,
    required this.requiredTheme,
    required this.optionalInt,
    required this.optionalDouble,
    required this.optionalString,
    required this.optionalBool,
    required this.optionalDuration,
    required this.optionalColor,
    required this.optionalBorderSide,
    required this.optionalTheme,

    // ignore: unused_element_parameter
    this.ignoredField,
  });

  // Required non-nullable fields
  final int requiredInt;
  final double requiredDouble;
  final String requiredString;
  final bool requiredBool;
  final Duration requiredDuration;
  final Color requiredColor;
  final BorderSide requiredBorderSide;
  final EmptyTheme requiredTheme;

  // Optional nullable fields
  final int? optionalInt;
  final double? optionalDouble;
  final String? optionalString;
  final bool? optionalBool;
  final Duration? optionalDuration;
  final Color? optionalColor;
  final BorderSide? optionalBorderSide;
  final EmptyTheme? optionalTheme;

  // Ignored field - should not be in generated code
  @ignore
  final String? ignoredField;
}

/// Complex ThemeExtension with custom context accessor name
@ShouldGenerateFile(
  'goldens/complex_theme_extension_custom_accessor.g.theme.dart',
  partOfCurrent: true,
)
@ThemeExtensions(
  contextAccessorName: 'myCustomTheme',
)
final class ComplexThemeExtensionCustomAccessor
    extends ThemeExtension<ComplexThemeExtensionCustomAccessor>
    with _$ComplexThemeExtensionCustomAccessor {
  const ComplexThemeExtensionCustomAccessor({
    required this.primaryColor,
    required this.secondaryColor,
    required this.spacing,
  });

  final Color primaryColor;
  final Color? secondaryColor;
  final double spacing;
}

/// ThemeExtension with mixed required and optional fields
@ShouldGenerateFile(
  'goldens/complex_theme_extension_mixed.g.theme.dart',
  partOfCurrent: true,
)
@themeExtensions
final class ComplexThemeExtensionMixed
    extends ThemeExtension<ComplexThemeExtensionMixed>
    with _$ComplexThemeExtensionMixed {
  const ComplexThemeExtensionMixed({
    required this.title,
    required this.count,
    required this.ratio,
    required this.isActive,
    required this.duration,
    required this.theme,
    // ignore: unused_element_parameter
    this.computedValue = 'computed',
  });

  final String title;
  final int? count;
  final double ratio;
  final bool? isActive;
  final Duration duration;
  final EmptyTheme? theme;

  @ignore
  final String computedValue;
}
