import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'empty_theme.dart';
import 'empty_theme_extension.dart';
import 'mock.dart';

part 'complex_theme.g.theme.dart';

/// Complex ThemeGen with all possible configurations:
/// - Required non-nullable fields
/// - Optional nullable fields
/// - Custom types (BorderSide, Duration, Color, custom themes)
/// - Fields with @ignore annotation
/// - Custom constructor name
@ShouldGenerateFile(
  'goldens/complex_theme_internal.g.theme.dart',
  partOfCurrent: true,
)
@ThemeGen(constructor: '_internal')
final class ComplexThemeInternal with _$ComplexThemeInternal {
  const ComplexThemeInternal._internal({
    required this.requiredInt,
    required this.requiredDouble,
    required this.requiredString,
    required this.requiredBool,
    required this.requiredDuration,
    required this.requiredColor,
    required this.requiredBorderSide,
    required this.requiredTheme,
    required this.requiredThemeExtension,
    required this.optionalInt,
    required this.optionalDouble,
    required this.optionalString,
    required this.optionalBool,
    required this.optionalDuration,
    required this.optionalColor,
    required this.optionalBorderSide,
    required this.optionalTheme,
    required this.optionalThemeExtension,
    required this.optionalLerpableWithOptionalResult,
    this.ignoredField,
  });

  factory ComplexThemeInternal.defaults() =>
      const ComplexThemeInternal._internal(
        requiredInt: 0,
        requiredDouble: 0,
        requiredString: '',
        requiredBool: false,
        requiredDuration: Duration.zero,
        requiredColor: Color(0x00000000),
        requiredBorderSide: BorderSide.none,
        requiredTheme: EmptyTheme(),
        requiredThemeExtension: EmptyThemeExtension(),
        optionalInt: null,
        optionalDouble: null,
        optionalString: null,
        optionalBool: null,
        optionalDuration: null,
        optionalColor: null,
        optionalBorderSide: null,
        optionalTheme: null,
        optionalThemeExtension: null,
        optionalLerpableWithOptionalResult: null,
        ignoredField: 'defaults',
      );

  // Required non-nullable fields
  final int requiredInt;
  final double requiredDouble;
  final String requiredString;
  final bool requiredBool;
  final Duration requiredDuration;
  final Color requiredColor;
  final BorderSide requiredBorderSide;
  final EmptyTheme requiredTheme;
  final EmptyThemeExtension requiredThemeExtension;

  // Optional nullable fields
  final int? optionalInt;
  final double? optionalDouble;
  final String? optionalString;
  final bool? optionalBool;
  final Duration? optionalDuration;
  final Color? optionalColor;
  final BorderSide? optionalBorderSide;
  final EmptyTheme? optionalTheme;
  final EmptyThemeExtension? optionalThemeExtension;
  final LerpableWithOptionalResult? optionalLerpableWithOptionalResult;

  // Ignored field - should not be in generated code
  @ignore
  final String? ignoredField;

  @override
  bool get canMerge => true;

  static ComplexThemeInternal? lerp(
    ComplexThemeInternal? a,
    ComplexThemeInternal? b,
    double t,
  ) => _$ComplexThemeInternal.lerp(a, b, t);
}

/// ThemeGen with required and optional fields
@ShouldGenerateFile('goldens/complex_theme.g.theme.dart', partOfCurrent: true)
@themeGen
final class ComplexTheme with _$ComplexTheme {
  const ComplexTheme({
    required this.requiredInt,
    required this.requiredDouble,
    required this.requiredString,
    required this.requiredBool,
    required this.requiredDuration,
    required this.requiredColor,
    required this.requiredBorderSide,
    required this.requiredTheme,
    required this.requiredThemeExtension,
    required this.optionalInt,
    required this.optionalDouble,
    required this.optionalString,
    required this.optionalBool,
    required this.optionalDuration,
    required this.optionalColor,
    required this.optionalBorderSide,
    required this.optionalTheme,
    required this.optionalThemeExtension,
    required this.optionalLerpableWithOptionalResult,
    this.ignoredField = 'ignored',
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
  final EmptyThemeExtension requiredThemeExtension;

  // Optional nullable fields
  final int? optionalInt;
  final double? optionalDouble;
  final String? optionalString;
  final bool? optionalBool;
  final Duration? optionalDuration;
  final Color? optionalColor;
  final BorderSide? optionalBorderSide;
  final EmptyTheme? optionalTheme;
  final EmptyThemeExtension? optionalThemeExtension;
  final LerpableWithOptionalResult? optionalLerpableWithOptionalResult;

  @ignore
  final String ignoredField;

  @override
  bool get canMerge => true;

  static ComplexTheme? lerp(ComplexTheme? a, ComplexTheme? b, double t) =>
      _$ComplexTheme.lerp(a, b, t);
}
