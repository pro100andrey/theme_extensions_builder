import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'elevated_button.g.theme.dart';

@themeExtensions
class ElevatedButtonThemeExtension
    extends ThemeExtension<ElevatedButtonThemeExtension>
    with _$ThemeExtensionMixin {
  const ElevatedButtonThemeExtension({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderRadius,
  });

  factory ElevatedButtonThemeExtension.primary() =>
      const ElevatedButtonThemeExtension(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      );

  factory ElevatedButtonThemeExtension.secondary() =>
      const ElevatedButtonThemeExtension(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      );

  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;
}
