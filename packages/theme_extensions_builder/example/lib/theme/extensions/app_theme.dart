import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_theme.g.theme.dart';

enum LayoutMode { compact, expanded }

@themeExtensions
class AppThemeExtension extends ThemeExtension<AppThemeExtension>
    with _$AppThemeExtension {
  const AppThemeExtension({
    required this.primaryColor,
    required this.backgroundColor,
    required this.layoutMode,
    required this.borderSide,
    required this.optionalBorderSide,
  });

  final Color primaryColor;
  final Color backgroundColor;
  final LayoutMode layoutMode;
  final BorderSide borderSide;
  final BorderSide? optionalBorderSide;
}
