import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'button_theme.g.theme.dart';

enum ButtonVariant { primary, secondary, outlined, text }

enum ButtonSize { small, medium, large }

@themeExtensions
class ButtonThemeExtension extends ThemeExtension<ButtonThemeExtension>
    with _$ButtonThemeExtension {
  const ButtonThemeExtension({
    required this.primaryColor,
    required this.secondaryColor,
    required this.outlinedBorderColor,
    required this.textColor,
    required this.disabledColor,
    required this.smallPadding,
    required this.mediumPadding,
    required this.largePadding,
    required this.smallHeight,
    required this.mediumHeight,
    required this.largeHeight,
    required this.borderRadius,
    required this.borderWidth,
    this.elevation = 2.0,
    this.iconSpacing = 8.0,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color outlinedBorderColor;
  final Color textColor;
  final Color disabledColor;
  final EdgeInsets smallPadding;
  final EdgeInsets mediumPadding;
  final EdgeInsets largePadding;
  final double smallHeight;
  final double mediumHeight;
  final double largeHeight;
  final BorderRadius borderRadius;
  final double borderWidth;
  final double elevation;
  final double iconSpacing;
}
