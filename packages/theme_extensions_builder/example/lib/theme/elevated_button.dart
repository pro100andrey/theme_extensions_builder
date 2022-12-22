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

  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;
}
