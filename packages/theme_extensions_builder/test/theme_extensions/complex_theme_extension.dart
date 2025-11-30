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
  'goldens/complex_theme_extension_no_context.g.theme.dart',
  partOfCurrent: true,
)
@ThemeExtensions(
  buildContextExtension: false,
  contextAccessorName: 'noContextTheme',
  constructor: '_internal',
)
final class ComplexThemeExtensionNoContext
    extends ThemeExtension<ComplexThemeExtensionNoContext>
    with _$ComplexThemeExtensionNoContext {
  const ComplexThemeExtensionNoContext._internal({
    required this.count,
    required this.ratio,
    required this.title,
    required this.isEnabled,
    required this.duration,
    required this.color,
    required this.borderSide,
    required this.theme,

    // ignore: unused_element_parameter
    this.ignoredField = 'ignored',
  });

  factory ComplexThemeExtensionNoContext.defaults() =>
      const ComplexThemeExtensionNoContext._internal(
        count: 0,
        ratio: 0,
        title: '',
        isEnabled: false,
        duration: Duration.zero,
        color: Color(0x00000000),
        borderSide: BorderSide.none,
        theme: EmptyTheme(),
        ignoredField: 'defaults',
      );

  factory ComplexThemeExtensionNoContext.primary() =>
      const ComplexThemeExtensionNoContext._internal(
        count: 1,
        ratio: 1,
        title: 'Primary',
        isEnabled: true,
        duration: Duration(seconds: 1),
        color: Color(0xFF0000FF),
        borderSide: BorderSide(width: 2),
        theme: EmptyTheme(),
        ignoredField: 'primary',
      );

  // Required non-nullable fields
  final int count;
  final double ratio;
  final String title;
  final bool isEnabled;
  final Duration duration;
  final Color color;
  final BorderSide borderSide;
  final EmptyTheme theme;

  // Ignored field - should not be in generated code
  @ignore
  final String ignoredField;
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

/// ThemeExtension with required and optional fields
@ShouldGenerateFile(
  'goldens/complex_theme_extension.g.theme.dart',
  partOfCurrent: true,
)
@themeExtensions
final class ComplexThemeExtension extends ThemeExtension<ComplexThemeExtension>
    with _$ComplexThemeExtension {
  const ComplexThemeExtension({
    required this.requiredInt,
    required this.requiredDouble,
    required this.requiredString,
    required this.requiredBool,
    required this.requiredDuration,
    required this.requiredColor,
    required this.requiredBorderSide,
    required this.requiredTheme,
    required this.optionalInt,
    required this.optionalString,
    required this.optionalDouble,
    required this.optionalBool,
    required this.optionalDuration,
    required this.optionalColor,
    required this.optionalBorderSide,
    required this.optionalTheme,
    // ignore: unused_element_parameter
    this.computedValue = 'computed',
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

  @ignore
  final String computedValue;
}
