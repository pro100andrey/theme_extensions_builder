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
    required this.test,
    this.borderRadius,
    this.radius = 5,
  });

  final BorderRadius? borderRadius;
  final MaterialStateProperty<Color> test;
  final double radius;
  final Color backgroundColor;
  final Color foregroundColor;
}
